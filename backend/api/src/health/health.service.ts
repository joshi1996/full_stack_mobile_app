import {
  Inject,
  Injectable,
  ServiceUnavailableException,
} from '@nestjs/common';
import { sql } from 'drizzle-orm';
import { DATABASE, type Database } from '../database/database.provider.js';

const DATABASE_STATEMENT_TIMEOUT = '1000ms';
const READINESS_TIMEOUT_MS = 1500;

@Injectable()
export class HealthService {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  async checkDatabase(): Promise<{ status: 'ready' }> {
    let timeout: NodeJS.Timeout | undefined;
    try {
      const query = this.database.transaction(
        async (transaction) => {
          await transaction.execute(
            sql`SELECT set_config('statement_timeout', ${DATABASE_STATEMENT_TIMEOUT}, true)`,
          );
          await transaction.execute(sql`SELECT 1`);
        },
        { accessMode: 'read only' },
      );

      await Promise.race([
        query,
        new Promise<never>((_, reject) => {
          timeout = setTimeout(
            () => reject(new Error('Database readiness check timed out')),
            READINESS_TIMEOUT_MS,
          );
        }),
      ]);
      return { status: 'ready' };
    } catch {
      throw new ServiceUnavailableException({ status: 'not_ready' });
    } finally {
      if (timeout) clearTimeout(timeout);
    }
  }
}

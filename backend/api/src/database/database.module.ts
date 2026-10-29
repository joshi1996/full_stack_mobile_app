import {
  Global,
  Inject,
  Injectable,
  Module,
  OnModuleDestroy,
} from '@nestjs/common';
import { databaseProvider } from './database.provider.js';
import { DATABASE, type Database } from './database.provider.js';

@Injectable()
class DatabaseLifecycle implements OnModuleDestroy {
  constructor(@Inject(DATABASE) private readonly database: Database) {}

  async onModuleDestroy(): Promise<void> {
    await this.database.$client.end({ timeout: 5 });
  }
}

@Global()
@Module({
  providers: [databaseProvider, DatabaseLifecycle],
  exports: [databaseProvider],
})
export class DatabaseModule {}

import { Provider } from '@nestjs/common';
import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';
import { ConfigService } from '@nestjs/config';

export const DATABASE = 'DATABASE';

export type Database = ReturnType<typeof drizzle> & {
  $client: ReturnType<typeof postgres>;
};

export const databaseProvider: Provider = {
  provide: DATABASE,
  inject: [ConfigService],

  useFactory: (configService: ConfigService) => {
    const connectionString = configService.getOrThrow<string>('DATABASE_URL');

    const client = postgres(connectionString);

    return drizzle(client);
  },
};

import { ConfigModule, ConfigService } from '@nestjs/config';
import { jest } from '@jest/globals';
import { Test } from '@nestjs/testing';
import { DATABASE, type Database } from './database.provider.js';
import { DatabaseModule } from './database.module.js';

describe('DatabaseModule', () => {
  it('exports an injectable database and closes its client on module shutdown', async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({ isGlobal: true, ignoreEnvFile: true }),
        DatabaseModule,
      ],
    })
      .overrideProvider(ConfigService)
      .useValue({
        getOrThrow: () =>
          'postgres://postgres:postgres@localhost:5434/commerce',
      })
      .compile();

    const database = moduleRef.get<Database>(DATABASE);
    const closeClient = jest.spyOn(database.$client, 'end');

    expect(database).toBeDefined();
    await moduleRef.close();

    expect(closeClient).toHaveBeenCalledWith({ timeout: 5 });
  });
});

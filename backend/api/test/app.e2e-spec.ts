import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types';
import { jest } from '@jest/globals';
import { AppModule } from './../src/app.module';
import { DATABASE } from './../src/database/database.provider';

describe('AppController (e2e)', () => {
  let app: INestApplication<App>;
  let database: {
    transaction: jest.Mock;
    $client: { end: jest.Mock };
  };

  beforeEach(async () => {
    database = {
      transaction: jest.fn(
        async (
          callback: (transaction: { execute: jest.Mock }) => Promise<unknown>,
        ) => callback({ execute: jest.fn().mockResolvedValue([]) }),
      ),
      $client: { end: jest.fn().mockResolvedValue(undefined) },
    };

    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(DATABASE)
      .useValue(database)
      .compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/ (GET)', () => {
    return request(app.getHttpServer())
      .get('/')
      .expect(200)
      .expect('Hello World!');
  });

  it('/health/live (GET) does not depend on the database', () => {
    database.transaction.mockRejectedValue(new Error('database unavailable'));

    return request(app.getHttpServer())
      .get('/health/live')
      .expect(200)
      .expect({ status: 'ok' });
  });

  it('/health/ready (GET) reports a healthy database', () => {
    return request(app.getHttpServer())
      .get('/health/ready')
      .expect(200)
      .expect({ status: 'ready' });
  });

  it('/health/ready (GET) hides database errors and returns 503', () => {
    database.transaction.mockRejectedValue(
      new Error('connection failed: secret database details'),
    );

    return request(app.getHttpServer())
      .get('/health/ready')
      .expect(503)
      .expect({ status: 'not_ready' });
  });

  it('/health/ready (GET) returns 503 when the check exceeds its deadline', () => {
    database.transaction.mockImplementation(() => new Promise(() => {}));

    return request(app.getHttpServer())
      .get('/health/ready')
      .expect(503)
      .expect({ status: 'not_ready' });
  }, 5000);

  afterEach(async () => {
    await app.close();
  });
});

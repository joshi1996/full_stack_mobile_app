import { INestApplication } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';
import { jest } from '@jest/globals';
import request from 'supertest';
import { App } from 'supertest/types';
import { AppModule } from '../src/app.module.js';
import { DATABASE } from '../src/database/database.provider.js';

const TEST_PASSWORD = 'correct-horse-battery-staple';

describe('Authentication (e2e)', () => {
  let app: INestApplication<App>;
  let currentUser:
    | {
        id: string;
        name: string;
        email: string;
        password: string;
        isActive: boolean;
      }
    | undefined;
  let passwordHash: string;

  const database = {
    $client: { end: jest.fn(async () => undefined) },
    select: jest.fn(() => ({
      from: jest.fn(() => ({
        where: jest.fn(() => ({
          limit: jest.fn(async () => (currentUser ? [currentUser] : [])),
        })),
      })),
    })),
  };

  beforeAll(async () => {
    passwordHash = await argon2.hash(TEST_PASSWORD, {
      type: argon2.argon2id,
    });
    currentUser = {
      id: 'de5bc2c4-7e86-4b4f-98c0-19a6f5bc9921',
      name: 'Test User',
      email: 'customer@example.com',
      password: passwordHash,
      isActive: true,
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

  afterAll(async () => {
    await app.close();
  });

  it('logs in and returns a signed token with public user data only', async () => {
    const response = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: ' CUSTOMER@EXAMPLE.COM ', password: TEST_PASSWORD })
      .expect(201);

    expect(response.body).toMatchObject({
      tokenType: 'Bearer',
      expiresIn: 600,
      user: {
        id: currentUser?.id,
        name: currentUser?.name,
        email: currentUser?.email,
      },
    });
    expect(response.body.user).not.toHaveProperty('password');
    expect(response.body.accessToken).toEqual(expect.any(String));
  });

  it('rejects invalid credentials with a generic response', async () => {
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: currentUser?.email, password: 'incorrect' })
      .expect(401)
      .expect({
        statusCode: 401,
        message: 'Invalid email or password',
        error: 'Unauthorized',
      });
  });

  it('rejects disabled accounts with the same generic response', async () => {
    currentUser = { ...currentUser!, isActive: false };
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: currentUser.email, password: TEST_PASSWORD })
      .expect(401)
      .expect({
        statusCode: 401,
        message: 'Invalid email or password',
        error: 'Unauthorized',
      });
    currentUser = { ...currentUser, isActive: true };
  });

  it('rejects malformed login bodies', async () => {
    await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'not-an-email', password: '' })
      .expect(400)
      .expect({
        statusCode: 400,
        message: 'Invalid request body',
        error: 'Bad Request',
      });
  });

  it('returns the current public user for a valid bearer token', async () => {
    const login = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: currentUser?.email, password: TEST_PASSWORD })
      .expect(201);

    await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', `Bearer ${login.body.accessToken}`)
      .expect(200)
      .expect({
        user: {
          id: currentUser?.id,
          name: currentUser?.name,
          email: currentUser?.email,
        },
      });
  });

  it('rejects a missing bearer token', async () => {
    await request(app.getHttpServer()).get('/auth/me').expect(401);
  });

  it('rejects a malformed bearer token', async () => {
    await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', 'Bearer not-a-jwt')
      .expect(401);
  });

  it('rejects a tampered bearer token', async () => {
    const jwtService = app.get(JwtService);
    const token = await jwtService.signAsync({ sub: currentUser?.id });
    const [header, payload, signature] = token.split('.');
    const tamperedToken = [
      header,
      payload,
      `${signature?.startsWith('a') ? 'b' : 'a'}${signature?.slice(1)}`,
    ].join('.');

    await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', `Bearer ${tamperedToken}`)
      .expect(401);
  });

  it('rejects an expired bearer token', async () => {
    const jwtService = app.get(JwtService);
    const token = await jwtService.signAsync(
      { sub: currentUser?.id },
      { expiresIn: -1 },
    );

    await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', `Bearer ${token}`)
      .expect(401);
  });

  it('rejects a valid token when the user is no longer active', async () => {
    const jwtService = app.get(JwtService);
    const token = await jwtService.signAsync({ sub: currentUser?.id });
    currentUser = { ...currentUser!, isActive: false };

    await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', `Bearer ${token}`)
      .expect(401);
  });

  it('rejects a valid token when the user no longer exists', async () => {
    const jwtService = app.get(JwtService);
    const token = await jwtService.signAsync({ sub: currentUser?.id });
    currentUser = undefined;

    await request(app.getHttpServer())
      .get('/auth/me')
      .set('Authorization', `Bearer ${token}`)
      .expect(401);
  });
});

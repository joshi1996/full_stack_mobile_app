import { JwtService } from '@nestjs/jwt';
import * as argon2 from 'argon2';
import type { Database } from '../database/database.provider.js';
import { AuthService } from './auth.service.js';

const TEST_PASSWORD = 'correct-horse-battery-staple';
const TEST_SECRET = 'unit-test-signing-secret-that-is-at-least-32-characters';
const TEST_USER = {
  id: 'de5bc2c4-7e86-4b4f-98c0-19a6f5bc9921',
  name: 'Test User',
  email: 'customer@example.com',
  isActive: true,
  password: '',
};

describe('AuthService', () => {
  let service: AuthService;
  let currentUser: typeof TEST_USER | undefined;

  beforeAll(async () => {
    TEST_USER.password = await argon2.hash(TEST_PASSWORD, {
      type: argon2.argon2id,
    });
  });

  beforeEach(() => {
    currentUser = { ...TEST_USER };
    const database = {
      select: () => ({
        from: () => ({
          where: () => ({
            limit: async () => (currentUser ? [currentUser] : []),
          }),
        }),
      }),
    } as unknown as Database;

    service = new AuthService(
      database,
      new JwtService({
        secret: TEST_SECRET,
        signOptions: {
          algorithm: 'HS256',
          expiresIn: '10m',
          issuer: 'commerce-api',
          audience: 'commerce-app',
        },
      }),
    );
  });

  it('issues a signed token and returns only public user fields', async () => {
    const response = await service.login({
      email: ' CUSTOMER@EXAMPLE.COM ',
      password: TEST_PASSWORD,
    });

    expect(response.user).toEqual({
      id: TEST_USER.id,
      name: TEST_USER.name,
      email: TEST_USER.email,
    });
    expect(response).not.toHaveProperty('password');
    expect(response.expiresIn).toBe(600);
    await expect(
      new JwtService({ secret: TEST_SECRET }).verifyAsync(response.accessToken),
    ).resolves.toMatchObject({ sub: TEST_USER.id });
  });

  it('uses one generic response for unknown emails and invalid passwords', async () => {
    currentUser = undefined;
    await expect(
      service.login({ email: 'missing@example.com', password: 'wrong' }),
    ).rejects.toThrow('Invalid email or password');

    currentUser = { ...TEST_USER };
    await expect(
      service.login({ email: TEST_USER.email, password: 'wrong' }),
    ).rejects.toThrow('Invalid email or password');
  });

  it('rejects inactive accounts with the same generic response', async () => {
    currentUser = { ...TEST_USER, isActive: false };

    await expect(
      service.login({ email: TEST_USER.email, password: TEST_PASSWORD }),
    ).rejects.toThrow('Invalid email or password');
  });
});

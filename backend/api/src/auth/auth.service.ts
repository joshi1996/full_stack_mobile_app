import { Injectable, UnauthorizedException, Inject } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { eq } from 'drizzle-orm';
import * as argon2 from 'argon2';
import { DATABASE, type Database } from '../database/database.provider.js';
import { users } from '../database/schema/users.schema.js';
import type {
  AccessTokenPayload,
  LoginResponse,
  PublicUser,
} from './auth.types.js';
import type { LoginDto } from './dto/login.dto.js';

const ACCESS_TOKEN_TTL_SECONDS = 600;
const INVALID_CREDENTIALS_MESSAGE = 'Invalid email or password';
const DUMMY_PASSWORD = 'commerce-auth-nonexistent-user';

@Injectable()
export class AuthService {
  private readonly dummyPasswordHash = argon2.hash(DUMMY_PASSWORD, {
    type: argon2.argon2id,
  });

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly jwtService: JwtService,
  ) {}

  async login(credentials: LoginDto): Promise<LoginResponse> {
    const normalizedEmail = credentials.email.trim().toLowerCase();
    const [user] = await this.database
      .select({
        id: users.id,
        name: users.name,
        email: users.email,
        password: users.password,
        isActive: users.isActive,
      })
      .from(users)
      .where(eq(users.email, normalizedEmail))
      .limit(1);

    const passwordHash = user?.password ?? (await this.dummyPasswordHash);
    const passwordMatches = await this.verifyPassword(
      passwordHash,
      credentials.password,
    );

    if (!user || !passwordMatches || !user.isActive) {
      throw new UnauthorizedException(INVALID_CREDENTIALS_MESSAGE);
    }

    const accessToken = await this.jwtService.signAsync({ sub: user.id });

    return {
      accessToken,
      tokenType: 'Bearer',
      expiresIn: ACCESS_TOKEN_TTL_SECONDS,
      user: this.toPublicUser(user),
    };
  }

  async authenticateAccessToken(token: string): Promise<PublicUser> {
    let payload: AccessTokenPayload;
    try {
      payload = await this.jwtService.verifyAsync<AccessTokenPayload>(token, {
        algorithms: ['HS256'],
        issuer: 'commerce-api',
        audience: 'commerce-app',
      });
    } catch {
      throw new UnauthorizedException();
    }

    if (typeof payload.sub !== 'string') {
      throw new UnauthorizedException();
    }

    const [user] = await this.database
      .select({
        id: users.id,
        name: users.name,
        email: users.email,
        isActive: users.isActive,
      })
      .from(users)
      .where(eq(users.id, payload.sub))
      .limit(1);

    if (!user?.isActive) {
      throw new UnauthorizedException();
    }

    return this.toPublicUser(user);
  }

  private async verifyPassword(
    encodedHash: string,
    password: string,
  ): Promise<boolean> {
    try {
      return await argon2.verify(encodedHash, password);
    } catch {
      // Legacy plaintext or unsupported hash values must fail closed.
      return false;
    }
  }

  private toPublicUser(user: {
    id: string;
    name: string;
    email: string;
  }): PublicUser {
    return { id: user.id, name: user.name, email: user.email };
  }
}

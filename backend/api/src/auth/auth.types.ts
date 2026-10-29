import type { Request } from 'express';

export interface PublicUser {
  id: string;
  name: string;
  email: string;
}

export interface AuthenticatedRequest extends Request {
  user: PublicUser;
}

export interface AccessTokenPayload {
  sub: string;
  iat?: number;
  exp?: number;
  iss?: string;
  aud?: string | string[];
}

export interface LoginResponse {
  accessToken: string;
  tokenType: 'Bearer';
  expiresIn: number;
  user: PublicUser;
}

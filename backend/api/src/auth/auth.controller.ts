import { Body, Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service.js';
import type { AuthenticatedRequest, LoginResponse } from './auth.types.js';
import { LoginDto, loginDtoSchema } from './dto/login.dto.js';
import { JoiValidationPipe } from './pipes/joi-validation.pipe.js';
import { AccessTokenGuard } from './guards/access-token.guard.js';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  login(
    @Body(new JoiValidationPipe(loginDtoSchema)) credentials: LoginDto,
  ): Promise<LoginResponse> {
    return this.authService.login(credentials);
  }

  @Get('me')
  @UseGuards(AccessTokenGuard)
  getCurrentUser(@Req() request: AuthenticatedRequest) {
    return { user: request.user };
  }
}

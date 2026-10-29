import Joi from 'joi';

export class LoginDto {
  email!: string;
  password!: string;
}

export const loginDtoSchema = Joi.object<LoginDto>({
  email: Joi.string().trim().email().max(255).required(),
  password: Joi.string().min(1).max(1024).required(),
}).required();

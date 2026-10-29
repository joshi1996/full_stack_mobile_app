import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import type { ObjectSchema } from 'joi';

@Injectable()
export class JoiValidationPipe<T> implements PipeTransform<unknown, T> {
  constructor(private readonly schema: ObjectSchema<T>) {}

  transform(value: unknown): T {
    const result = this.schema.validate(value, { abortEarly: false });
    if (result.error) {
      throw new BadRequestException('Invalid request body');
    }

    return result.value;
  }
}

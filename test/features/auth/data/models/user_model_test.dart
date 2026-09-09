import 'package:flutter_test/flutter_test.dart';

import 'package:full_stack_mobile_app/features/auth/data/models/user_model.dart';

void main() {
  test('UserModel.fromJson creates model correctly', () {
    final json = {'id': '1', 'email': 'amit@example.com', 'name': 'Amit'};

    final model = UserModel.fromJson(json);

    expect(model.id, '1');
    expect(model.email, 'amit@example.com');
    expect(model.name, 'Amit');
  });

  test('UserModel.toJson creates correct JSON', () {
    const model = UserModel(id: '1', email: 'amit@example.com', name: 'Amit');

    expect(model.toJson(), {
      'id': '1',
      'email': 'amit@example.com',
      'name': 'Amit',
    });
  });

  test('UserModel converts to User entity', () {
    const model = UserModel(id: '1', email: 'amit@example.com', name: 'Amit');

    final entity = model.toEntity();

    expect(entity.id, '1');
    expect(entity.email, 'amit@example.com');
    expect(entity.name, 'Amit');
  });
}

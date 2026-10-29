import 'package:flutter_test/flutter_test.dart';
import 'package:full_stack_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';

class _MemorySecureStore implements SecureKeyValueStore {
  final Map<String, String> values = {};
  String? failingOperation;

  @override
  Future<String?> read(String key) async {
    if (failingOperation == 'read') throw StateError('private storage detail');
    return values[key];
  }

  @override
  Future<void> write(String key, String value) async {
    if (failingOperation == 'write') throw StateError('private storage detail');
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    if (failingOperation == 'delete') {
      throw StateError('private storage detail');
    }
    values.remove(key);
  }
}

void main() {
  late _MemorySecureStore secureStore;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() {
    secureStore = _MemorySecureStore();
    dataSource = AuthLocalDataSourceImpl(secureStore);
  });

  test('stores only the access token under its secure key', () async {
    await dataSource.saveAccessToken('signed-access-token');

    expect(await dataSource.readAccessToken(), 'signed-access-token');
    expect(secureStore.values, {'auth_access_token': 'signed-access-token'});
  });

  test('clears stored credentials', () async {
    await dataSource.saveAccessToken('signed-access-token');
    await dataSource.clearAccessToken();

    expect(await dataSource.readAccessToken(), isNull);
    expect(secureStore.values, isEmpty);
  });

  test('maps secure storage errors without exposing plugin details', () async {
    secureStore.failingOperation = 'write';

    await expectLater(
      dataSource.saveAccessToken('signed-access-token'),
      throwsA(
        isA<Exception>().having(
          (exception) => exception.toString(),
          'message',
          isNot(contains('private storage detail')),
        ),
      ),
    );
  });
}

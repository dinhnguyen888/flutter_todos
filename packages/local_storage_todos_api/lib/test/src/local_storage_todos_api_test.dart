// ignore_for_file: prefer_const_constructors
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group('LocalStorageTodosApi', () {
    test('can be instantiated', () async {
      expect(
        LocalStorageTodosApi(plugin: await SharedPreferences.getInstance()),
        isNotNull,
      );
    });
  });
}

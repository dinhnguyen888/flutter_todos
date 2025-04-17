// ignore_for_file: prefer_const_constructors
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';
import 'package:todos_api/todos_api.dart';

void main() {
  group('TodosApi', () {
    test('can be instantiated', () async {
      expect(
        LocalStorageTodosApi(plugin: await SharedPreferences.getInstance()),
        isNotNull,
      );
    });
  });
}

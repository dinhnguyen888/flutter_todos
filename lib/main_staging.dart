import 'package:flutter/cupertino.dart';
import 'package:flutter_todos/app/app.dart';
import 'package:flutter_todos/bootstrap.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorageTodosApi = LocalStorageTodosApi(
    plugin: await SharedPreferences.getInstance(),
  );
  await bootstrap(todosApi: localStorageTodosApi);
}

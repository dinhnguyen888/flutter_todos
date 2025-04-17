import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_api/todos_api.dart';

/// {@template local_storage_todos_api}
/// A Flutter implementation of the TodosApi that uses local storage.
/// {@endtemplate}
class LocalStorageTodosApi extends TodosApi {
  /// {@macro local_storage_todos_api}
  LocalStorageTodosApi({required SharedPreferences plugin}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;
  //The purpose of using a seeded BehaviorSubject is to provide an initial state
  //or value to subscribers immediately upon subscription
  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  /// The key used for storing the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kTodoCollectionKey = '__todos_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    //Get the todos from the local storage
    final jsonTodos = _getValue(kTodoCollectionKey);
    if (jsonTodos != null) {
      final todos =
          List<Map<dynamic, dynamic>>.from(json.decode(jsonTodos) as List)
              .map(
                (jsonMap) => Todo.fromJson(
                  Map<String, dynamic>.from(jsonMap),
                ),
              )
              .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Future<int> clearCompleted() async {
    final todos = [..._todoStreamController.value];
    final changedTodosAmount = todos.where((t) => t.isCompleted).length;
    todos.removeWhere((t) => t.isCompleted);
    _todoStreamController.add(todos);
    await _setValue(kTodoCollectionKey, jsonEncode(todos));
    return changedTodosAmount;
  }

  @override
  Future<int> completeAll() async {
    final todos = [..._todoStreamController.value];
    final changedTodosAmount = todos.where((t) => !t.isCompleted).length;
    final newTodos = [
      for (final todo in todos) todo.copyWith(isCompleted: true),
    ];
    _todoStreamController.add(newTodos);
    await _setValue(kTodoCollectionKey, jsonEncode(newTodos));
    return changedTodosAmount;
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
    }
    _todoStreamController.add(todos);
    return _setValue(kTodoCollectionKey, jsonEncode(todos));
  }

  @override
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    //To determine if we are updating a todo or adding a new one.
    if (todoIndex >= 0) {
      todos[todoIndex] = todo; //update
    } else {
      todos.add(todo); //add
    }
    _todoStreamController.add(todos);
    return _setValue(kTodoCollectionKey, jsonEncode(todos));
  }
}

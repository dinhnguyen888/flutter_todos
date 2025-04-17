import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_api/todos_api.dart';

/// {@template local_storage_todos_api}
/// Triển khai [TodosApi] sử dụng local storage để lưu trữ todos
/// Sử dụng SharedPreferences để lưu dữ liệu dạng key-value
/// Dữ liệu được lưu dưới dạng JSON string
/// {@endtemplate}
class LocalStorageTodosApi extends TodosApi {
  /// {@macro local_storage_todos_api}
  LocalStorageTodosApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  /// Plugin SharedPreferences để đọc/ghi dữ liệu
  final SharedPreferences _plugin;

  /// Stream controller để quản lý và phát dữ liệu todos
  /// Sử dụng BehaviorSubject để luôn có giá trị mới nhất
  /// Khởi tạo với list rỗng
  late final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(
    const [],
  );

  /// The key used for storing the todos locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kTodosCollectionKey = '__todos_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  /// Khởi tạo dữ liệu ban đầu
  /// - Đọc JSON string từ SharedPreferences
  /// - Chuyển đổi JSON thành danh sách todos
  /// - Nếu không có dữ liệu, khởi tạo list rỗng
  void _init() {
    final todosJson = _getValue(kTodosCollectionKey);
    if (todosJson != null) {
      final todos = List<Map<dynamic, dynamic>>.from(
        json.decode(todosJson) as List,
      )
          .map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override

  /// Lưu một todo vào storage
  /// Quy trình:
  /// 1. Lấy danh sách hiện tại
  /// 2. Kiểm tra xem todo đã tồn tại chưa (dựa vào id)
  /// 3. Nếu tồn tại thì cập nhật, không thì thêm mới
  /// 4. Cập nhật stream và lưu xuống SharedPreferences
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }

    _todoStreamController.add(todos);
    return _setValue(kTodosCollectionKey, json.encode(todos));
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return _setValue(kTodosCollectionKey, json.encode(todos));
    }
  }

  @override

  /// Xóa tất cả các todo đã hoàn thành
  /// Trả về số lượng todo đã bị xóa
  /// Quy trình:
  /// 1. Lấy danh sách hiện tại
  /// 2. Ghi nhớ độ dài ban đầu
  /// 3. Xóa các todo có isCompleted = true
  /// 4. Cập nhật stream và lưu thay đổi
  Future<int> clearCompleted() async {
    final todos = [..._todoStreamController.value];
    final initialLength = todos.length;

    todos.removeWhere((t) => t.isCompleted);
    final completedTodosAmount = initialLength - todos.length;

    _todoStreamController.add(todos);
    await _setValue(kTodosCollectionKey, json.encode(todos));
    return completedTodosAmount;
  }

  @override
  Future<int> completeAll({required bool isCompleted}) async {
    final todos = [..._todoStreamController.value];
    final changedTodosAmount =
        todos.where((t) => t.isCompleted != isCompleted).length;
    final newTodos = [
      for (final todo in todos) todo.copyWith(isCompleted: isCompleted),
    ];
    _todoStreamController.add(newTodos);
    await _setValue(kTodosCollectionKey, json.encode(newTodos));
    return changedTodosAmount;
  }

  @override
  Future<void> close() {
    return _todoStreamController.close();
  }
}

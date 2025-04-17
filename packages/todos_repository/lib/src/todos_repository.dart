import 'package:todos_api/todos_api.dart';

/// {@template todos_repository}
/// Repository layer - Lớp trung gian xử lý các yêu cầu liên quan đến todos
///
/// Lớp này đóng vai trò:
/// - Là cầu nối giữa tầng UI (bloc) và tầng data (API)
/// - Che giấu chi tiết implement của data source
/// - Dễ dàng thay đổi data source mà không ảnh hưởng tới UI
/// {@endtemplate}
class TodosRepository {
  /// {@macro todos_repository}
  const TodosRepository({
    required TodosApi todosApi,
  }) : _todosApi = todosApi;

  /// Instance của TodosApi để thao tác với data source
  /// Có thể là LocalStorageTodosApi hoặc bất kỳ implement nào khác của TodosApi
  final TodosApi _todosApi;

  /// Lấy Stream chứa danh sách todos
  /// Stream sẽ emit giá trị mới mỗi khi danh sách thay đổi
  Stream<List<Todo>> getTodos() => _todosApi.getTodos();

  /// Lưu một todo
  /// Nếu todo đã tồn tại (trùng id) sẽ được cập nhật
  /// Nếu chưa tồn tại sẽ được thêm mới
  Future<void> saveTodo(Todo todo) => _todosApi.saveTodo(todo);

  /// Xóa todo với id được chỉ định
  /// Throws [TodoNotFoundException] nếu không tìm thấy todo
  Future<void> deleteTodo(String id) => _todosApi.deleteTodo(id);

  /// Xóa tất cả các todo đã hoàn thành
  /// Trả về số lượng todo đã bị xóa
  Future<int> clearCompleted() => _todosApi.clearCompleted();

  /// Cập nhật trạng thái hoàn thành cho tất cả todos
  /// @param isCompleted: true để đánh dấu tất cả hoàn thành
  ///                    false để đánh dấu tất cả chưa hoàn thành
  /// Trả về số lượng todo đã được cập nhật
  Future<int> completeAll({required bool isCompleted}) =>
      _todosApi.completeAll(isCompleted: isCompleted);

  /// Giải phóng tài nguyên khi không còn sử dụng repository
  void dispose() => _todosApi.close();
}

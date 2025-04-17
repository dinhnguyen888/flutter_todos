import 'package:todos_api/todos_api.dart';

/// {@template todos_api}
/// Interface định nghĩa các phương thức để thao tác với danh sách todos
/// Đây là lớp trừu tượng (abstract) để các lớp khác kế thừa và triển khai
/// {@endtemplate}
abstract class TodosApi {
  /// {@macro todos_api}
  const TodosApi();

  /// Trả về một [Stream] chứa danh sách tất cả các todo
  /// Stream sẽ cập nhật liên tục khi có thay đổi trong danh sách
  Stream<List<Todo>> getTodos();

  /// Lưu một [todo] vào storage
  ///
  /// Nếu đã tồn tại todo có cùng id, todo cũ sẽ bị ghi đè
  Future<void> saveTodo(Todo todo);

  /// Xóa todo với id được chỉ định
  ///
  /// Nếu không tìm thấy todo với id tương ứng,
  /// sẽ ném ra ngoại lệ [TodoNotFoundException]
  Future<void> deleteTodo(String id);

  /// Xóa tất cả các todo đã hoàn thành
  ///
  /// Trả về số lượng todo đã bị xóa
  Future<int> clearCompleted();

  /// Đặt trạng thái hoàn thành cho tất cả các todo
  ///
  /// @param isCompleted: true để đánh dấu tất cả là hoàn thành
  ///                    false để đánh dấu tất cả là chưa hoàn thành
  /// Trả về số lượng todo đã được cập nhật
  Future<int> completeAll({required bool isCompleted});

  /// Đóng kết nối và giải phóng tài nguyên
  /// Cần gọi khi không sử dụng API nữa
  Future<void> close();
}

/// Ngoại lệ được ném ra khi không tìm thấy [Todo] với id cụ thể
/// Dùng để xử lý lỗi khi thao tác với todo không tồn tại
class TodoNotFoundException implements Exception {}

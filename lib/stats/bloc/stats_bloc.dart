// Import các package cần thiết để xây dựng Bloc.
import 'package:bloc/bloc.dart'; // Cung cấp cơ chế Bloc.
import 'package:equatable/equatable.dart'; // Hỗ trợ so sánh object trong Bloc.
import 'package:todos_repository/todos_repository.dart'; // Repository chứa danh sách todos.

// Kết nối phần event và state vào bloc (tách biệt để code rõ ràng, dễ maintain).
part 'stats_event.dart'; // Chứa định nghĩa các sự kiện (event).
part 'stats_state.dart'; // Chứa định nghĩa các trạng thái (state).

// StatsBloc là lớp chính để quản lý logic hiển thị số lượng todo hoàn thành và chưa hoàn thành.
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  // Constructor nhận vào TodosRepository (nguồn dữ liệu).
  StatsBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository, // Lưu lại reference tới repository.
        super(const StatsState()) {
    // Khởi tạo Bloc với state mặc định.
    // Đăng ký xử lý sự kiện StatsSubscriptionRequested bằng phương thức _onSubscriptionRequested
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  // Repository được dùng để lấy dữ liệu todo (dạng Stream).
  final TodosRepository _todosRepository;

  // Hàm xử lý khi sự kiện StatsSubscriptionRequested được gọi.
  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event, // Sự kiện được phát ra.
    Emitter<StatsState> emit, // Dùng để phát ra các trạng thái mới.
  ) async {
    // Trạng thái đầu tiên là loading (đang tải dữ liệu).
    emit(state.copyWith(status: StatsStatus.loading));

    // Lắng nghe stream danh sách todo từ repository.
    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(), // Gọi hàm trả về stream danh sách todo.
      // Khi có dữ liệu mới từ stream (onData):
      onData: (todos) => state.copyWith(
        status: StatsStatus.success, // Trạng thái thành công.
        completedTodos: todos
            .where((todo) => todo.isCompleted)
            .length, // Đếm số todo đã hoàn thành.
        activeTodos: todos
            .where((todo) => !todo.isCompleted)
            .length, // Đếm số todo đang hoạt động.
      ),
      // Nếu có lỗi trong khi stream:
      onError: (_, __) => state.copyWith(
          status: StatsStatus.failure), // Phát ra trạng thái thất bại.
    );
  }
}

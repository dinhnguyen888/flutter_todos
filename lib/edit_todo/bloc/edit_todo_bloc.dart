import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'edit_todo_event.dart';
part 'edit_todo_state.dart';

/// Bloc xử lý logic chỉnh sửa và tạo mới todo
class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc({
    required TodosRepository todosRepository,
    required Todo? initialTodo, // null nếu tạo mới, có giá trị nếu chỉnh sửa
  })  : _todosRepository = todosRepository,
        super(
          EditTodoState(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '', // Lấy title từ todo cũ hoặc rỗng
            description: initialTodo?.description ??
                '', // Lấy description từ todo cũ hoặc rỗng
          ),
        ) {
    // Đăng ký các event handlers
    on<EditTodoTitleChanged>(_onTitleChanged); // Xử lý khi tiêu đề thay đổi
    on<EditTodoDescriptionChanged>(
        _onDescriptionChanged); // Xử lý khi mô tả thay đổi
    on<EditTodoSubmitted>(_onSubmitted); // Xử lý khi lưu todo
  }

  final TodosRepository _todosRepository;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  /// Xử lý khi người dùng nhấn lưu todo
  /// - Cập nhật trạng thái loading
  /// - Tạo todo mới hoặc cập nhật todo cũ với thông tin mới
  /// - Lưu vào repository
  /// - Cập nhật trạng thái thành công/thất bại
  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}

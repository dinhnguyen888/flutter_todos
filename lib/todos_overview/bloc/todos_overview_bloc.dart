import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos_main/todos_overview/models/todos_view_filter.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';
part 'todos_overview_state.dart';

/// Bloc xử lý logic chính cho màn hình tổng quan các công việc
class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodosOverviewState()) {
    // Đăng ký các event handlers
    on<TodosOverviewSubscriptionRequested>(
        _onSubscriptionRequested); // Lắng nghe thay đổi danh sách todo
    on<TodosOverviewTodoCompletionToggled>(
        _onTodoCompletionToggled); // Cập nhật trạng thái hoàn thành
    on<TodosOverviewTodoDeleted>(_onTodoDeleted); // Xóa todo
    on<TodosOverviewUndoDeletionRequested>(
        _onUndoDeletionRequested); // Hoàn tác xóa
    on<TodosOverviewFilterChanged>(_onFilterChanged); // Thay đổi bộ lọc
    on<TodosOverviewToggleAllRequested>(
        _onToggleAllRequested); // Đánh dấu tất cả/bỏ đánh dấu
    on<TodosOverviewClearCompletedRequested>(
        _onClearCompletedRequested); // Xóa các todo đã hoàn thành
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodosOverviewStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TodosOverviewStatus.failure,
      ),
    );
  }

  /// Xử lý sự kiện khi người dùng đánh dấu/bỏ đánh dấu một todo
  /// Tạo bản sao của todo với trạng thái mới và lưu vào repository
  Future<void> _onTodoCompletionToggled(
    TodosOverviewTodoCompletionToggled event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  /// Xử lý sự kiện xóa todo
  /// Lưu todo bị xóa vào state để có thể hoàn tác và xóa khỏi repository
  Future<void> _onTodoDeleted(
    TodosOverviewTodoDeleted event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onUndoDeletionRequested(
    TodosOverviewUndoDeletionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todosRepository.saveTodo(todo);
  }

  void _onFilterChanged(
    TodosOverviewFilterChanged event,
    Emitter<TodosOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    TodosOverviewToggleAllRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
    TodosOverviewClearCompletedRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    await _todosRepository.clearCompleted();
  }
}

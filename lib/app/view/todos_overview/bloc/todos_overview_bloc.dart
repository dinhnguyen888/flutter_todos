import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todos/app/models/models.dart';
import 'package:todos_repository/todos_repository.dart';

part 'todos_overview_event.dart';
part 'todos_overview_state.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(
          const TodosOverviewState(),
        ) {
    on<TodosOverviewSubscriptionRequested>(
      _onTodosOverviewSubscriptionRequested,
    );
    on<TodosOverviewTodoDeleted>(_onTodosOverviewTodoDeleted);
    on<TodosOverviewTodoCompletionToggled>(
        _onTodosOverviewTodoCompletionToggled);
    on<TodosOverviewToggleAllRequested>(_onTodosOverviewToggleAllRequested);
    on<TodosOverviewClearCompleteRequested>(
        _onTodosOverviewClearCompleteRequested);
    on<TodosOverviewUndoDeletionRequest>(_onTodosOverviewUndoDeletionRequest);
    on<TodosOverviewFilterChanged>(_onTodosOverviewFilterChanged);
  }

  final TodosRepository _todosRepository;

  Future<void> _onTodosOverviewSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        status: () => TodosOverviewStatus.loading,
      ),
    );

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

  Future<void> _onTodosOverviewTodoDeleted(
    TodosOverviewTodoDeleted event,
    Emitter<TodosOverviewState> emitter,
  ) async {
    emitter(
      state.copyWith(lastDeletedTodo: () => event.todo),
    );
    await _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onTodosOverviewTodoCompletionToggled(
    TodosOverviewTodoCompletionToggled event,
    Emitter<TodosOverviewState> emitter,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: !event.todo.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<int> _onTodosOverviewToggleAllRequested(
    TodosOverviewToggleAllRequested event,
    Emitter<TodosOverviewState> emitter,
  ) async {
    return _todosRepository.completeAll();
  }

  Future<int> _onTodosOverviewClearCompleteRequested(
    TodosOverviewClearCompleteRequested event,
    Emitter<TodosOverviewState> emitter,
  ) async {
    return _todosRepository.clearCompleted();
  }

  Future<void> _onTodosOverviewUndoDeletionRequest(
    TodosOverviewUndoDeletionRequest event,
    Emitter<TodosOverviewState> emitter,
  ) async {
    assert(state.lastDeletedTodo != null, 'Last deleted todo can not be null.');
    final todo = state.lastDeletedTodo!;
    emitter(
      state.copyWith(
        lastDeletedTodo: () => null,
      ),
    );
    await _todosRepository.saveTodo(todo);
  }

  void _onTodosOverviewFilterChanged(
    TodosOverviewFilterChanged event,
    Emitter<TodosOverviewState> emitter,
  ) {
    emitter(state.copyWith(filter: () => event.viewFilter));
  }
}

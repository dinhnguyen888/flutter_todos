part of 'todos_overview_bloc.dart';

abstract class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  const TodosOverviewTodoDeleted({required this.todo});

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class TodosOverviewTodoCompletionToggled extends TodosOverviewEvent {
  const TodosOverviewTodoCompletionToggled({
    required this.todo,
  });

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequested();
}

class TodosOverviewClearCompleteRequested extends TodosOverviewEvent {
  const TodosOverviewClearCompleteRequested();
}

class TodosOverviewUndoDeletionRequest extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequest();
}

class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.viewFilter);
  final TodosViewFilter viewFilter;

  @override
  List<Object> get props => [viewFilter];
}

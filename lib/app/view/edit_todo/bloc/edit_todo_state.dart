part of 'edit_todo_bloc.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

class EditTodoState extends Equatable {
  const EditTodoState({
    this.description = '',
    this.editTodoStatus = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
  });

  final String description;
  final EditTodoStatus editTodoStatus;
  final Todo? initialTodo;
  final String title;

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    String? description,
    EditTodoStatus? editTodoStatus,
    Todo? initialTodo,
    String? title,
  }) {
    return EditTodoState(
      description: description ?? this.description,
      editTodoStatus: editTodoStatus ?? this.editTodoStatus,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [description, editTodoStatus, initialTodo, title];
}

part of 'stats_bloc.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  const StatsState({
    this.status = StatsStatus.initial,
    this.activeTodos = 0,
    this.completedTodos = 0,
  });

  final StatsStatus status;
  final int completedTodos;
  final int activeTodos;

  @override
  List<Object> get props => [
        status,
        completedTodos,
        activeTodos,
      ];

  StatsState copyWith({
    StatsStatus? status,
    int? activeTodos,
    int? completedTodos,
  }) {
    return StatsState(
      status: status ?? this.status,
      activeTodos: activeTodos ?? this.activeTodos,
      completedTodos: completedTodos ?? this.completedTodos,
    );
  }
}

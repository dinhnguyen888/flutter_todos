import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onStatsSubscriptionRequested);
  }

  final TodosRepository _todosRepository;

  Future<void> _onStatsSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emitter,
  ) async {
    emitter(state.copyWith(status: StatsStatus.loading));
    await emitter.forEach(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: StatsStatus.success,
        activeTodos: todos.where((t) => !t.isCompleted).length,
        completedTodos: todos.where((t) => t.isCompleted).length,
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}

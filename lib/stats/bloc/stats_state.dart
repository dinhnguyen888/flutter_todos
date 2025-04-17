// Kết nối file này với 'stats_bloc.dart' theo cơ chế part-file trong Dart.
// Điều này giúp gom tất cả các phần liên quan đến StatsBloc vào 1 khối logic.
part of 'stats_bloc.dart';

/// Enum biểu diễn trạng thái hiện tại của StatsBloc
/// - `initial`: trạng thái ban đầu khi chưa load gì.
/// - `loading`: đang xử lý dữ liệu.
/// - `success`: dữ liệu đã load thành công.
/// - `failure`: xảy ra lỗi trong quá trình xử lý.
enum StatsStatus { initial, loading, success, failure }

/// `StatsState` đại diện cho trạng thái của khối StatsBloc.
/// Dữ liệu này được theo dõi và cập nhật khi có sự kiện xảy ra.
final class StatsState extends Equatable {
  // Constructor với các giá trị mặc định
  const StatsState({
    this.status = StatsStatus.initial,
    this.completedTodos = 0,
    this.activeTodos = 0,
  });

  /// Trạng thái hiện tại (loading, success, failure,...)
  final StatsStatus status;

  /// Số lượng công việc đã hoàn thành
  final int completedTodos;

  /// Số lượng công việc đang hoạt động (chưa hoàn thành)
  final int activeTodos;

  /// Hàm giúp `Equatable` biết được khi nào 2 instance của StatsState giống nhau,
  /// dùng để tối ưu rebuild giao diện trong Flutter
  @override
  List<Object> get props => [status, completedTodos, activeTodos];

  /// Tạo bản sao mới của `StatsState` với giá trị được cập nhật,
  /// dùng trong Bloc khi muốn emit (phát) state mới.
  StatsState copyWith({
    StatsStatus? status,
    int? completedTodos,
    int? activeTodos,
  }) {
    return StatsState(
      status: status ?? this.status,
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}

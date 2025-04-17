// Import các thư viện cần thiết
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_main/l10n/l10n.dart'; // Localization (đa ngôn ngữ)
import 'package:flutter_todos_main/stats/bloc/stats_bloc.dart'; // BLoC xử lý logic cho Stats
import 'package:todos_repository/todos_repository.dart'; // Nguồn dữ liệu Todos

/// Trang thống kê - hiển thị số lượng công việc đã hoàn thành và đang hoạt động.
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Khởi tạo StatsBloc và lắng nghe sự kiện subscription ngay khi tạo
      create: (context) => StatsBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const StatsSubscriptionRequested()),
      child: const StatsView(), // Giao diện chính được render tại đây
    );
  }
}

/// Widget giao diện hiển thị thông tin thống kê công việc
class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy localization để hỗ trợ đa ngôn ngữ
    final l10n = context.l10n;

    // Lấy state hiện tại từ StatsBloc
    final state = context.watch<StatsBloc>().state;

    // Lấy theme text để style chữ
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsAppBarTitle), // Tiêu đề thanh điều hướng
      ),
      body: Column(
        children: [
          // Dòng hiển thị số lượng công việc đã hoàn thành
          ListTile(
            key: const Key('statsView_completedTodos_listTile'),
            leading: const Icon(Icons.check_rounded),
            title: Text(l10n.statsCompletedTodoCountLabel),
            trailing: Text(
              '${state.completedTodos}', // Gán số công việc đã hoàn thành
              style: textTheme.headlineSmall,
            ),
          ),
          // Dòng hiển thị số lượng công việc đang hoạt động
          ListTile(
            key: const Key('statsView_activeTodos_listTile'),
            leading: const Icon(Icons.radio_button_unchecked_rounded),
            title: Text(l10n.statsActiveTodoCountLabel),
            trailing: Text(
              '${state.activeTodos}', // Gán số công việc đang hoạt động
              style: textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}

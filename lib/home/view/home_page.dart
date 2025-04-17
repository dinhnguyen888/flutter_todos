// Các thư viện Flutter và BLoC
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import các trang cần điều hướng
import 'package:flutter_todos_main/edit_todo/view/edit_todo_page.dart';
import 'package:flutter_todos_main/home/cubit/home_cubit.dart';
import 'package:flutter_todos_main/stats/view/stats_page.dart';
import 'package:flutter_todos_main/todos_overview/view/todos_overview_page.dart';

// ===============================
// Trang chính: HomePage
// ===============================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(), // Tạo và cung cấp HomeCubit
      child: const HomeView(), // Widget chính được bọc bởi Cubit
    );
  }
}

// ===============================
// Giao diện chính của Home
// ===============================
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy tab hiện tại từ Cubit
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      // Giữ nguyên trạng thái widget của mỗi tab
      body: IndexedStack(
        index: selectedTab.index, // Hiển thị tab hiện tại
        children: const [
          TodosOverviewPage(), // Trang danh sách todos
          StatsPage(), // Trang thống kê
        ],
      ),

      // FloatingActionButton nằm giữa
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
        // Khi nhấn nút, mở EditTodoPage để tạo mới todo
        child: const Icon(Icons.add),
      ),

      // Thanh chuyển tab ở dưới
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // Hình để chừa chỗ cho FAB
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.todos, // Tab danh sách
              icon: const Icon(Icons.list_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.stats, // Tab thống kê
              icon: const Icon(Icons.show_chart_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================
// Widget cho nút chọn tab
// ===============================
class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue, // Tab hiện tại
    required this.value, // Tab tương ứng với nút
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      // Khi nhấn, gọi Cubit để chuyển tab
      iconSize: 32,
      color: groupValue != value
          ? null // Nếu không phải tab hiện tại -> icon bình thường
          : Theme.of(context).colorScheme.secondary, // Tab hiện tại -> tô màu
      icon: icon,
    );
  }
}

// Import các thư viện Flutter và các package cần thiết.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import các phần liên quan của app.
import 'package:flutter_todos_main/edit_todo/view/edit_todo_page.dart'; // Màn hình chỉnh sửa todo.
import 'package:flutter_todos_main/l10n/l10n.dart'; // Hệ thống đa ngôn ngữ (localization).
import 'package:flutter_todos_main/todos_overview/bloc/todos_overview_bloc.dart'; // Bloc quản lý state của danh sách todo.
import 'package:flutter_todos_main/todos_overview/widgets/todo_list_tile.dart'; // Widget hiển thị 1 todo.
import 'package:flutter_todos_main/todos_overview/widgets/todos_overview_filter_button.dart'; // Nút lọc.
import 'package:flutter_todos_main/todos_overview/widgets/todos_overview_options_button.dart'; // Nút tuỳ chọn.
import 'package:todos_repository/todos_repository.dart'; // Nơi lấy dữ liệu todo.

/// Widget đại diện cho trang tổng quan todo.
/// Khởi tạo `TodosOverviewBloc` khi widget được tạo.
class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Cung cấp Bloc cho toàn bộ cây widget phía dưới.
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(), // Inject repository.
      )..add(
          const TodosOverviewSubscriptionRequested()), // Gửi event để bắt đầu lắng nghe todos.
      child: const TodosOverviewView(), // Giao diện chính.
    );
  }
}

/// Giao diện chính của trang TodosOverview.
class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; // Lấy localization (đa ngôn ngữ).

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todosOverviewAppBarTitle), // Tiêu đề AppBar.
        actions: const [
          TodosOverviewFilterButton(), // Nút lọc.
          TodosOverviewOptionsButton(), // Nút tùy chọn (Clear All, Toggle All).
        ],
      ),

      /// Sử dụng MultiBlocListener để lắng nghe nhiều thay đổi từ Bloc.
      body: MultiBlocListener(
        listeners: [
          // Lắng nghe trạng thái thất bại để hiện snackbar lỗi.
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.todosOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),

          // Lắng nghe khi có todo bị xóa để hiển thị Snackbar cho undo.
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);

              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.todosOverviewTodoDeletedSnackbarText(
                        deletedTodo.title,
                      ),
                    ),
                    action: SnackBarAction(
                      label: l10n.todosOverviewUndoDeletionButtonText,
                      onPressed: () {
                        // Gửi event khôi phục todo bị xóa.
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],

        /// BlocBuilder để render UI dựa trên state hiện tại.
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            // Nếu danh sách todo trống
            if (state.todos.isEmpty) {
              // Nếu đang tải thì hiển thị loading.
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              }
              // Nếu không phải trạng thái success, hiển thị widget rỗng.
              else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              }
              // Nếu tải xong nhưng không có todo, hiển thị thông báo rỗng.
              else {
                return Center(
                  child: Text(
                    l10n.todosOverviewEmptyText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            // Nếu có todo thì hiển thị danh sách có thể scroll.
            return CupertinoScrollbar(
              child: ListView.builder(
                itemCount: state.filteredTodos.length, // Số item đã lọc.
                itemBuilder: (_, index) {
                  final todo = state.filteredTodos.elementAt(index);

                  return TodoListTile(
                    todo: todo,
                    // Toggle trạng thái hoàn thành.
                    onToggleCompleted: (isCompleted) {
                      context.read<TodosOverviewBloc>().add(
                            TodosOverviewTodoCompletionToggled(
                              todo: todo,
                              isCompleted: isCompleted,
                            ),
                          );
                    },
                    // Xoá todo bằng swipe.
                    onDismissed: (_) {
                      context
                          .read<TodosOverviewBloc>()
                          .add(TodosOverviewTodoDeleted(todo));
                    },
                    // Tap để chỉnh sửa todo.
                    onTap: () {
                      Navigator.of(context).push(
                        EditTodoPage.route(initialTodo: todo),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

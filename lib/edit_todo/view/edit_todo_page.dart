// Các thư viện Flutter cơ bản và cần thiết
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Thư viện Bloc để dùng kiến trúc BLoC
import 'package:flutter_bloc/flutter_bloc.dart';

// Import file BLoC đã tạo để xử lý logic cho EditTodo
import 'package:flutter_todos_main/edit_todo/bloc/edit_todo_bloc.dart';

// Đa ngôn ngữ (L10n = Localization)
import 'package:flutter_todos_main/l10n/l10n.dart';

// Repository dùng để lưu/truy xuất dữ liệu Todo
import 'package:todos_repository/todos_repository.dart';

// =======================
// Widget chính: EditTodoPage
// =======================
class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  // Tạo route để điều hướng tới trang này (có thể truyền todo cũ vào để chỉnh sửa)
  static Route<void> route({Todo? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        // Cung cấp EditTodoBloc cho toàn bộ cây widget bên dưới
        create: (context) => EditTodoBloc(
          todosRepository: context.read<TodosRepository>(), // lấy từ context
          initialTodo: initialTodo,
        ),
        child: const EditTodoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      // Chỉ lắng nghe khi status thay đổi và khi thành công
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTodoStatus.success,

      // Khi thành công -> tự động pop về màn hình trước
      listener: (context, state) => Navigator.of(context).pop(),

      // UI chính
      child: const EditTodoView(),
    );
  }
}

// =======================
// UI chi tiết của Edit Todo
// =======================
class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n; // Đa ngôn ngữ

    // Lấy status hiện tại của BLoC
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);

    // Kiểm tra có phải đang tạo todo mới hay không
    final isNewTodo = context.select(
      (EditTodoBloc bloc) => bloc.state.isNewTodo,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo
              ? l10n.editTodoAddAppBarTitle // Nếu là mới -> tiêu đề tương ứng
              : l10n.editTodoEditAppBarTitle,
        ),
      ),

      // Nút lưu ở góc dưới
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editTodoSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        // Nếu đang loading -> disable
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
        // Icon loading hoặc icon check
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),

      // Nội dung form
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _TitleField(), // Field tiêu đề
                _DescriptionField(), // Field mô tả
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =======================
// Trường nhập tiêu đề
// =======================
class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess, // Disable nếu đang loading
        labelText: l10n.editTodoTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9\s]')), // Chỉ cho nhập chữ và số
      ],
      onChanged: (value) {
        // Gửi event thay đổi tiêu đề tới BLoC
        context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
      },
    );
  }
}

// =======================
// Trường nhập mô tả
// =======================
class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editTodoDescriptionLabel,
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        // Gửi event thay đổi mô tả tới BLoC
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}

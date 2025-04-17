import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_main/home/view/home_page.dart';
import 'package:flutter_todos_main/l10n/l10n.dart';
import 'package:flutter_todos_main/theme/theme.dart';
import 'package:todos_repository/todos_repository.dart';

/// Widget gốc của ứng dụng, khởi tạo repository và các dependencies
class App extends StatelessWidget {
  const App({required this.createTodosRepository, super.key});

  /// Function factory để tạo TodosRepository
  final TodosRepository Function() createTodosRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<TodosRepository>(
      create: (_) => createTodosRepository(),
      dispose: (repository) => repository.dispose(),
      child: const AppView(),
    );
  }
}

/// Widget chính để cấu hình MaterialApp với theme và localization
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTodosTheme.light,
      darkTheme: FlutterTodosTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}

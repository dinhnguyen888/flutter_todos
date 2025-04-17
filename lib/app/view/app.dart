import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/app/theme/flutter_todos_theme.dart';
import 'package:flutter_todos/app/view/home_page/home_page.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:todos_repository/todos_repository.dart';

class App extends StatelessWidget {
  const App({super.key, required TodosRepository todosRepository})
      : _todosRepository = todosRepository;

  final TodosRepository _todosRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _todosRepository,
      child: const AppView(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     theme: ThemeData(
  //       appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
  //       colorScheme: ColorScheme.fromSwatch(
  //         accentColor: const Color(0xFF13B9FF),
  //       ),
  //     ),
  //     localizationsDelegates: AppLocalizations.localizationsDelegates,
  //     supportedLocales: AppLocalizations.supportedLocales,
  //     home: const CounterPage(),
  //   );
  // }
}

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

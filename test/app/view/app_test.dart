import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos/app/app.dart';
import 'package:flutter_todos/counter/counter.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository/todos_repository.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        App(
          todosRepository: TodosRepository(
            todosApi: LocalStorageTodosApi(
              plugin: await SharedPreferences.getInstance(),
            ),
          ),
        ),
      );
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}

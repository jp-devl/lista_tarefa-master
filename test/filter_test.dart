import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tarefa/main.dart';

void main() {
  testWidgets('deve filtrar tarefas por status', (tester) async {
    await tester.pumpWidget(const MainApp());

    await tester.enterText(find.byType(TextField), 'Comprar leite');
    await tester.tap(find.text('Adicionar'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Estudar Flutter');
    await tester.tap(find.text('Adicionar'));
    await tester.pump();

    final taskIndexes = tester.widgetList(find.byType(ListTile));
    expect(taskIndexes.length, 2);

    final firstTask = find.text('Comprar leite');
    expect(firstTask, findsOneWidget);

    await tester.tap(find.text('Concluídas'));
    await tester.pumpAndSettle();
    expect(find.text('Comprar leite'), findsNothing);
    expect(find.text('Estudar Flutter'), findsNothing);

    await tester.tap(find.text('Ativas'));
    await tester.pumpAndSettle();
    expect(find.text('Comprar leite'), findsOneWidget);
    expect(find.text('Estudar Flutter'), findsOneWidget);

    await tester.tap(find.text('Todas'));
    await tester.pumpAndSettle();
    expect(find.text('Comprar leite'), findsOneWidget);
    expect(find.text('Estudar Flutter'), findsOneWidget);
  });
}

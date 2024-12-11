import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser/main.dart';

void main() {
  testWidgets('Movie List Screen displays search field', (WidgetTester tester) async {
    // Запустите приложение
    await tester.pumpWidget(const MyApp());

    // Убедитесь, что на экране есть поле ввода для поиска
    expect(find.byType(TextField), findsOneWidget);

    // Убедитесь, что есть AppBar с названием приложения
    expect(find.text('Movie Browser'), findsOneWidget);
  });
}

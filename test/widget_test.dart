// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:hello_flutter/main.dart';

void main() {
  testWidgets('Profile screen menampilkan nama mahasiswa', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PoliwangiProfileApp());

    expect(find.text('Kinanti Wilujeng Rizky'), findsOneWidget);
    expect(find.text('Profil Mahasiswa'), findsOneWidget);
    expect(find.text('Sarjana Terapan Teknologi Rekayasa Perangkat Lunak'), findsOneWidget);
  });
}

import 'package:agrix/features/business/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BusinessSignupScreen shows all form fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: BusinessSignupScreen())),
    );

    expect(find.text('Register Your Business'), findsOneWidget);
    expect(find.text('Business Name'), findsOneWidget);
    expect(find.text('Business Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Business Phone Number'), findsOneWidget);
    expect(find.text('Business Address'), findsOneWidget);
    expect(find.text('Register Business'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
  });

  testWidgets(
    'BusinessSignupScreen shows validation errors for empty required fields',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: BusinessSignupScreen())),
      );

      final registerButton = find.text('Register Business');

      await tester.ensureVisible(registerButton);
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Enter your business name'), findsOneWidget);
      expect(find.text('Enter your business email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text('Enter your business phone number'), findsOneWidget);
    },
  );

  testWidgets('BusinessSignupScreen validates password length', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: BusinessSignupScreen())),
    );

    final passwordField = find.widgetWithText(TextFormField, 'Password');

    await tester.ensureVisible(passwordField);
    await tester.enterText(passwordField, '123');

    final registerButton = find.text('Register Business');

    await tester.ensureVisible(registerButton);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
}

import 'package:agrix/features/business/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'BusinessLoginScreen shows all form fields and validates empty input',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: BusinessLoginScreen())),
      );

      expect(find.text('Welcome Back Business'), findsOneWidget);
      expect(find.text('Business Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      final loginButton = find.text('Business Login');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your business email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    },
  );

  testWidgets(
    'BusinessLoginScreen toggle password visibility and accepts input',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: BusinessLoginScreen())),
      );

      final emailField = find.widgetWithText(TextFormField, 'Business Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');

      await tester.ensureVisible(emailField);
      await tester.enterText(emailField, 'business@agrix.com');

      await tester.ensureVisible(passwordField);
      await tester.enterText(passwordField, 'password123');

      final visibilityIcon = find.byIcon(Icons.visibility_off);
      await tester.ensureVisible(visibilityIcon);
      await tester.tap(visibilityIcon);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    },
  );
}

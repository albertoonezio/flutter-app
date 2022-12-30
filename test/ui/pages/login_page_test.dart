import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_loja/ui/pages/pages.dart';
import '../mocks/mocks.dart';

void main() {
  late LoginPresenterSpy presenterSpy;

  Future<void> loadPage(WidgetTester tester) async {
    presenterSpy = LoginPresenterSpy();

    final loginPage = MaterialApp(
      home: LoginPage(
        presenter: presenterSpy,
      ),
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    presenterSpy.dispose();
  });

  testWidgets('Should load input email with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should load input password with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should load button with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);

    verify(() => presenterSpy.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);

    verify(() => presenterSpy.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitEmailError('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitEmailError('');
    await tester.pump();

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget);
  });

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitPasswordError('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitPasswordError('');
    await tester.pump();

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(passwordTextChildren, findsOneWidget);
  });

  testWidgets('Should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitFormValid();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should enable button if form is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitFormError();
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitFormValid();
    await tester.pump();
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(() => presenterSpy.auth()).called(1);
  });

  testWidgets('Should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitLoading();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitLoading();
    await tester.pump();
    presenterSpy.emitLoading(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error message if authentication fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenterSpy.emitMainError('mains error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Should close streams on dispose', (WidgetTester tester) async {
    await loadPage(tester);

    addTearDown(() {
      verify(() => presenterSpy.dispose()).called(1);
    });
  });
}

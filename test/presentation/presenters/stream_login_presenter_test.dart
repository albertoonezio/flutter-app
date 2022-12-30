import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_loja/domain/helpers/helpers.dart';
import 'package:app_loja/domain/usecases/usecases.dart';

import 'package:app_loja/presentation/presenters/presenters.dart';

import '../mocks/mocks.dart';

void main() {
  late StreamLoginPresenter sut;
  late AuthenticationSpy authentication;
  late ValidationSpy validation;
  late String email;
  late String password;

  // setUpAll(() {
  //   registerFallbackValue();
  // });

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(
      validation: validation,
      authentication: authentication,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    validation.mockValidation(field: '', value: '');
    authentication.mockAuthentication();
  });

  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    validation.mockValidation(field: '', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call validation with correct password', () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit password error if validation fails', () {
    validation.mockValidation(field: '', value: 'error');

    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit email error and password succeeds in validation', () {
    validation.mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream
        .listen(expectAsync1((error) => expect(error, 'error')));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream
        .listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds in all values', () async {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream
        .listen(expectAsync1((error) => expect(error, null)));
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authentication with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication.auth(
        AuthenticationParams(email: email, password: password))).called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test('Should emit correct events on InvalidCredentialsError', () async {
    authentication.mockAuthenticationError(DomainError.invalidCredentials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on UnexpectedError', () async {
    authentication.mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((error) =>
        expect(error, 'Algo errado aconteceu. Tente novamente em breve.')));

    await sut.auth();
  });

  test('Should not emit after dispose', () async {
    expectLater(sut.emailErrorStream, neverEmits(null));

    sut.dispose();

    sut.validateEmail(email);
  });
}

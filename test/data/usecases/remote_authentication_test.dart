import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_loja/domain/helpers/helpers.dart';
import 'package:app_loja/domain/usecases/usecases.dart';

import 'package:app_loja/data/http/http.dart';
import 'package:app_loja/data/usecases/usecases.dart';

import '../mocks/mocks.dart';

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
    httpClient.mockHttpData(httpClient.mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(() => httpClient.request(
          url: url,
          method: 'POST',
          body: {
            'email': params.email,
            'password': params.password,
          },
        ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    httpClient.mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    httpClient.mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    httpClient.mockHttpData({'invalid_key': 'invalid_key'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final validData = httpClient.mockValidData();

    httpClient.mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData['accessToken']);
  });
}

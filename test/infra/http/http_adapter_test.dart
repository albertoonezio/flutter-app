import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:app_loja/data/http/http.dart';

import 'package:app_loja/infra/http/http.dart';

import '../mocks/mocks.dart';

void main() {
  late ClientSpy client;
  late HttpAdapter sut;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
  });

  setUpAll(() {
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri.parse(url));
  });

  group('shared', () {
    test('Should throw ServerError if invalid method is provided', () async {
      final future = sut.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    test('Should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'POST',
        body: {'any_key': 'any_value'},
      );

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'accept': 'application/json',
            },
            body: '{"any_key":"any_value"}',
          ));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'POST');

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'POST');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return void if post returns 200 with no data', () async {
      client.mockPost(200, body: '');

      final response = await sut.request(url: url, method: 'POST');

      expect(response, {});
    });

    test('Should return void if post returns 204', () async {
      client.mockPost(204, body: '');

      final response = await sut.request(url: url, method: 'POST');

      expect(response, {});
    });

    test('Should return void if post returns 204 with data', () async {
      client.mockPost(204);

      final response = await sut.request(url: url, method: 'POST');

      expect(response, {});
    });

    test('Should return BadRequestError if post returns 400', () async {
      client.mockPost(400);

      final future = sut.request(url: url, method: 'POST');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      client.mockPost(401);

      final future = sut.request(url: url, method: 'POST');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if post returns 403', () async {
      client.mockPost(403);

      final future = sut.request(url: url, method: 'POST');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoungError if post returns 404', () async {
      client.mockPost(404);

      final future = sut.request(url: url, method: 'POST');

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      client.mockPost(500);

      final future = sut.request(url: url, method: 'POST');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      client.mockPostError();

      final future = sut.request(url: url, method: 'POST');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}

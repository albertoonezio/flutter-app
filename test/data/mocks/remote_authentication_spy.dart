import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_loja/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {
  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  When mockRequest() => when(() => request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }
}

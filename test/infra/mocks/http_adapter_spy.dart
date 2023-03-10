import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart';

class ClientSpy extends Mock implements Client {
  ClientSpy() {
    mockPost(200);
    // mockPut(200);
    // mockGet(200);
  }
  When mockPostCall() => when(() => this.post(
        any(),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ));

  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) {
    mockPostCall().thenAnswer((_) async => Response(body, statusCode));
  }

  void mockPostError() {
    mockPostCall().thenThrow(Exception());
  }
}

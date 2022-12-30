import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final response = await _handleMethod(url, method, body);

    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? {} : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return {};
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }

  Future<Response> _handleMethod(String url, String method, Map? body) async {
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;

    var response = Response('', 500);

    try {
      if (method == 'POST') {
        response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonBody,
        );
      }

      if (method == 'PUT') {
        response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonBody,
        );
      }

      if (method == 'GET') {
        response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: jsonBody,
        );
      }
    } catch (e) {
      throw HttpError.serverError;
    }

    return response;
  }
}

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../http/http.dart';
import '../models/models.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();

    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: 'POST',
        body: body,
      );

      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      error == HttpError.unauthorized
          ? throw DomainError.invalidCredentials
          : throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.password,
      );

  Map toJson() => {'email': email, 'password': password};
}

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_loja/domain/entities/entities.dart';
import 'package:app_loja/domain/helpers/helpers.dart';
import 'package:app_loja/domain/usecases/usecases.dart';

class AuthenticationSpy extends Mock implements Authentication {
  When mockAuthenticationCall() => when(() => auth(any()));

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }
}

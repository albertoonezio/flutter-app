import 'package:mocktail/mocktail.dart';

import 'package:app_loja/presentation/protocols/protocols.dart';

class ValidationSpy extends Mock implements Validation {
  When mockValidationCall(String field) => when(
        () => validate(
          field: field.isEmpty ? any(named: 'field') : field,
          value: any(named: 'value'),
        ),
      );

  void mockValidation({required String field, required String value}) {
    mockValidationCall(field).thenReturn(value);
  }
}

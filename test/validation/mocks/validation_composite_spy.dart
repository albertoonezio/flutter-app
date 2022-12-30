import 'package:mocktail/mocktail.dart';

import 'package:app_loja/validation/validators/validators.dart';

import 'mocks.dart';

class ValidationCompositeSpy extends Mock implements ValidationComposite {
  void mockValidationField({
    required FieldValidationSpy validation,
    String field = 'any_field',
  }) {
    when(() => validation.field).thenReturn(field);
  }

  void mockValidation({
    required FieldValidationSpy validation,
    required String error,
  }) {
    when(() => validation.validate(any())).thenReturn(error);
  }
}

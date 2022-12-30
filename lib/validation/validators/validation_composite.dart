import '../../presentation/protocols/protocols.dart';

import '../../validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({required String field, required String value}) {
    late String error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);

      if (error.isNotEmpty) {
        return error;
      }
    }

    return error;
  }
}

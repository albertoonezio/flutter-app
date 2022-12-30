import 'package:test/test.dart';

import 'package:app_loja/validation/validators/validators.dart';

import '../mocks/mocks.dart';

void main() {
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;
  late ValidationComposite validation;
  late ValidationCompositeSpy sut;

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    validation3 = FieldValidationSpy();

    sut = ValidationCompositeSpy();

    sut.mockValidationField(validation: validation1);
    sut.mockValidation(validation: validation1, error: '');

    sut.mockValidationField(validation: validation2);
    sut.mockValidation(validation: validation2, error: '');

    sut.mockValidationField(validation: validation3, field: 'other_field');
    sut.mockValidation(validation: validation3, error: '');

    validation = ValidationComposite([
      validation1,
      validation2,
      validation3,
    ]);
  });

  test('Should return empty if all validations returns empty', () {
    final error = validation.validate(
      field: 'any_field',
      value: 'any_value',
    );

    expect(error, '');
  });

  test('Should return the first error', () {
    sut.mockValidation(validation: validation1, error: 'error_1');
    sut.mockValidation(validation: validation2, error: 'error_2');
    sut.mockValidation(validation: validation3, error: 'error_3');

    final error = validation.validate(
      field: 'any_field',
      value: 'any_value',
    );

    expect(error, 'error_1');
  });

  test('Should return the first error of the field', () {
    sut.mockValidationField(validation: validation1, field: 'other_field');
    sut.mockValidation(validation: validation1, error: 'error_1');
    sut.mockValidation(validation: validation2, error: 'error_2');
    sut.mockValidation(validation: validation3, error: 'error_3');

    final error = validation.validate(
      field: 'any_field',
      value: 'any_value',
    );

    expect(error, 'error_2');
  });
}

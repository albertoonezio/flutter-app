import 'package:test/test.dart';

import 'package:app_loja/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('Should return empty if value is not empty', () {
    expect(sut.validate('any_value'), '');
  });

  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });
}

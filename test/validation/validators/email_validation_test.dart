import 'package:test/test.dart';

import 'package:app_loja/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('Should return empty if email is empty', () {
    expect(sut.validate(''), '');
  });

  test('Should return empty if email is valid', () {
    expect(sut.validate('albertoonezio@gmail.com'), '');
  });

  test('Should return error if email is invalid', () {
    expect(sut.validate('alberto.onezio'), 'Campo inválido');
  });
}

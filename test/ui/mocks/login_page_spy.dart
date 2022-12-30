import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:app_loja/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final StreamController<String> emailErrorController =
      StreamController<String>();
  final StreamController<String> passwordErrorController =
      StreamController<String>();
  final StreamController<String> mainErrorController =
      StreamController<String>();
  // final StreamController<String> navigateToController =
  //     StreamController<String>();
  final StreamController<bool> isFormValidController = StreamController<bool>();
  final StreamController<bool> isLoadingController = StreamController<bool>();

  LoginPresenterSpy() {
    when(() => auth()).thenAnswer((_) async => _);
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => mainErrorStream).thenAnswer((_) => mainErrorController.stream);
    // when(() => navigateToStream).thenAnswer((_) => navigateToController.stream);
    when(() => isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => isLoadingStream).thenAnswer((_) => isLoadingController.stream);
  }

  void emitEmailError(String error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add('');
  void emitPasswordError(String error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add('');
  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitMainError(String error) => mainErrorController.add(error);
  // void emitNavigateTo(String route) => navigateToController.add(route);

  @override
  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    // navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }
}

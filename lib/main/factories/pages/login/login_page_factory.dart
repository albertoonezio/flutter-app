import 'package:flutter/material.dart';

import '../../../../ui/pages/pages.dart';

import 'login.dart';

Widget makeLoginPage() {
  return LoginPage(presenter: makeLoginPresenter());
}

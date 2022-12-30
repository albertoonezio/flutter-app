import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';

import 'components/components.dart';

import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.presenter});

  final LoginPresenter? presenter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'.toUpperCase()),
        actions: [
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Criar Conta',
            child: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        widget.presenter?.isLoadingStream.listen((isLoasding) {
          if (isLoasding) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        widget.presenter?.mainErrorStream.listen((error) {
          if (error.isNotEmpty) {
            showErrorMessage(context, error);
          }
        });
        return SingleChildScrollView(
          child: Column(
            children: [
              const LoginHeader(),
              const Headline1(text: 'Login'),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                      child: Column(
                    children: const [
                      EmailInput(),
                      PasswordInput(),
                      LoginButton(),
                    ],
                  )),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

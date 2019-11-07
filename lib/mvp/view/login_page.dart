 import 'package:flutter/material.dart';
import 'package:flutter_quick_mvp/mvp/contract/login_contract.dart';
import 'package:flutter_quick_mvp/mvp/presenter/login_presenter_impl.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginView {

  LoginPresenterImpl mPresenter;

  @override
  void initState() {
    super.initState();
    mPresenter = LoginPresenterImpl(this);
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

  @override
  void dismissLoading() {}

  @override
  void showLoading() {}

  @override
  void showMessage(String msg) {}
}
import 'package:flutter_quick_mvp/mvp/base/base.dart';
  
abstract class LoginPresenter implements IPresenter {
  void login(String phone, String password, String code);
}
  
abstract class LoginView implements IView<LoginPresenter> {}
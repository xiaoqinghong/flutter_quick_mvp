import 'package:flutter_quick_mvp/mvp//model/login_model.dart';
import 'package:flutter_quick_mvp/mvp/base/base.dart';
import 'package:flutter_quick_mvp/mvp/contract/login_contract.dart';

class LoginPresenterImpl extends SimplePresenter<LoginView>
    implements LoginPresenter {
  LoginPresenterImpl(LoginView view) : super(view);

  LoginModel _mModel = LoginModel();

  @override
  void login(String phone, String password, String code) {
    mView.showLoading();
    _mModel.userLogin(phone, password, code, (Map<String, dynamic> response) {
      mView.dismissLoading();
      // do something with response
    }, (String errMsg) {
      // do something with errMsg
      mView.dismissLoading();
      mView.showMessage(errMsg);
    });
  }
}

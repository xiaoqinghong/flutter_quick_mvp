import 'package:flutter_quick_mvp/http/api_service.dart';
import 'package:flutter_quick_mvp/mvp//model/login_model.dart';
import 'package:flutter_quick_mvp/mvp/base/base.dart';
import 'package:flutter_quick_mvp/mvp/contract/login_contract.dart';

class LoginPresenterImpl extends SimplePresenter<LoginView>
    implements LoginPresenter {
  LoginPresenterImpl(LoginView view) : super(view);

  LoginModel _mModel = LoginModel();

  @override
  void login(String phone, String password, String code) {
    _mModel.userLogin(
        {"phone": phone, "password": password, "code": code},
        new ApiStateHook()
            .onStart(() => mView.showLoading())
            .onError((String msg) => mView.showMessage(msg))
            .onFinally(() => mView.dismissLoading())
            .onSuccess((Map<String, dynamic> resp) {})
    );
  }
}

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
    mView.showLoading();
    _mModel.userLogin(phone, password, code, new ApiStateHook(
            () => mView.showLoading(),
            (Map<String, dynamic> data) {},
            (String msg) => mView.showMessage(msg),
            () => mView.dismissLoading()),
    );
  }
}

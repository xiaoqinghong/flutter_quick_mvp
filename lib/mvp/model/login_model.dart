import 'package:flutter_quick_mvp/http/api.dart';
import 'package:flutter_quick_mvp/http/api_helper.dart';
import 'package:flutter_quick_mvp/http/api_service.dart';

class LoginModel {
  void userLogin(String phone, String password, String code,
      ApiStateHook hook) {
    ApiHelper.instance.post(
        Api.USER_LOGIN,
        {"phone": phone, "password": password, "code": code},
        hook);
  }
}

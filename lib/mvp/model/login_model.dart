import 'package:flutter_quick_mvp/http/api.dart';
import 'package:flutter_quick_mvp/http/api_helper.dart';
import 'package:flutter_quick_mvp/http/api_service.dart';

class LoginModel extends ApiService {
  void userLogin(String phone, String password, String code,
      ServiceSuccessCallBack callBack,
      [ServiceErrorCallBack errorCallBack]) {
    ApiHelper.instance.post(
        Api.USER_LOGIN,
        {"phone": phone, "password": password, "code": code},
        (response) => proxySuccessCallBack(response, callBack),
        (exception) => proxyErrorCallBack(exception, errorCallBack));
  }
}

import 'package:flutter_quick_mvp/http/api.dart';
import 'package:flutter_quick_mvp/http/api_helper.dart';
import 'package:flutter_quick_mvp/http/api_service.dart';

class LoginModel {
  void userLogin(Map<String, dynamic> params, ApiStateHook hook) {
    ApiHelper.instance.post(Api.USER_LOGIN, params, hook);
  }
}

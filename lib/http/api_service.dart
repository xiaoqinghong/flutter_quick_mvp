import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

typedef ServiceSuccessCallBack = void Function(Map<String, dynamic> data);
typedef ServiceErrorCallBack = void Function(String msg);

class ApiStateHook {
  Function() onStart;

  Function(Map<String, dynamic> data) onSuccess;

  Function(String msg) onError;

  Function() onFinally;

  ApiStateHook(this.onStart, this.onSuccess, this.onError, this.onFinally);
}


class ApiService {
  void proxySuccessCallBack(Response response,
      ApiStateHook hook) {
    if (hook != null) {
      try {
        hook.onSuccess(json.decode(response.toString()));
      } catch (e) {
        hook.onError("数据解析错误");
        print("callBackErr: $e");
      }
    }
    if (hook != null) hook.onFinally();
  }

  void proxyErrorCallBack(Exception e, ApiStateHook hook) {
    if (hook != null) {
      hook.onError(_parserException(e));
      hook.onFinally();
    }
  }

  String _parserException(Exception e) {
    String msg = "nuknow error";
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          msg = "连接超时";
          break;
        case DioErrorType.SEND_TIMEOUT:
          msg = "请求超时";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          msg = "接收超时";
          break;
        case DioErrorType.RESPONSE:
          msg = "连接超时";
          break;
        case DioErrorType.CANCEL:
          msg = "请求取消";
          break;
        case DioErrorType.DEFAULT:
          var defaultException = e.error;
          if (defaultException is SocketException) {
            msg = "网络异常";
          } else {
            msg = e.message;
          }
          break;
        default:
          msg = e.message;
          break;
      }
    }
    return msg;
  }
}

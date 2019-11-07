import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

typedef ServiceSuccessCallBack = void Function(Map<String, dynamic> data);
typedef ServiceErrorCallBack = void Function(String msg);

abstract class ApiService {
  void proxySuccessCallBack(Response response,
      ServiceSuccessCallBack callBack) {
    if (callBack != null) {
      try {
        callBack(json.decode(response.toString()));
      } catch (e) {
        print("callBackErr: $e");
      }
    }
  }

  void proxyErrorCallBack(Exception e, ServiceErrorCallBack callBack) {
    if (callBack != null) {
      callBack(_parserException(e));
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

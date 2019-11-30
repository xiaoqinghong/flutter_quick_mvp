import 'dart:io';
import 'package:dio/dio.dart';

/// 监听一个api请求的各个阶段
/// 一个api请求对应一个ApiStateHook实例
class ApiStateHook {
  Function() _onStart;

  Function(Map<String, dynamic> data) _onSuccess;

  Function(String msg) _onError;

  Function() _onFinally;

  ApiStateHook();

  /// 设置api调用开始的回调
  ApiStateHook onStart(void onStart()) {
    if (this._onStart == null) this._onStart = onStart;
    return this;
  }

  /// 设置api调用成功的回调
  ApiStateHook onSuccess(void onSuccess(Map<String, dynamic> resp)) {
    if (this._onSuccess == null) this._onSuccess = onSuccess;
    return this;
  }

  /// 设置错误结果回调
  ApiStateHook onError(void onError(String msg)) {
    if (this._onError == null) this._onError = onError;
    return this;
  }

  /// 设置无论成功与否，都会执行
  ApiStateHook onFinally(void onFinally()) {
    if (this._onFinally == null) this._onFinally = onFinally;
    return this;
  }

  /// 执行_onStart
  void execStart() {
    if (_onStart != null) this._onStart();
  }

  /// 执行_onSuccess
  void execSuccess(Map<String, dynamic> resp) {
    if (_onSuccess != null) this._onSuccess(resp);
  }

  /// 执行_onError
  void execError(String msg) {
    if (_onError != null) this._onError(msg);
  }

  /// 执行_onFinally
  void execFinally() {
    if (_onFinally != null) this._onFinally();
  }
}

class ApiService {
  /// 代理成功处理
  void proxySuccessCallBack(Response response, ApiStateHook hook) {
    if (hook != null) {
      try {
        hook.execSuccess(response.data);
      } catch (e) {
        hook.execError("数据解析错误");
        print("callBackErr: $e");
      }
    }
    if (hook != null) hook.execFinally();
  }

  /// 代理异常处理
  void proxyErrorCallBack(Exception e, ApiStateHook hook) {
    if (hook != null) {
      hook.execError(_parserException(e));
      hook.execFinally();
    }
  }

  /// 异常解析
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
      }
    }
    return msg;
  }
}

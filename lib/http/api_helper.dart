import 'dart:convert';

import 'package:dio/dio.dart';

import 'api_service.dart';

class ApiHelper {
  static ApiHelper _instance;
  Dio _dio = new Dio();

  static ApiHelper get instance {
    if (_instance == null) {
      _instance = ApiHelper._();
    }
    return _instance;
  }

  ApiHelper._() {
    _dio.options.baseUrl = "http://127.0.0.1/";
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    // 添加拦截器
    _dio.interceptors.add(LogInterceptor(requestBody: true));
  }

  /// 执行请求任务
  void _doRequest(String method, String url, Map<String, dynamic> params,
      [String contentType,
      void onResponse(Response resp),
        void onError(Exception e)]) async {
    contentType = contentType == null || contentType.isEmpty
        ? Headers.jsonContentType
        : contentType;
    try {
      Response response;
      switch (method) {
        case "GET":
          response = await _dio.get(url, queryParameters: params);
          break;
        case "POST":
          response = await _dio.post(url,
              data: (contentType == Headers.jsonContentType
                  ? json.encode(params)
                  : params),
              options: new Options(contentType: contentType));
          break;
      }
      if (response != null && onResponse != null) {
        onResponse(response);
      }
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
    }
  }

  void get(String url,
      Map<String, dynamic> params,
      ApiStateHook hook) {
    if (hook != null) hook.onStart();
    _doRequest(
        "GET", url, params, Headers.jsonContentType, (Response response) {
      if (hook != null) {
        new ApiService().proxySuccessCallBack(response, hook);
      }
    }, (Exception e) {
      if (hook != null) {
        new ApiService().proxyErrorCallBack(e, hook);
      }
    });
  }

  void post(String url,
      Map<String, dynamic> params,
      ApiStateHook hook) {
    if (hook != null) hook.onStart();
    _doRequest(
        "POST", url, params, Headers.jsonContentType, (Response response) {
      if (hook != null) {
        new ApiService().proxySuccessCallBack(response, hook);
      }
    }, (Exception e) {
      if (hook != null) new ApiService().proxyErrorCallBack(e, hook);
    });
  }
}

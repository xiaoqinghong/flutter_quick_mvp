import 'dart:io';

// 这里可以替换成自己的包名
const package = "flutter_quick_mvp";

void _createContract(String pageName, String lowerCasePageName) {
  String path = "lib/mvp/contract/";
  String fileName = "${lowerCasePageName}_contract.dart";
  String template = '''import 'package:$package/mvp/base/base.dart';
  
abstract class ${pageName}Presenter implements IPresenter {}
  
abstract class ${pageName}View implements IView<${pageName}Presenter> {}''';
  _doCreateFile(path, fileName, template);
}

void _createModel(String pageName, String lowerCasePageName) {
  String path = "lib/mvp/model/";
  String fileName = "${lowerCasePageName}_model.dart";
  String template = '''import 'package:$package/http/api.dart';
import 'package:$package/http/api_helper.dart';
import 'package:$package/http/api_service.dart';

class ${pageName}Model extends ApiService {}''';
  _doCreateFile(path, fileName, template);
}

void _createPresenterImpl(String pageName, String lowerCasePageName) {
  String path = "lib/mvp/presenter/";
  String fileName = "${lowerCasePageName}_presenter_impl.dart";
  String template =
  '''import 'package:$package/mvp//model/${lowerCasePageName}_model.dart';
import 'package:$package/mvp/base/base.dart';
import 'package:$package/mvp/contract/${lowerCasePageName}_contract.dart';

class ${pageName}PresenterImpl extends SimplePresenter<${pageName}View> implements ${pageName}Presenter {
  ${pageName}PresenterImpl(${pageName}View view) : super(view);

  ${pageName}Model _mModel = ${pageName}Model();
  
}''';
  _doCreateFile(path, fileName, template);
}

void _createView(String pageName, String lowerCasePageName) {
  String path = "lib/mvp/view/";
  String fileName = lowerCasePageName + "_page.dart";
  String template = ''' import 'package:flutter/material.dart';
import 'package:$package/mvp/contract/${lowerCasePageName}_contract.dart';
import 'package:$package/mvp/presenter/${lowerCasePageName}_presenter_impl.dart';

class ${pageName}Page extends StatefulWidget {
  @override
  State createState() => _${pageName}PageState();
}

class _${pageName}PageState extends State<${pageName}Page> implements ${pageName}View {

  ${pageName}PresenterImpl mPresenter;

  @override
  void initState() {
    super.initState();
    mPresenter = ${pageName}PresenterImpl(this);
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

  @override
  void dismissLoading() {}

  @override
  void showLoading() {}

  @override
  void showMessage(String msg) {}
}''';
  _doCreateFile(path, fileName, template);
}

void _doCreateFile(String path, String fileName, String template) {
  Directory(path).createSync(recursive: true);
  File file = new File(path + fileName);
  if (file.existsSync()) {
    print("$fileName exist!!!");
    return null;
  }
  file.writeAsStringSync(template);
}

void _create(String pageName, String lowerCasePageName) {
  // 创建contract
  _createContract(pageName, lowerCasePageName);
  // 创建model
  _createModel(pageName, lowerCasePageName);
  // 创建presenterImpl
  _createPresenterImpl(pageName, lowerCasePageName);
  // 创建view
  _createView(pageName, lowerCasePageName);
}

///转为驼峰命名
///big 是否大驼峰
String _changeToCamelCase(String word, bool big) {
  if (word.contains("_")) {
    String result = "";
    List<String> words = word.split("_");
    for (var value in words) {
      result += (value[0].toUpperCase() + value.substring(1).toLowerCase());
    }
    return big ? result : (result[0].toLowerCase() + result.substring(1));
  } else {
    return big
        ? word[0].toUpperCase() + word.substring(1)
        : word[0].toLowerCase() + word.substring(1);
  }
}

void _checkArgs(List<String> args) {
  if (args == null) {
    throw Exception("page name is null");
  }
  if (args.length != 1) {
    throw Exception("page name is error");
  }
}

void main(List<String> args) {
  try {
    _checkArgs(args);
    _create(_changeToCamelCase(args[0], true), args[0]);
  } catch (e) {
    print(e);
  }
}

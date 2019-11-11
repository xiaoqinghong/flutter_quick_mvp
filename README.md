# flutter_quick_mvp
#### gitee: https://gitee.com/xiaoqinghong/flutter_quick_mvp
#### github: https://github.com/xiaoqinghong/flutter_quick_mvp

Flutter这个跨平台的解决方案先在正发展的火热，最为Android(搬)开(砖)发(的)，自然是想要了解了解。
flutter_quick_mvp是一个自己YY的工程结构的想法，之前用Android模板做过[Kotlin版本的MVP](https://github.com/xiaoqinghong/AndroidQuickMVP)
## Dio+MVP
flutter开发中常用的网络请求框架Dio，在这也是用的这个框架。对于MVP的解释我就不啰嗦了，网上到处都能搜到。M(model)、V(view)、P(presenter)。该工程根目录下有个mvp.dart的文件，将会用这个文件来生成对应的mvp代码。
## 操作起来
1. 下载该项目
2. 将lib/http加入的你的工程中
3. 在lib下创建文件夹，结构：```lib/mvp/base```
4. 将工程中的```lib/mvp/base/base.dart```加入到工程对应目录下
5. 将mvp.dart放到你的根目录，打开mvp.dart
```
// 这里可以替换成自己的包名
const package = "flutter_quick_mvp";
```
## 效果
比如想要创建一个登录页面，在工程根目录下执行（前提是你的flutter和dart的环境已经配置好了）
```
dart mvp.dart login
```
"login"指的是创建的页面的名字，例如我要创建一个设置页面可以这样操作
```
dart mvp.dart app_setting
```
生成工程结构如图所示
![执行命令](http://file.xiaoqinghong.com/images/blog/cmd.png)
![工程结构](http://file.xiaoqinghong.com/images/blog/project.png)
## http模块
###### *lib/http/api.dart
这个文件只存放接口地址，例如在该工程中
```
class Api {
  static const String USER_LOGIN = "v2/star/login";
}
```
###### *lib/http/api_helper.dart
这个文件是对Dio的简单封装，一个单例暴露了get和post两个方法。接收请求地址、参数、回调监听
```
// get
void get(String url,  [Map<String, dynamic> params, ApiStateHook hook) {}
// post
void post(String url,  [Map<String, dynamic> params, ApiStateHook hook) {}
```
###### *lib/http/api_service.dart
这个文件里有两个类，```ApiStateHook```的主要作用是监听一个http请求的开始、成功/失败、结束。```ApiService```的主要作用是做一些http成功(把response转换成需要的结果)或失败(把异常"翻译"成人话)的一些回调处理。
```
// 代理成功处理
void proxySuccessCallBack(Response response,
    ApiStateHook hook) {
  if (hook != null) {
    try {
      hook.onSuccess(json.decode(response.toString()));
    } catch (e) {
      hook.execError("数据解析错误");
      print("callBackErr: $e");
    }
  }
  if (hook != null) hook.execFinally();
}
// 代理异常处理
void proxyErrorCallBack(Exception e, ApiStateHook hook) {
  if (hook != null) {
    hook.execError(_parserException(e));
    hook.execFinally();
  }
}
```
###### *lib/mvp/model/
背后里默默付出的苦逼骚年，只负责对接数据源（http、db......)并由presenter随意调用其函数。还是以登录接口为例，它继承了ApiService，与ApiHelper对接，请求数据，将结果（失败或成功）进行简单的处理，通过函数回调。这层不与presenter绑定的原因是，不绑定，则任何presenter都可以调用它的函数，减少冗余代码。
```
class LoginModel {
  void userLogin(Map<String, dynamic> params, ApiStateHook hook) {
    ApiHelper.instance.post(Api.USER_LOGIN, params, hook);
  }
}
```
###### *lib/mvp/contract/
该目录下的文件用于约定view和presenter间的依赖关系（契约），存放view和presenter中需要被互相调用的方法。
###### *lib/mvp/presenter/
model和view间的中间商，例如登录，在页面中点击一个button发起登录，view<--->presenter<--->model。这一层的作用是将请求传递给model处理，在得到结果后，把结果按照页面需要的形式交给页面做处理。看一个网络请求的例子（用户登录，presenter层调用model层的函数）。
```
void login(String phone, String password, String code) {
    _mModel.userLogin(
        {"phone": phone, "password": password, "code": code},
		//ApiStateHook用于监听一个请求的各个阶段，可以只监听自己需要的
        new ApiStateHook()
            .onStart(() => mView.showLoading())
            .onError((String msg) => mView.showMessage(msg))
            .onFinally(() => mView.dismissLoading())
            .onSuccess((Map<String, dynamic> resp) {})
    );
  }
```
###### *lib/mvp/view/
这一层只管貌美如花就行了，脏活累活只管交给小弟（presenter）去做就行了。
## 网络乞丐环节
希望可以骗你点个赞T_T。
abstract class IView<T extends IPresenter> {
  void showMessage(String msg);

  void showLoading();

  void dismissLoading();
}

abstract class IPresenter {}

class SimplePresenter<T extends IView> {
  T mView;

  SimplePresenter(T view) {
    _attachView(view);
  }

  void _attachView(T view) {
    this.mView = view;
  }
}

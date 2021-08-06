void main() {
  SingletonTest().showYourSelf();
  SingletonTest().showYourSelf();
  SingletonTest().showYourSelf();
  SingletonTest().showYourSelf();
}

class SingletonTest {
  static SingletonTest _instance = SingletonTest._internal();

  SingletonTest._internal();

  factory SingletonTest() {
    return _instance;
  }

  void showYourSelf() {
    print('I am : ${this.hashCode}');
  }
}

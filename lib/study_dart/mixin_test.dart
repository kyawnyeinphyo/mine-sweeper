void main() {
  C4()
    ..hey()
    ..hi();
}

class M1 {
  void showYourSelf() {
    print('I am M1');
  }
}

class M2 {
  void showYourSelf() {
    print('I am M2');
  }
}

class C1 with M1, M2 {}

mixin M3 {
  void showYourSelf() {
    print('I am M3');
  }

  void sayHello() {
    print('Hello World');
  }
}

class C2 with M3 {}

abstract class C3 {
  void hi();

  void hey() {
    print("hello world");
  }
}

class C4 extends C3 {
  @override
  void hi() {
    print("Hey Hello");
  }
}

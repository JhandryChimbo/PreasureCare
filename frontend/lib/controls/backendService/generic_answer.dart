class GenericAnswer {
  String msg;
  int code;
  dynamic data;

  GenericAnswer({
    required this.msg,
    required this.code,
    this.data = const {},
  });
}
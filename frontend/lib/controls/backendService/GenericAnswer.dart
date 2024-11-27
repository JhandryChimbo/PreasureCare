class GenericAnswer {
  String msg;
  int code;
  Map<String, dynamic> data;

  GenericAnswer({
    required this.msg,
    required this.code,
    this.data = const {},
  });
}
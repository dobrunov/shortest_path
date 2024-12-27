class ServerResponse {
  final bool error;
  final String message;
  final List<Confirm> data;

  ServerResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<Confirm> dataItems = dataList.map((item) => Confirm.fromJson(item)).toList();

    return ServerResponse(
      error: json['error'],
      message: json['message'],
      data: dataItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'ServerResponse(error: $error, message: $message, data: $data)';
  }
}

class Confirm {
  final String id;
  final bool correct;

  Confirm({
    required this.id,
    required this.correct,
  });

  factory Confirm.fromJson(Map<String, dynamic> json) {
    return Confirm(
      id: json['id'],
      correct: json['correct'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correct': correct,
    };
  }

  @override
  String toString() {
    return 'DataItem(id: $id, correct: $correct)';
  }
}

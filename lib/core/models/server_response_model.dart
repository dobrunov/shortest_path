class ServerResponse {
  final bool error;
  final String message;
  final List<DataItem> data;

  ServerResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<DataItem> dataItems = dataList.map((item) => DataItem.fromJson(item)).toList();

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

class DataItem {
  final String id;
  final bool correct;

  DataItem({
    required this.id,
    required this.correct,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
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

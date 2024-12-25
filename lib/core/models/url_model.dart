import 'package:hive/hive.dart';

class UrlModel {
  final String url;

  UrlModel({required this.url});
}

class UrlModelAdapter extends TypeAdapter<UrlModel> {
  @override
  final typeId = 0;

  @override
  UrlModel read(BinaryReader reader) {
    final url = reader.readString();
    return UrlModel(url: url);
  }

  @override
  void write(BinaryWriter writer, UrlModel obj) {
    writer.writeString(obj.url);
  }
}

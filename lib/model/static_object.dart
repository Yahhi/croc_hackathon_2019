import 'package:miners/model/InMapObject.dart';

class StaticObject extends InMapObject {
  final String lastUpdate;

  StaticObject.fromJson(Map<String, dynamic> map)
      : this.lastUpdate = map["data"] == null
            ? DateTime.now().toIso8601String()
            : map["data"]["date"],
        super(map["id"], map["deviceId"], map["x"], map["y"]);
}

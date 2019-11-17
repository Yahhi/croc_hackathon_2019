import 'package:miners/model/InMapObject.dart';

class StaticObject extends InMapObject {
  final String lastUpdate;
  final double pressure;
  final double levelCO;

  StaticObject.fromJson(Map<String, dynamic> map)
      : this.lastUpdate = map["data"] == null
            ? DateTime.now().toIso8601String()
            : map["data"]["date"],
        this.pressure = map["pressure"],
        this.levelCO = map["co"],
        super(map["id"], map["deviceId"], map["x"], map["y"]);
}

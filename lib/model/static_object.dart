import 'package:miners/model/InMapObject.dart';

class StaticObject extends InMapObject {
  final String lastUpdate;
  final double levelCO, temperature, humidity, gas;
  final int peopleCount;

  //{"co":0,"t":null,"h":null,"gas":null,"persons":null,"date":"2019-11-17T11:34:53.9069844"}
  StaticObject.fromJson(Map<String, dynamic> map)
      : this.lastUpdate = map["data"] == null
            ? DateTime.now().toIso8601String()
            : map["data"]["date"],
        this.peopleCount = map["data"] == null
            ? map["persons"] == null ? 0 : map["persons"]
            : map["data"]["persons"],
        this.temperature = map["t"],
        this.humidity = map["h"],
        this.gas = map["gas"],
        this.levelCO = map["co"],
        super(map["id"], map["deviceId"], map["x"], map["y"]);
}

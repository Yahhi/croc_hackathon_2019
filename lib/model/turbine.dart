import 'package:miners/model/InMapObject.dart';

class Turbine extends InMapObject {
  final int power;
  final bool isUpdatedManually;

  Turbine.fromJson(Map<String, dynamic> map)
      : this.power = map["status"],
        this.isUpdatedManually = map["useManual"],
        super(map["id"], map["model"], map["x"], map["y"]);
//[{"id":2,"mineId":1,"mine":null,"status":50,"x":1,"y":1},{"id":3,"mineId":1,"mine":null,"status":33,"x":2,"y":2}]
//{"id":4,"mineId":1,"mine":null,"deviceId":2,"device":null,"status":100,"useManual":false,"x":2100,"y":1050}
}

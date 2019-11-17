import 'package:miners/model/InMapObject.dart';

class Turbine extends InMapObject {
  final int power;
  final double pressure;
  final double levelCO;

  Turbine.fromJson(Map<String, dynamic> map)
      : this.power = map["status"],
        this.pressure = map["pressure"],
        this.levelCO = map["levelCO"],
        super(map["id"], map["model"], map["x"], map["y"]);
//[{"id":2,"mineId":1,"mine":null,"status":50,"x":1,"y":1},{"id":3,"mineId":1,"mine":null,"status":33,"x":2,"y":2}]
}

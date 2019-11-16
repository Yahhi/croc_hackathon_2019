class Turbine {
  final int id;
  final String model;
  final int power;
  final double pressure;
  final double levelCO;
  final int positionX, positionY;

  Turbine(this.id, this.model, this.power, this.pressure,
      {this.levelCO, this.positionX, this.positionY});

  Turbine.fromJson(Map<String, dynamic> map)
      : this.id = map["id"],
        this.model = map["model"],
        this.power = map["status"],
        this.pressure = map["pressure"],
        this.levelCO = map["levelCO"],
        this.positionX = map["x"],
        this.positionY = map["y"];
//[{"id":2,"mineId":1,"mine":null,"status":50,"x":1,"y":1},{"id":3,"mineId":1,"mine":null,"status":33,"x":2,"y":2}]
}

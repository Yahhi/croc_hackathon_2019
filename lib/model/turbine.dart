class Turbine {
  final int id;
  final String model;
  final double power;
  final double pressure;
  final double levelCO;
  final double positionX, positionY;

  Turbine(this.id, this.model, this.power, this.pressure,
      {this.levelCO, this.positionX, this.positionY});

  Turbine.fromJson(Map<String, dynamic> map)
      : this.id = map["id"],
        this.model = map["model"],
        this.power = map["power"],
        this.pressure = map["pressure"],
        this.levelCO = map["levelCO"],
        this.positionX = map["x"],
        this.positionY = map["y"];
}

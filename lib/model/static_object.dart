class StaticObject {
  final double x, y;
  final ObjectType type;

  StaticObject(this.x, this.y, this.type);
}

enum ObjectType { turbine, reader }

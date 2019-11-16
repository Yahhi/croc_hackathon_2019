class Mine {
  final int id;
  final String title;
  final String imageAddress;
  final int width;
  final int height;

  Mine.fromMap(Map<String, dynamic> json)
      : this.id = json["id"],
        this.title = json["name"],
        this.imageAddress = json["map"],
        this.height = json["height"],
        this.width = json["width"];
}

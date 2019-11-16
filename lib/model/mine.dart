class Mine {
  final int id;
  final String title;
  final String imageAddress;

  Mine.fromMap(Map<String, dynamic> json)
      : this.id = json["id"],
        this.title = json["name"],
        this.imageAddress = json["map"];
}

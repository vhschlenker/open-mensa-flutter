class Canteen {
  final int id;
  final String name, address;
  final List<double> coordinates;

  Canteen({this.id, this.name, this.address, this.coordinates});

  factory Canteen.fromJson(Map<String, dynamic> json) {
    return Canteen(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : null,
    );
  }
}

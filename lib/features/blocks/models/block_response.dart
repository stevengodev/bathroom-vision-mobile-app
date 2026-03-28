class BlockResponse {

  final int id;
  final String name;
  final int numberOfFloors;
  final int numberOfBathrooms;

  BlockResponse({
    required this.id,
    required this.name,
    required this.numberOfFloors,
    required this.numberOfBathrooms
  });

  factory BlockResponse.fromJson(Map<String, dynamic> json) {
    return BlockResponse(
      id: json["id"],
      name: json["name"],
      numberOfFloors: json["numberOfFloors"],
      numberOfBathrooms: json["numberOfBathrooms"]
    );
  }

  int get floors => numberOfFloors;

  int get bathrooms => numberOfBathrooms;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "numberOfFloors": numberOfFloors
    };
  }

}
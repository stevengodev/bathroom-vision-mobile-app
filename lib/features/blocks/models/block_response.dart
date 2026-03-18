class BlockResponse {

  final int id;
  final String name;
  final int numberOfFloors;

  BlockResponse({
    required this.id,
    required this.name,
    required this.numberOfFloors,
  });

  factory BlockResponse.fromJson(Map<String, dynamic> json) {
    return BlockResponse(
      id: json["id"],
      name: json["name"],
      numberOfFloors: json["numberOfFloors"],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "id": id,
  //     "name": name,
  //     "numberOfFloors": numberOfFloors,
  //   };
  // }

}
class BlockRequest {

  final String name;
  final int numberOfFloors;

  BlockRequest({
    required this.name,
    required this.numberOfFloors,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "numberOfFloors": numberOfFloors,
    };
  }

}
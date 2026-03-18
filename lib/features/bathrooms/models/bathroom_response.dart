enum Gender { male, female }

enum BathroomStatus { available, occupied, maintenance }

class BathroomResponse {
  final int id;
  final String gender;
  final String nameBlock;
  final String status;
  final int floor;

  BathroomResponse({
    required this.id,
    required this.gender,
    required this.nameBlock,
    required this.status,
    required this.floor,
  });


}
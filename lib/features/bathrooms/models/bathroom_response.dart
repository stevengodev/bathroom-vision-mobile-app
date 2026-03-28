
import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:bathroom_vision/shared/enums/gender.dart';

class BathroomResponse {
  final int id;
  final Gender gender;
  final int blockId;
  final String nameBlock;
  final BathroomStatus status;
  final int floor;

  BathroomResponse({
    required this.id,
    required this.gender,
    required this.blockId,
    required this.nameBlock,
    required this.status,
    required this.floor,
  });


  factory BathroomResponse.fromJson(Map<String, dynamic> json) {
    return BathroomResponse(
      id: json['id'],
      gender: Gender.values.byName(json['gender']),
      blockId: json['blockId'],
      nameBlock: json['nameBlock'],
      status: BathroomStatus.values.byName(json['status']),
      floor: json['floor'],
    );
  }

}
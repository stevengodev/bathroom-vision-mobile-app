import 'package:bathroom_vision/shared/enums/gender.dart';

class AffectedBathroom {
  final int id;
  final Gender gender;
  final int floor;
  final String blockName;

  const AffectedBathroom({
    required this.id,
    required this.gender,
    required this.floor,
    required this.blockName,
  });

  factory AffectedBathroom.fromJson(Map<String, dynamic> json) {
    return AffectedBathroom(
      id: json["id"],
      gender: Gender.values.firstWhere(
        (e) => e.name == json["gender"].toString(),
      ),
      floor: json["floor"],
      blockName: json["blockName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id,"gender": gender.name, "floor": floor, "blockName": blockName};
  }
}



import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:bathroom_vision/shared/enums/gender.dart';

class BathroomRequest {

  Gender gender;
  int blockId;
  BathroomStatus status;
  int floor;

  BathroomRequest({
    required this.gender,
    required this.blockId,
    required this.status,
    required this.floor,
  });

  Map<String, dynamic> toJson() {
    return {
      "gender": gender.name,
      "blockId": blockId,
      "status": status.name,
      "floor": floor,
    };
  }

}

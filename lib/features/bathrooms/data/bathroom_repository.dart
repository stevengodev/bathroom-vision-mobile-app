import 'package:bathroom_vision/features/bathrooms/data/bathroom_api.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_request.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';
import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:bathroom_vision/shared/enums/gender.dart';

class BathroomRepository {
  final BathroomApi api;

  BathroomRepository(this.api);

  Future<List<BathroomResponse>> getAllBathrooms() async {
    return await api.getAllBathrooms();
  }

  Future<List<BathroomResponse>> getBathroomsByStatus(String status) async {
    return await api.getBathroomsByStatus(status);
  }

  Future<List<BathroomResponse>> getBathroomsByBlock(int blockId) async {
    return await api.getBathroomsByBlock(blockId);
  }

  Future<BathroomResponse> getBathroomById(int id) async {
    return await api.getBathroomById(id);
  }

  Future<List<BathroomResponse>> searchBathrooms({
    BathroomStatus? status,
    Gender? gender,
    int? blockId,
    String? query,
  }) async {
    return await api.searchBathrooms(
      status: status,
      gender: gender,
      blockId: blockId,
      query: query,
    );
  }

  Future<BathroomResponse> createBathroom(BathroomRequest request) async {
    return await api.createBathroom(request);
  }

  Future<BathroomResponse> updateBathroom(
      int id, BathroomRequest request) async {
    return await api.updateBathroom(id, request);
  }

  Future<void> deleteBathroom(int id) async {
    await api.deleteBathroom(id);
  }

  Future<BathroomResponse> updateBathroomStatus(int id, String status) async {
    return await api.updateBathroomStatus(id, status);
  }
}
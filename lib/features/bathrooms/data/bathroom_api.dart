import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_request.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';
import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:bathroom_vision/shared/enums/gender.dart';

class BathroomApi {
  final ApiClient apiClient;

  BathroomApi(this.apiClient);

  Future<List<BathroomResponse>> getAllBathrooms() async {
    final response = await apiClient.dio.get("/api/bathrooms");
    final List data = response.data;
    return data.map((e) => BathroomResponse.fromJson(e)).toList();
  }

  Future<List<BathroomResponse>> getBathroomsByStatus(String status) async {
    final response = await apiClient.dio.get(
      "/api/bathrooms",
      queryParameters: {"status": status},
    );

    final List data = response.data;
    return data.map((e) => BathroomResponse.fromJson(e)).toList();
  }

  Future<List<BathroomResponse>> getBathroomsByBlock(int blockId) async {
    final response =
        await apiClient.dio.get("/api/bathrooms/block/$blockId");

    final List data = response.data;
    return data.map((e) => BathroomResponse.fromJson(e)).toList();
  }

  Future<BathroomResponse> getBathroomById(int id) async {
    final response = await apiClient.dio.get("/api/bathrooms/$id");
    return BathroomResponse.fromJson(response.data);
  }

  /// Buscar baños con filtros
  Future<List<BathroomResponse>> searchBathrooms({
    BathroomStatus? status,
    Gender? gender,
    int? blockId,
    String? query
  }) async {
    try {
      // Construir parámetros de query solo con los valores no nulos
      final Map<String, dynamic> queryParams = {};
 
      if (status != null) {
        queryParams['status'] = status.name;
      }
 
      if (gender != null) {
        queryParams['gender'] = gender.name;
      }
 
      if (blockId != null) {
        queryParams['blockId'] = blockId.toString();
      }
 
      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }
 
      print('BathroomApi: Buscando baños con filtros: $queryParams');
 
      final response = await apiClient.dio.get(
        '/api/bathrooms/search',
        queryParameters: queryParams,
      );
 
      print('BathroomApi: Respuesta recibida');
 
      if (response.data == null) {
        throw Exception('Respuesta vacía del servidor');
      }

      print(response.data);
 
      final List data = response.data;

      final List<BathroomResponse> bathrooms = data.map((e) => BathroomResponse.fromJson(e)).toList();

      print('BathroomApi: ${data.length} baños encontrados');
 
      return bathrooms;
    } catch (e) {
      print('BathroomApi Error: $e');
      rethrow;
    }
  }

  Future<BathroomResponse> createBathroom(BathroomRequest request) async {
    final response = await apiClient.dio.post(
      "/api/bathrooms",
      data: request.toJson(),
    );

    return BathroomResponse.fromJson(response.data);
  }

  Future<BathroomResponse> updateBathroom(int id, BathroomRequest request) async {
    final response = await apiClient.dio.put(
      "/api/bathrooms/$id",
      data: request.toJson(),
    );

    return BathroomResponse.fromJson(response.data);
  }

  Future<void> deleteBathroom(int id) async {
    await apiClient.dio.delete("/api/bathrooms/$id");
  }

  Future<BathroomResponse> updateBathroomStatus(int id, String status) async {
    final response = await apiClient.dio.patch(
      "/api/bathrooms/$id/status",
      data: {"status": status},
    );

    return BathroomResponse.fromJson(response.data);
  }

}
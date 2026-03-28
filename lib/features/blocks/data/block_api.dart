import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/models/block_response.dart';

class BlockApi {

  final ApiClient apiClient;

  BlockApi(this.apiClient);

  Future<List<BlockResponse>> getAllBlocks() async {
    final response = await apiClient.dio.get("/api/blocks");
    final List data = response.data;
    return data.map((e) => BlockResponse.fromJson(e)).toList();
  }

  Future<BlockResponse> getBlockById(int id) async {
    final response = await apiClient.dio.get("/api/blocks/$id");
    return BlockResponse.fromJson(response.data);
  }

  Future<BlockResponse> createBlock(BlockRequest blockRequest) async {

    final response = await apiClient.dio.post(
      "/api/blocks",
      data: blockRequest.toJson()
    );

    return BlockResponse.fromJson(response.data);
  }

  Future<BlockResponse> updateBlock(int id, BlockRequest blockRequest) async {

    final response = await apiClient.dio.put(
      "/api/blocks/$id",
      data:  blockRequest.toJson(),
    );

    return BlockResponse.fromJson(response.data);
  }

  Future<void> deleteBlock(int id) async {
    await apiClient.dio.delete("/api/blocks/$id");
  }
}
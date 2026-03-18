
import 'package:bathroom_vision/features/blocks/data/block_api.dart';
import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/models/block_response.dart';

class BlockRepository {

  final BlockApi api;

  BlockRepository(this.api);

  Future<List<BlockResponse>> getAllBlocks() {
    return api.getAllBlocks();
  }

  Future<BlockResponse> getBlockById(int id) {
    return api.getBlockById(id);
  }

  Future<BlockResponse> createBlock(BlockRequest blockRequest) {
    return api.createBlock(blockRequest);
  }

  Future<BlockResponse> updateBlock(int id, BlockRequest blockRequest) {
    return api.updateBlock(id, blockRequest);
  }

  Future<void> deleteBlock(int id) {
    return api.deleteBlock(id);
  }
}
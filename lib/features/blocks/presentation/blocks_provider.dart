import 'package:bathroom_vision/features/blocks/data/block_repository.dart';
import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/models/block_response.dart';
import 'package:flutter/material.dart';

class BlocksProvider extends ChangeNotifier {

  final BlockRepository repository;

  BlocksProvider(this.repository);

  List<BlockResponse> blocks = [];

  bool loading = false;

  Future<void> loadBlocks() async {

    loading = true;
    notifyListeners();

    try {
      blocks = await repository.getAllBlocks();
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> createBlock(BlockRequest request) async {
    final block = await repository.createBlock(request);
    blocks.add(block);
    notifyListeners();
  }

  Future<void> deleteBlock(int id) async {
    await repository.deleteBlock(id);
    blocks.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
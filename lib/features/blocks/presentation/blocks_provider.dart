import 'package:bathroom_vision/features/blocks/data/block_repository.dart';
import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/models/block_response.dart';
import 'package:flutter/material.dart';

class BlocksProvider extends ChangeNotifier {
  final BlockRepository repository;

  BlockResponse? selectedBlock;

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

  Future<void> loadBlockById(int id) async {
    loading = true;
    notifyListeners();

    try {
      selectedBlock = await repository.getBlockById(id);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> createBlock(BlockRequest request) async {
    try {
      final block = await repository.createBlock(request);
      blocks.add(block);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteBlock(int id) async {
    try {
      await repository.deleteBlock(id);
      blocks.removeWhere((b) => b.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateBlock(int id, BlockRequest request) async {
    try {
      final updatedBlock = await repository.updateBlock(id, request);

      final index = blocks.indexWhere((b) => b.id == id);
      if (index != -1) {
        blocks[index] = updatedBlock;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

import 'package:bathroom_vision/features/blocks/data/block_repository.dart';
import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/models/block_response.dart';
import 'package:flutter/material.dart';

class BlocksProvider extends ChangeNotifier {
  final BlockRepository repository;

  BlockResponse? selectedBlock;

  BlocksProvider(this.repository);

  List<BlockResponse> _allBlocks = [];
  List<BlockResponse> blocks = [];
  String searchQuery = '';

  bool loading = false;

  void _applyFilter() {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      blocks = List.from(_allBlocks);
      return;
    }

    blocks = _allBlocks
        .where((block) => block.name.toLowerCase().contains(normalizedQuery))
        .toList();
  }

  Future<void> loadBlocks() async {
    loading = true;
    notifyListeners();

    try {
      _allBlocks = await repository.getAllBlocks();
      _applyFilter();
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
      _allBlocks.add(block);
      _applyFilter();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteBlock(int id) async {
    try {
      await repository.deleteBlock(id);
      _allBlocks.removeWhere((b) => b.id == id);
      _applyFilter();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateBlock(int id, BlockRequest request) async {
    try {
      final updatedBlock = await repository.updateBlock(id, request);

      final index = _allBlocks.indexWhere((b) => b.id == id);
      if (index != -1) {
        _allBlocks[index] = updatedBlock;
      }

      _applyFilter();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void searchBlocksByName(String query) {
    searchQuery = query;
    _applyFilter();
    notifyListeners();
  }
}

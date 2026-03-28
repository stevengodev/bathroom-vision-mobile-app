import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:bathroom_vision/shared/enums/gender.dart';
import 'package:flutter/material.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_request.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';
import 'package:bathroom_vision/features/bathrooms/data/bathroom_repository.dart';

class BathroomProvider extends ChangeNotifier {
  final BathroomRepository repository;

  BathroomProvider(this.repository);

  // Estado
  List<BathroomResponse> _bathrooms = [];
  BathroomResponse? _selectedBathroom;
  bool _loading = false;
  String? _error;

  // Filtros actuales
  BathroomStatus? _currentStatus;
  Gender? _currentGender;
  int? _currentBlockId;
  String? _currentQuery;

  // Getters
  bool get loading => _loading;
  String? get error => _error;
  BathroomResponse? get selectedBathroom => _selectedBathroom;
  List<BathroomResponse> get bathrooms => _bathrooms;
  BathroomStatus? get currentStatus => _currentStatus;
  Gender? get currentGender => _currentGender;
  int? get currentBlockId => _currentBlockId;
  String? get currentQuery => _currentQuery;

  Future<void> loadBathrooms() async {
    if (bathrooms.isNotEmpty) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _bathrooms = await repository.getAllBathrooms();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refreshBathrooms() async {
    _loading = true;
    notifyListeners();

    try {
      _bathrooms = await repository.getAllBathrooms();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadBathroomById(int id) async {
    _loading = true;
    notifyListeners();

    try {
      _selectedBathroom = await repository.getBathroomById(id);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> createBathroom(BathroomRequest request) async {
    try {
      final newBathroom = await repository.createBathroom(request);

      _bathrooms.add(newBathroom);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateBathroom(int id, BathroomRequest request) async {
    try {
      final updated = await repository.updateBathroom(id, request);

      final index = bathrooms.indexWhere((b) => b.id == id);

      if (index != -1) {
        bathrooms[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deleteBathroom(int id) async {
    try {
      await repository.deleteBathroom(id);

      _bathrooms.removeWhere((b) => b.id == id);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> updateBathroomStatus(int id, String status) async {
    try {
      final updated = await repository.updateBathroomStatus(id, status);

      final index = bathrooms.indexWhere((b) => b.id == id);

      if (index != -1) {
        bathrooms[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> loadBathroomsByBlock(int blockId) async {
    _loading = true;
    notifyListeners();

    try {
      _bathrooms = await repository.getBathroomsByBlock(blockId);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadBathroomsByStatus(String status) async {
    _loading = true;
    notifyListeners();

    try {
      _bathrooms = await repository.getBathroomsByStatus(status);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  /// Buscar baños con los filtros actuales
  Future<void> searchBathrooms({
    BathroomStatus? status,
    Gender? gender,
    int? blockId,
    String? query,
  }) async {
    try {
      _loading = true;
      _error = null;

      // Guardar filtros actuales
      _currentStatus = status;
      _currentGender = gender;
      _currentBlockId = blockId;
      _currentQuery = query;

      notifyListeners();

      print('BathroomProvider: Buscando baños con filtros...');

      _bathrooms = await repository.searchBathrooms(
        status: status,
        gender: gender,
        blockId: blockId,
        query: query,
      );

      print('BathroomProvider: ${_bathrooms.length} baños encontrados');
    } catch (e) {
      print('BathroomProvider Error: $e');
      _error = e.toString();
      _bathrooms = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Cargar todos los baños (sin filtros)
  Future<void> loadAllBathrooms() async {
    await searchBathrooms();
  }

  Future<void> clearFilters() async {
    await searchBathrooms(
      status: null,
      gender: null,
      blockId: null,
      query: null,
    );
  }

  /// Verificar si hay filtros activos
  bool get hasActiveFilters {
    return _currentStatus != null ||
        _currentGender != null ||
        _currentBlockId != null ||
        (_currentQuery != null && _currentQuery!.isNotEmpty);
  }
}

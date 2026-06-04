import 'package:flutter/material.dart';
import '../models/record.dart';
import '../models/asset.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  final _storage = StorageService();

  List<Record> _records = [];
  List<Asset> _assets = [];
  String _themeName = 'auto';

  List<Record> get records => _records;
  List<Asset> get assets => _assets;

  ThemeMode get themeMode {
    switch (_themeName) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }

  Future<void> init() async {
    await _storage.init();
    _records = await _storage.loadRecords();
    _assets = await _storage.loadAssets();
    _themeName = _storage.getTheme();
    notifyListeners();
  }

  // Records
  Future<void> addRecord(Record record) async {
    _records.insert(0, record);
    _records.sort((a, b) => b.date.compareTo(a.date));
    await _storage.saveRecords(_records);
    notifyListeners();
  }

  Future<void> updateRecord(Record record) async {
    final idx = _records.indexWhere((r) => r.id == record.id);
    if (idx >= 0) {
      _records[idx] = record;
      _records.sort((a, b) => b.date.compareTo(a.date));
      await _storage.saveRecords(_records);
      notifyListeners();
    }
  }

  Future<void> deleteRecord(String id) async {
    _records.removeWhere((r) => r.id == id);
    await _storage.saveRecords(_records);
    notifyListeners();
  }

  // Assets
  Future<void> addAsset(Asset asset) async {
    _assets.add(asset);
    await _storage.saveAssets(_assets);
    notifyListeners();
  }

  Future<void> updateAsset(Asset asset) async {
    final idx = _assets.indexWhere((a) => a.id == asset.id);
    if (idx >= 0) {
      _assets[idx] = asset;
      await _storage.saveAssets(_assets);
      notifyListeners();
    }
  }

  // Theme
  Future<void> setTheme(String theme) async {
    _themeName = theme;
    await _storage.setTheme(theme);
    notifyListeners();
  }

  // Stats
  double getMonthIncome(String ym) {
    return _records
        .where((r) => r.type == RecordType.income && _ym(r.date) == ym)
        .fold(0.0, (sum, r) => sum + r.amount);
  }

  double getMonthExpense(String ym) {
    return _records
        .where((r) => r.type == RecordType.expense && _ym(r.date) == ym)
        .fold(0.0, (sum, r) => sum + r.amount);
  }

  String _ym(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}';
}

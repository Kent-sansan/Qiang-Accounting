import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/record.dart';
import '../models/asset.dart';

class StorageService {
  static const _keyRecords = 'jz_records';
  static const _keyAssets = 'jz_assets';
  static const _keyTheme = 'jz_theme';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Records
  Future<List<Record>> loadRecords() async {
    final raw = _prefs.getString(_keyRecords);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((r) => Record.fromJson(r)).toList();
  }

  Future<void> saveRecords(List<Record> records) async {
    final raw = jsonEncode(records.map((r) => r.toJson()).toList());
    await _prefs.setString(_keyRecords, raw);
  }

  // Assets
  Future<List<Asset>> loadAssets() async {
    final raw = _prefs.getString(_keyAssets);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((a) => Asset.fromJson(a)).toList();
  }

  Future<void> saveAssets(List<Asset> assets) async {
    final raw = jsonEncode(assets.map((a) => a.toJson()).toList());
    await _prefs.setString(_keyAssets, raw);
  }

  // Theme
  String getTheme() => _prefs.getString(_keyTheme) ?? 'auto';
  Future<void> setTheme(String theme) => _prefs.setString(_keyTheme, theme);
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _brewsKey = 'brews';

  static Future<void> saveBrew(Map<String, dynamic> brew) async {
    final prefs = await SharedPreferences.getInstance();

    final existingBrews = prefs.getStringList(_brewsKey) ?? [];

    existingBrews.add(jsonEncode(brew));

    await prefs.setStringList(_brewsKey, existingBrews);
  }

  static Future<List<Map<String, dynamic>>> getBrews() async {
    final prefs = await SharedPreferences.getInstance();

    final savedBrews = prefs.getStringList(_brewsKey) ?? [];

    return savedBrews
        .map((brew) => Map<String, dynamic>.from(jsonDecode(brew)))
        .toList();
  }

  static Future<void> updateBrew(
    int index,
    Map<String, dynamic> brew,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final existingBrews = prefs.getStringList(_brewsKey) ?? [];

    if (index < 0 || index >= existingBrews.length) return;

    existingBrews[index] = jsonEncode(brew);

    await prefs.setStringList(_brewsKey, existingBrews);
  }

  static Future<void> deleteBrew(int index) async {
    final prefs = await SharedPreferences.getInstance();

    final existingBrews = prefs.getStringList(_brewsKey) ?? [];

    if (index < 0 || index >= existingBrews.length) return;

    existingBrews.removeAt(index);

    await prefs.setStringList(_brewsKey, existingBrews);
  }

  static Future<void> toggleFavorite(int index) async {
  final prefs = await SharedPreferences.getInstance();

  final existingBrews = prefs.getStringList(_brewsKey) ?? [];

  if (index < 0 || index >= existingBrews.length) return;

  final brew = Map<String, dynamic>.from(
    jsonDecode(existingBrews[index]),
  );

  final currentFavorite = brew['favorite'] == true;

  brew['favorite'] = !currentFavorite;

  existingBrews[index] = jsonEncode(brew);

  await prefs.setStringList(_brewsKey, existingBrews);
}
}
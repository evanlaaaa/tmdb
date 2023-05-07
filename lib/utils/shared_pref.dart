import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _instance;

  static Future<SharedPreferences> init() async => _instance = await SharedPreferences.getInstance();

  static Future<bool> writeHistory(List<String> history) async {
    await _instance!.setStringList("history", history);
    return true;
  }

  static List<String> readHistory() {
    return _instance!.getStringList("history") ?? [];
  }
}
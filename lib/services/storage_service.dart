import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class StorageService {
  static const _key = 'tasks_v1';
  static const _darkKey = 'dark_mode';

  Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map(TaskModel.fromJson).toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, tasks.map((t) => t.toJson()).toList());
  }

  Future<bool> loadDark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkKey) ?? false;
  }

  Future<void> saveDark(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, v);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'interfaces/i_history_storage.dart';

class HistoryStorageService implements IHistoryStorage {
  static final HistoryStorageService instance = HistoryStorageService._();
  HistoryStorageService._();

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/history.json');
  }

  @override
  Future<void> saveHistory(List<Map<String, String>> history) async {
    final file = await _getLocalFile();
    final jsonString = jsonEncode(history);
    await file.writeAsString(jsonString);
  }

  @override
  Future<List<Map<String, String>>> loadHistory() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((item) => Map<String, String>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }
}

// hex_storage.dart
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

Future<String> generateHex() async {
  final random = Random();
  const chars = '0123456789ABCDEF';
  String hex = List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  return hex;
}

Future<String?> getHexFromFile() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/hex_string.txt');
    if (await file.exists()) {
      return await file.readAsString();
    }
  } catch (e) {
    // print('Error reading file: $e');
  }
  return null;
}

Future<void> saveHexToFile(String hex) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/hex_string.txt');
    await file.writeAsString(hex);
  } catch (e) {
    // print('Error writing to file: $e');
  }
}

Future<String> getOrCreateHex() async {
  String? hex = await getHexFromFile();
  if (hex == null) {
    // If the file doesn't exist or hex is null, generate a new one
    hex = await generateHex();
    await saveHexToFile(hex);
  }
  return hex;
}

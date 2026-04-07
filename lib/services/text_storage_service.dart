import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'interfaces/i_device_id_service.dart';

class DeviceIdService implements IDeviceIdService {
  static final DeviceIdService instance = DeviceIdService._();
  DeviceIdService._();

  Future<String> _generateHex() async {
    final random = Random();
    const chars = '0123456789ABCDEF';
    return List.generate(8, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<String?> _getHexFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/hex_string.txt');
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (_) {}
    return null;
  }

  Future<void> _saveHexToFile(String hex) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/hex_string.txt');
      await file.writeAsString(hex);
    } catch (_) {}
  }

  @override
  Future<String> getOrCreateHex() async {
    String? hex = await _getHexFromFile();
    if (hex == null) {
      hex = await _generateHex();
      await _saveHexToFile(hex);
    }
    return hex;
  }
}

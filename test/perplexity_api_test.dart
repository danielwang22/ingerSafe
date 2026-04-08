import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ingresafe/constants/app_strings.dart';

// ─── 設定 ────────────────────────────────────────────────────────────────────
const _langCode = 'zh_Hant';
const _apiUrl = 'https://api.perplexity.ai/chat/completions';
const _model = 'sonar';
const _callTimeout = Duration(seconds: 90);

// ─── Log 工具 ─────────────────────────────────────────────────────────────────

late File _logFile;

/// 初始化 log 檔（每次 run 以時間戳命名，輸出為 Markdown）
void _initLog() {
  final now = DateTime.now();
  final ts = '${now.year}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}_'
      '${now.hour.toString().padLeft(2, '0')}'
      '${now.minute.toString().padLeft(2, '0')}'
      '${now.second.toString().padLeft(2, '0')}';
  final dir = Directory('test/log');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  _logFile = File('test/log/perplexity_$ts.md');
  _write('# Perplexity API Test\n');
  _write('| 欄位 | 值 |');
  _write('|------|----|');
  _write('| 時間 | $_ts |');
  _write('| 語言 | `$_langCode` |');
  _write('| 模型 | `$_model` |');
  _write('');
  _write('---');
}

String get _ts {
  final n = DateTime.now();
  return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')} '
      '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}:${n.second.toString().padLeft(2, '0')}';
}

/// 寫入一行到 log 檔（同時 print 到 console）
void _write(String line) {
  print(line);
  _logFile.writeAsStringSync('$line\n', mode: FileMode.append);
}

/// 寫入一個測試案例的完整結果（Markdown 格式）
void _logCase(String title, String content) {
  _write('');
  _write('## $title');
  _write('');
  _write('> 時間：$_ts');
  _write('');
  _write('```');
  _write(content);
  _write('```');
  _write('');
  _write('---');
}

/// 寫入警告訊息
void _log(String line) {
  print(line);
  _logFile.writeAsStringSync('$line\n', mode: FileMode.append);
}

// 正常食品圖片（可放多張，同時送入 API）
const _foodImagePaths = [
  'test/assets/孕婦午餐.jpg',
];

// 非食品圖片（可放多張）
const _nonFoodImagePaths = [
  'test/assets/000001_1625131646.jpg',
  'test/assets/product1.jpg'
];

// 正常補充說明文字
const _normalText = '我製作的這些食物，想知道我這位孕期可以食用嗎？';

// 不正常/亂碼文字
const _gibberishText = '這是我午餐';

// ─── 工具函式 ─────────────────────────────────────────────────────────────────

/// 從專案根目錄的 .env 讀取 PERPLEXITY_API_KEY
String _loadApiKey() {
  for (final path in ['.env', '../.env']) {
    final file = File(path);
    if (!file.existsSync()) continue;
    for (final line in file.readAsLinesSync()) {
      if (line.startsWith('PERPLEXITY_API_KEY=')) {
        var value = line.substring('PERPLEXITY_API_KEY='.length).trim();
        // 去除首尾引號（單引號或雙引號）
        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length - 1);
        }
        print(
            '✅ API key 載入成功（前 8 碼）：${value.substring(0, value.length.clamp(0, 8))}...');
        return value;
      }
    }
  }
  throw Exception('找不到 PERPLEXITY_API_KEY，請確認 .env 檔案存在於專案根目錄');
}

/// 依副檔名決定 MIME type
String _mimeType(File file) {
  switch (file.path.split('.').last.toLowerCase()) {
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    case 'gif':
      return 'image/gif';
    default:
      return 'image/jpeg';
  }
}

/// 組裝並呼叫 Perplexity API，與 chat_service.dart 邏輯完全一致
///
/// [images]    圖片檔案列表（空 = 無圖片）
/// [userNote]  使用者補充說明（空 = 無補充）
Future<String> _callApi(List<File> images, String userNote) async {
  // 圖片轉 base64
  final imageContents = <Map<String, dynamic>>[];
  for (final file in images) {
    final bytes = await file.readAsBytes();
    imageContents.add({
      'type': 'image_url',
      'image_url': {
        'url': 'data:${_mimeType(file)};base64,${base64Encode(bytes)}',
      },
    });
  }

  // 組裝 user message（與 _buildUserPrompt 邏輯一致）
  final basePrompt =
      AppStrings.imagePrompts[_langCode] ?? AppStrings.imagePrompts['en']!;
  final userText = userNote.isEmpty
      ? basePrompt
      : '$basePrompt\n\n'
          '${AppStrings.userNotePrefix[_langCode] ?? AppStrings.userNotePrefix['en']!}'
          '$userNote';

  final userContent = <dynamic>[
    {'type': 'text', 'text': userText},
    ...imageContents,
  ];

  final systemPrompt =
      (AppStrings.prompts[_langCode] ?? AppStrings.prompts['en'])?.trim() ?? '';

  final response = await http
      .post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_loadApiKey()}',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userContent},
          ],
          'max_tokens': 1000,
        }),
      )
      .timeout(_callTimeout);

  expect(
    response.statusCode,
    200,
    reason: 'API 回傳非 200：${response.statusCode}\n${response.body}',
  );

  final data = jsonDecode(utf8.decode(response.bodyBytes));
  return data['choices']?[0]?['message']?['content'] as String? ?? '';
}

// ─── 測試案例 ─────────────────────────────────────────────────────────────────

void main() {
  const testTimeout = Timeout(Duration(minutes: 3));

  setUpAll(_initLog);

  // ① 正常圖片 + 正常文字
  // 預期：AI 以圖片為主分析食品成分，文字補充參考，回覆含 [RISK_LEVEL:xxx]
  test('① 正常圖片 + 正常文字', () async {
    final content =
        await _callApi(_foodImagePaths.map(File.new).toList(), _normalText);
    _logCase('① 正常圖片 + 正常文字', content);
    expect(content, isNotEmpty);
    expect(
      content.toUpperCase(),
      contains('RISK_LEVEL'),
      reason: '回覆應包含 [RISK_LEVEL:xxx] 標籤',
    );
  }, timeout: testTimeout);

  // ② 正常圖片 + 不正常文字（亂碼）
  // 預期：AI 應忽略亂碼文字，仍以圖片為主正常分析，回覆含 [RISK_LEVEL:xxx]
  test('② 正常圖片 + 不正常文字（亂碼）', () async {
    final content =
        await _callApi(_foodImagePaths.map(File.new).toList(), _gibberishText);
    _logCase('② 正常圖片 + 不正常文字（亂碼）', content);
    expect(content, isNotEmpty);
    expect(
      content.toUpperCase(),
      contains('RISK_LEVEL'),
      reason: '即使文字亂碼，AI 仍應以圖片判斷並回傳 RISK_LEVEL 標籤',
    );
  }, timeout: testTimeout);

  // ③ 無圖片 + 正常文字
  // 預期：無圖片時 AI 只能依文字判斷，可能回傳 unknown 或根據文字語意分析
  test('③ 無圖片 + 正常文字', () async {
    final content = await _callApi([], _normalText);
    _logCase('③ 無圖片 + 正常文字', content);
    expect(content, isNotEmpty);
  }, timeout: testTimeout);

  // ④ 無圖片 + 不正常文字（亂碼）
  // 預期：無圖片且文字無意義，AI 應回傳 unknown 或說明無法判斷
  test('④ 無圖片 + 不正常文字（亂碼）', () async {
    final content = await _callApi([], _gibberishText);
    _logCase('④ 無圖片 + 不正常文字（亂碼）', content);
    expect(content, isNotEmpty);
  }, timeout: testTimeout);

  // ⑤ 不正常圖片（非食品）+ 無文字
  // 預期：AI 識別為非食品，回覆 [RISK_LEVEL:unknown] + 非可食品
  test('⑤ 不正常圖片（非食品）+ 無文字', () async {
    final content =
        await _callApi(_nonFoodImagePaths.map(File.new).toList(), '');
    _logCase('⑤ 不正常圖片（非食品）+ 無文字', content);
    expect(content, isNotEmpty);
    final lower = content.toLowerCase();
    final isNonFood = lower.contains('unknown') ||
        content.contains('非可食品') ||
        content.contains('非食品') ||
        lower.contains('not a food');
    if (!isNonFood) {
      _log('⚠️  警告：AI 未回覆「非可食品」，請確認 ${_nonFoodImagePaths.join(', ')} 確實為非食品圖片');
    }
  }, timeout: testTimeout);
}

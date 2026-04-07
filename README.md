# IngreSafe

<p align="center">
  <img src="assets/icon/logo.png" alt="IngreSafe Logo" width="120"/>
</p>

<p align="center">
  <strong>AI 驅動的產品成分安全分析 App</strong><br>
  專為孕婦與哺乳期女性設計，守護您與寶寶的健康
</p>

<p align="center">
  <a href="#主要功能">功能</a> •
  <a href="#快速開始">快速開始</a> •
  <a href="#技術架構">技術</a> •
  <a href="#授權條款">授權</a>
</p>

---

## 關於 IngreSafe

IngreSafe 結合 AI 人工智慧與 OCR 文字辨識技術，幫助孕婦和哺乳期女性快速評估產品成分的安全性。只需拍攝產品標籤，即可獲得即時的風險分析報告。

### 為什麼選擇 IngreSafe？

- 🤖 **AI 智能分析** - 採用 Perplexity AI 提供專業的成分風險評估
- 📸 **快速便捷** - 拍照即可分析，支援多張圖片同時上傳
- 🌍 **多語言支援** - 支援 6 種語言，服務全球用戶
- 💾 **離線儲存** - 所有報告本地保存，隨時查閱歷史記錄
- 🎨 **精美設計** - 現代化 UI/UX，支援深色模式

## 主要功能

### 核心功能
- ✅ **多圖片上傳** - 支援拍照或從相簿選擇多張產品圖片
- ✅ **OCR 文字辨識** - 使用 Google ML Kit 精準識別成分文字
- ✅ **AI 風險分析** - Perplexity AI 智能分析，提供四級風險評估
  - 🟢 安全 (Safe)
  - 🟡 警告 (Warning)
  - 🔴 危險 (Danger)
  - ⚪ 未知 (Unknown)
- ✅ **報告管理** - 完整的歷史記錄儲存、刪除確認與重新分析功能
- ✅ **應用內瀏覽** - 整合 WebView 查看參考資料，無需跳轉外部瀏覽器

### 使用者體驗
- 🌐 **多語言介面** - 繁體中文、English、日本語、한국어、ไทย、Tiếng Việt
- 🌓 **主題切換** - 支援深色/淺色模式，保護眼睛
- 📚 **新手引導** - 首次使用提供完整的互動式教學
- ⚠️ **安全提醒** - 重要的免責聲明與使用注意事項

## 快速開始

### 環境需求

| 項目 | 版本要求 |
|------|---------|
| Flutter SDK | 3.0.0 或更高 |
| Dart | 3.0.0 或更高 |
| iOS | 12.0+ |
| Android | 5.0+ (API Level 21+) |
| Xcode | 15.0+ (iOS 開發) |
| Android Studio | 最新版本 |

### 安裝步驟

1. **Clone 專案**
   ```bash
   git clone https://github.com/yourusername/ingresafe.git
   cd ingresafe
   ```

2. **配置環境變數**
   
   在專案根目錄建立 `.env` 檔案：
   ```env
   PERPLEXITY_API_KEY=your_perplexity_api_key_here
   ```
   
   > 💡 如何取得 API Key: 前往 [Perplexity AI](https://www.perplexity.ai/) 註冊並申請 API 金鑰

3. **安裝依賴套件**
   ```bash
   flutter pub get
   ```

4. **執行應用程式**
   ```bash
   # 開發模式
   flutter run
   
   # 指定裝置
   flutter run -d <device_id>
   
   # 查看可用裝置
   flutter devices
   ```

5. **建置發布版本**
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS (需要 macOS 和 Xcode)
   flutter build ios --release
   ```

## 技術架構

### 核心技術棧

| 類別 | 技術方案 | 用途 |
|------|---------|------|
| **開發框架** | Flutter 3.0+ | 跨平台行動應用開發 |
| **程式語言** | Dart 3.0+ | 應用程式邏輯 |
| **狀態管理** | Riverpod 2.x | 全域狀態、服務注入、非同步資料 |
| **AI 引擎** | Perplexity AI | 成分安全性分析 |
| **OCR 引擎** | Google ML Kit | 文字辨識 |
| **本地資料庫** | Hive | 報告持久化儲存 |
| **檔案儲存** | path_provider | 圖片檔案管理 |
| **雲端服務** | Firebase Firestore | 匿名使用統計 |
| **網頁瀏覽** | flutter_inappwebview | 應用內網頁瀏覽 |

### 主要依賴套件

**核心功能**
- `flutter_riverpod` ^2.6.1 - Riverpod 狀態管理與依賴注入
- `flutter_hooks` ^0.21.2 - React-style hooks 局部狀態
- `google_mlkit_text_recognition` ^0.15.0 - OCR 文字辨識
- `image_picker` ^1.0.4 - 相機與相簿存取
- `hive` + `hive_flutter` - 高效能本地資料庫
- `http` ^1.2.0 - API 請求處理

**使用者介面**
- `google_fonts` ^6.3.3 - Nunito 字體
- `showcaseview` ^5.0.1 - 新手引導教學（ShowcaseView.register() API）
- `flutter_markdown` ^0.7.7 - Markdown 內容渲染
- `dotted_border` ^2.1.0 - 虛線邊框 UI

**工具與整合**
- `flutter_inappwebview` ^6.0.0 - 應用內網頁瀏覽器
- `flutter_dotenv` ^6.0.0 - 環境變數管理
- `firebase_core` + `cloud_firestore` - Firebase 整合
- `shared_preferences` ^2.2.2 - 簡單鍵值儲存
- `package_info_plus` ^8.3.1 - 應用程式版本資訊

### 架構設計

```
lib/
├── constants/          # 常數定義（多語言字串）
├── models/             # 資料模型（Report, RiskLevel）
├── providers/          # Riverpod providers
│   ├── service_providers.dart   # 服務層 Provider<Interface>
│   ├── report_providers.dart    # ReportsNotifier、analyzingCount
│   ├── language_provider.dart   # LanguageNotifier
│   └── theme_provider.dart      # ThemeNotifier
├── screens/            # 畫面元件
├── services/           # 業務邏輯服務層
│   ├── interfaces/    # 抽象介面（IAIService、IReportStorage 等）
│   ├── ai/            # AI 分析服務
│   └── ...            # 其他 singleton 服務
├── theme/              # 主題配置
├── utils/              # 工具函式
└── widgets/            # 可重用元件
```

## 專案結構

```
IngreSafe/
├── lib/                    # 主要程式碼
│   ├── constants/         # 常數與多語言字串
│   ├── models/            # 資料模型
│   ├── providers/         # Riverpod 狀態管理
│   │   ├── service_providers.dart
│   │   ├── report_providers.dart
│   │   ├── language_provider.dart
│   │   └── theme_provider.dart
│   ├── screens/           # 畫面頁面
│   ├── services/          # 業務邏輯
│   │   └── interfaces/   # 抽象介面定義
│   ├── theme/             # 主題配置
│   ├── utils/             # 工具函式
│   └── widgets/           # UI 元件
├── assets/                # 靜態資源
│   ├── fonts/            # 字體檔案
│   ├── icon/             # 應用圖示
│   └── images/           # 圖片資源
├── android/               # Android 平台配置
├── ios/                   # iOS 平台配置
├── macos/                 # macOS 平台配置
└── test/                  # 測試檔案
```

## 開發指南

### 程式碼風格

本專案遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 規範。

執行程式碼檢查：
```bash
flutter analyze
```

### 測試

```bash
# 執行所有測試
flutter test

# 執行特定測試檔案
flutter test test/widget_test.dart
```

### 除錯

```bash
# 啟用 verbose 模式
flutter run -v

# 清除快取
flutter clean
```

## 貢獻指南

我們歡迎任何形式的貢獻！

1. Fork 本專案
2. 建立您的功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的變更 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 開啟 Pull Request

### 報告問題

如果您發現任何問題或有功能建議，請在 [Issues](https://github.com/yourusername/ingresafe/issues) 頁面提出。

## 免責聲明

⚠️ **重要提醒**

IngreSafe 提供的分析結果僅供參考，不能取代專業醫療建議。使用本應用程式前，請注意：

- 本應用使用 AI 技術分析，可能存在誤判
- 分析結果不構成醫療建議
- 孕期或哺乳期的飲食決策應諮詢專業醫師或營養師
- 對特定成分有疑慮時，請務必尋求專業醫療協助

## 授權條款

本專案採用 MIT License 授權 - 詳見 [LICENSE](LICENSE) 檔案

---

<p align="center">
  Made with ❤️ for mothers and babies
</p>

# IngreSafe v2.0 — Figma 設計稿實作

## 新版介面特色

基於 Figma 設計稿重新打造的現代化介面，提供完整的孕期飲食安全分析體驗。

### 主要功能

1. **語言選擇頁** (`LanguageSelectionScreen`)
   - 首次進入 APP 時顯示，選擇後不再出現
   - 6 種語言 Radio 選擇（繁中、英、日、韓、泰、越）
   - 「略過」選項自動偵測系統語系
   - hover/pressed 互動效果

2. **安全警告彈跳視窗** (`SafetyWarningDialog`)
   - 進入 APP 自動顯示，提醒使用注意事項
   - 支援「確認」與「不再顯示」兩種操作
   - 可從「關於我們」頁面再次開啟

3. **歷史記錄列表頁** (`ReportsScreen`)
   - 按年份和月份分組顯示飲食記錄
   - 風險等級標示（低風險、中風險、高風險、不確定）
   - 卡片設計帶進入動畫
   - 刪除確認機制（3 秒內再按確認）

4. **報告詳情頁** (`ReportDetailScreen`)
   - 多圖輪播（PageView + 圓點指示器）
   - Markdown 渲染分析內容
   - 參考文獻獨立 Card（綠色左邊框、可點擊連結）
   - 免責聲明

5. **上傳對話框** (`UploadDialog`)
   - 支援多張照片上傳與預覽
   - 標題和說明輸入，說明會注入 AI prompt
   - 多筆分析可並行（spinner 計數器）

6. **底部導航欄** (`BottomNav`)
   - 拍照 / 相簿 / 關於
   - hover/press 互動效果

7. **關於對話框** (`AppAboutDialog`)
   - 功能介紹、免責聲明、版本資訊
   - 「查看安全提醒」連結

### 設計系統

#### 顏色配置
| 用途 | 色碼 |
|------|------|
| 主色調 (Primary) | `#4B9B79` |
| 安全色 (Safe) | `#3B9B73` |
| 警告色 (Warning) | `#F5A623` |
| 危險色 (Danger) | `#D63333` |
| 背景色 | `#FAF7F5` |
| 卡片色 | `#FFFFFF` |
| 邊框色 | `#E5E0DC` |
| Muted 色 | `#F1EDEA` |
| 前景色 | `#1F2E28` |
| 次要前景色 | `#667269` |

#### 字體
- **Nunito** (Google Fonts) — 全站主字體
- **Noto Sans JP/KR** — 日文、韓文 fallback

### i18n 國際化

支援 6 種語言：English / 繁體中文 / 日本語 / 한국어 / ไทย / Tiếng Việt

#### 架構
- `lib/constants/app_strings.dart` — 集中管理所有翻譯文字
- 格式：`Map<String, Map<String, String>>`，以 langCode 為 key
- 各 Widget 透過 `_t` getter 取得當前語言文字
- langCode 流程：`SharedPreferences` → `_selectedLanguage` → `_langCodeMap` → `_langCode`

#### 已翻譯模組
- `reportDetailTexts` — 報告詳情頁
- `reportsScreenTexts` — 報告列表頁
- `uploadDialogTexts` — 上傳對話框
- `aboutDialogTexts` — 關於對話框
- `bottomNavTexts` — 底部導航欄
- `reportCardTexts` — 報告卡片
- `riskLevelLabels` — 風險等級標籤
- `safetyWarningTexts` — 安全警告

### 檔案結構

```
lib/
├── constants/
│   └── app_strings.dart              # 多語言文字常數
├── models/
│   └── report_model.dart             # 報告資料模型 (imageUrls, RiskLevel)
├── theme/
│   └── app_theme.dart                # 主題、顏色、RiskLevelConfig
├── services/
│   ├── report_storage_service.dart   # 本地儲存服務
│   └── ai/
│       └── chat_service.dart         # Perplexity API 整合
├── widgets/
│   ├── app_icons.dart                # SVG icon 統一管理
│   ├── report_card.dart              # 報告卡片
│   ├── animated_report_card.dart     # 卡片進入動畫
│   ├── bottom_nav.dart               # 底部導航欄
│   ├── upload_dialog.dart            # 上傳對話框
│   ├── about_dialog.dart             # 關於對話框
│   ├── safety_warning_dialog.dart    # 安全警告彈跳視窗
│   └── language_switcher.dart        # 語言切換下拉選單
├── screens/
│   ├── startup_screen.dart           # 啟動路由判斷
│   ├── language_selection_screen.dart # 語言選擇頁
│   ├── reports_screen.dart           # 報告列表頁
│   └── report_detail_screen.dart     # 報告詳情頁
├── providers/
│   └── theme_provider.dart           # 主題狀態管理
└── main.dart                         # 應用程式入口

assets/images/icons/
├── safe.svg / warning.svg / danger.svg   # 風險等級
├── plus.svg / trash.svg                  # 操作
├── arrow-right.svg / arrow-left.svg      # 箭頭
├── _-left.svg / _-right.svg             # 返回箭頭
├── camera.svg / photo_libs.svg / info.svg # 底部導航
├── refs.svg                              # 參考文獻
├── shield.svg / toxic.svg / scan-eye.svg # 安全警告
├── eye-off.svg                           # 不可見物質
└── globe.svg                             # 語言選擇
```

### 啟動流程

```
main.dart → StartupScreen
  ├── (首次) → LanguageSelectionScreen → /reports
  └── (非首次) → /reports
                    └── SafetyWarningDialog (如未永久關閉)
```

### 設計參考

- **Figma 設計稿**: https://www.figma.com/design/jodDOPkGgVzMe4GJzoAe9w/mama-diet-buddy
- **React 參考**: `Design/ReDesign/mama-diet-buddy/src/components/`

### 技術細節

- **Flutter SDK**: >=3.0.0
- **Material Design 3**
- **狀態管理**: StatefulWidget + Provider (ThemeProvider)
- **圖片選擇**: image_picker
- **AI 服務**: Perplexity API (sonar 模型)
- **Markdown**: flutter_markdown
- **SVG**: flutter_svg
- **字體**: google_fonts (Nunito)

---

**開發日期**: 2026-03-07 ~ 2026-03-10
**設計來源**: Figma mama-diet-buddy 專案

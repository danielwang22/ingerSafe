# IngreSafe 更新日誌

**最後更新**: 2026-03-22

---

## v2.2 — 報告管理增強 (2026-03-22)

### 新增功能

#### 1. Report.userNote 欄位
- `Report` 模型新增 `userNote: String?` 欄位，儲存使用者在上傳對話框輸入的說明
- `userNote` 注入 AI Prompt，供重新分析時使用
- Hive `ReportAdapter` 新增 field index 7 寫入/讀取（向下相容舊資料）
- `copyWith` 改用 sentinel 模式（同 `userNote` 與 `fullAnalysis`），允許明確傳入 `null` 清除欄位

#### 2. 重新分析（Re-analyze）功能
- `UploadDialog` 新增 `initialTitle` / `initialNote` 選填參數，支援預填欄位
- `ReportCard` footer 新增編輯圖示按鈕（`AppIcons.reanalyze()`，使用 `edit.svg`）
  - 點擊開啟 `UploadDialog` 並帶入既有標題、說明、圖片
  - 提交後更新同一筆報告（保留原 ID），觸發 AI 重新分析
- `ReportDetailScreen` AppBar 右側新增重新分析圖示按鈕
  - 重新分析時立即將 `summary` 設為「分析中」、清除 `fullAnalysis`，UI 還原到分析中狀態（隱藏舊參考文獻）

#### 3. ReportDetailScreen 刪除功能
- AppBar 右側新增垃圾桶圖示按鈕
- 採用與 `ReportCard` 相同的「兩次點擊 + OverlayEntry toast」確認機制
  - 第一次點擊：icon 變紅，頂部顯示確認提示，3 秒後自動復原
  - 3 秒內再次點擊：執行刪除，自動返回列表頁

### 修正

- 修正重新分析會在列表中新增重複卡片的問題（移除 `insertEphemeral` 的誤用）
- `copyWith(fullAnalysis: null)` 現在能正確清除欄位（sentinel pattern）

### 修改檔案總覽

| 檔案 | 變更類型 | 說明 |
|------|---------|------|
| `lib/models/report_model.dart` | 修改 | 新增 `userNote`；`copyWith` sentinel for `fullAnalysis` & `userNote` |
| `lib/models/hive_adapters.dart` | 修改 | `ReportAdapter` 新增 field 7（`userNote`），writeByte 7→8 |
| `lib/widgets/app_icons.dart` | 修改 | 新增 `reanalyze()` 使用 `edit.svg` |
| `lib/widgets/upload_dialog.dart` | 修改 | 新增 `initialTitle` / `initialNote` 預填參數 |
| `lib/widgets/report_card.dart` | 修改 | 新增 `onReanalyze` callback + 編輯圖示按鈕（footer） |
| `lib/widgets/animated_report_card.dart` | 修改 | 透傳 `onReanalyze` 到 `ReportCard` |
| `lib/screens/reports_screen.dart` | 修改 | 建立報告時儲存 `userNote`；新增 `_showReanalyzeDialog()` |
| `lib/screens/report_detail_screen.dart` | 修改 | 轉換為 `ConsumerStatefulWidget`；新增刪除 & 重新分析按鈕 |
| `lib/constants/app_strings.dart` | 修改 | 新增 `reanalyze`、`delete`、`cancel`、`confirmDeleteMessage`、`analyzing`、`analysisFailed` |
| `assets/images/icons/edit.svg` | 新增 | 重新分析圖示 |
| `.gitignore` | 修改 | 退追蹤 `.mcp.json` |

---

## v2.1 — i18n、安全警告、語言選擇頁 (2026-03-10)

### 新增功能

#### 1. 安全警告彈跳視窗 (`lib/widgets/safety_warning_dialog.dart`)
- 進入 APP 時自動顯示，提醒使用者兩大注意事項：
  - 請完整展示所有食物（避免覆蓋堆疊）
  - AI 無法識別有毒物質（需使用者自行確認）
- 「確認」按鈕：關閉視窗，下次開啟仍顯示
- 「不再顯示」按鈕：透過 SharedPreferences 永久關閉
- 「關於我們」對話框新增「查看安全提醒」連結可再次開啟

#### 2. 語言選擇頁面 (`lib/screens/language_selection_screen.dart`)
- 首次進入 APP 時顯示，選擇後不再出現
- 支援 6 種語言 Radio 選擇（繁中、英、日、韓、泰、越）
- 「略過（自動偵測語系）」依系統語系自動判斷
- 按 Figma 設計稿實作：Logo、國旗 emoji、Radio 列表、hover/pressed 互動效果

#### 3. 全面 i18n 國際化（6 種語言）
- 將 8 個檔案中約 40 處硬編碼中文字替換為 `AppStrings` 多語言查詢
- 涵蓋：report_detail、reports、upload_dialog、about_dialog、bottom_nav、report_card
- 新增 `safetyWarningTexts` 多語言文字常數
- langCode 流程：`_selectedLanguage` → `_langCodeMap` → `_langCode` → 傳入各 Widget

#### 4. 多圖輪播 (`lib/screens/report_detail_screen.dart`)
- 單圖直接顯示，多圖使用 PageView 輪播
- 動態圓點指示器（綠色膠囊 active、灰色圓形 inactive）

### 功能改進

#### 5. API 使用者描述注入
- `_buildUserPrompt` 將使用者補充說明注入 API user message
- 新增 `userNotePrefix` 多語言前綴

#### 6. 多筆分析並行修正
- `_isAnalyzing` bool 改為 `_analyzingCount` 計數器
- 多筆分析同時進行時 spinner 不會提前消失

#### 7. 啟動路由更新 (`lib/screens/startup_screen.dart`)
- 檢查 `language_selected` 狀態決定導向
- 首次：語言選擇頁 → 之後：報告列表頁

### 新增 SVG 圖示
- `shield.svg` — 安全警告 header
- `toxic.svg` — 有毒物質警告 (Font Awesome)
- `scan-eye.svg` — 展示食物警告
- `eye-off.svg` — 不可見物質
- `globe.svg` — 語言選擇 section header

---

## v2.0 — Figma 設計稿重構 (2026-03-07 ~ 2026-03-10)

### 新增功能

#### 1. 關於對話框 (`lib/widgets/about_dialog.dart`)
- 新增 `AppAboutDialog` Widget，依照 Figma 設計稿實作
- 使用專案 SVG icon（safe / refs / warning）取代 Material Icons
- 提供靜態 `show(BuildContext context)` 方法方便呼叫

#### 2. 語言切換器 (`lib/widgets/language_switcher.dart`)
- 新增自訂 Overlay dropdown，使用 `CompositedTransformTarget/Follower` 定位
- 支援 6 種語言切換（英文、繁體中文、日文、韓文、泰文、越南文）
- 選中項目以綠色粗體標示，dropdown 右對齊按鈕、底部間距 4px

#### 3. AI 風險等級解析
- AI prompt 新增 `[RISK_LEVEL:low/medium/high]` 標籤指令
- 三層解析機制：正則標籤 → 關鍵字推斷 → 回傳「不確定」
- 新增 `RiskLevel.unknown` 列舉值，灰色標示

#### 4. 多圖上傳支援
- `AIService.processImageWithAI` 支援 `List<File>` 多張圖片
- 所有圖片編碼為 base64 送往 Perplexity API（sonar 模型）

### 功能改進

#### 5. 底部導航欄互動效果 (`lib/widgets/bottom_nav.dart`)
- `_NavButton` 改為 StatefulWidget，支援 hover / press 狀態
- Hover：套用 primary 樣式（綠色背景 + 白色 icon + 陰影）
- Press：`AnimatedScale` 縮放至 0.95

#### 6. 報告詳情頁 Markdown 渲染 (`lib/screens/report_detail_screen.dart`)
- 分析內文使用 `MarkdownBody` 渲染，支援粗體、列表、超連結
- 以 `---` 分隔符拆分「分析內文」與「參考文獻」
- 參考文獻獨立 Card，綠色左邊框樣式

#### 7. Perplexity API 整合 (`lib/services/ai/chat_service.dart`)
- 回傳結果包含 `riskLevel` 欄位
- `PerplexityFormatter` 處理引用標記轉超連結
- 風險標籤自動從顯示內容中移除

---

## 修改檔案總覽

| 檔案 | 變更類型 | 說明 |
|------|---------|------|
| `lib/widgets/safety_warning_dialog.dart` | 新增 | 安全警告彈跳視窗 |
| `lib/widgets/about_dialog.dart` | 修改 | 新增安全提醒連結、i18n |
| `lib/widgets/language_switcher.dart` | 新增 | 語言切換下拉選單 |
| `lib/widgets/bottom_nav.dart` | 修改 | hover/press 互動效果、i18n |
| `lib/widgets/report_card.dart` | 修改 | i18n、多圖縮圖 |
| `lib/widgets/animated_report_card.dart` | 修改 | 傳遞 langCode |
| `lib/widgets/upload_dialog.dart` | 修改 | i18n |
| `lib/widgets/app_icons.dart` | 修改 | 新增 shield/toxic/scanEye/eyeOff/globe icon |
| `lib/models/report_model.dart` | 修改 | imageUrl → imageUrls、RiskLevel.unknown |
| `lib/theme/app_theme.dart` | 修改 | RiskLevelConfig.unknown |
| `lib/constants/app_strings.dart` | 修改 | 新增 7 組 i18n Map |
| `lib/services/ai/chat_service.dart` | 修改 | 多圖支援、userPrompt 注入、debugPrint |
| `lib/screens/reports_screen.dart` | 修改 | i18n、analyzingCount、安全警告觸發 |
| `lib/screens/report_detail_screen.dart` | 重寫 | 多圖輪播、i18n、SVG back icon |
| `lib/screens/language_selection_screen.dart` | 重寫 | Figma 設計稿語言選擇頁 |
| `lib/screens/startup_screen.dart` | 修改 | 首次啟動路由判斷 |

---

## 設計參考

- **Figma 設計稿**: https://www.figma.com/design/jodDOPkGgVzMe4GJzoAe9w/mama-diet-buddy

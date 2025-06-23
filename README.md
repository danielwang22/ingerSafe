# Ingresafe - Flutter 版本

這是一個功能強大的照片文字識別和 AI 分析應用程式，使用 Flutter 開發，能夠從圖片中提取文字並進行智能分析。

## 主要功能 ✨

-   拍照或從相簿選擇圖片
-   使用 Google ML Kit 進行高精度 OCR 文字識別
-   整合 OpenAI GPT-4 進行智能文字分析
-   支援深色/淺色主題切換
-   完整的歷史記錄功能

## Xcode 環境

-   Xcode iOS 18.0 或更高版本

## Android Studio 環境

-   Android SDK Platform 35.0.0
-   Android SDK Platform-Tools 35.0.0
-   Android SDK Build-Tools 34.0.0
-   Android SDK Command-line Tools (latest)

## 系統需求

-   Flutter SDK 3.0 或更高版本
-   iOS 11.0+ / Android 5.0+
-   OpenAI API 金鑰
-   DeepSeek API 金鑰

## 安裝步驟

1. 複製專案：

    ```bash
    git clone https://your-repository-url.git
    cd photo_text_ai
    ```

2. 設定環境變數：

    - 在專案根目錄建立 `.env` 檔案
    - 加入以下內容：
        ```
        OPENAI_API_KEY=your_api_key_here
        ```

3. 安裝依賴：

    ```bash
    flutter pub get
    ```

4. 執行應用：
    ```bash
    flutter run
    ```

## 使用方式

1. **拍攝/選擇照片**

    - 點擊相機按鈕拍攝新照片
    - 或點擊相簿按鈕選擇已有照片

2. **文字識別**

    - 選擇照片後會自動進行 OCR 識別
    - 識別完成後會顯示提取出的文字

3. **AI 分析**
    - 點擊分析按鈕開始 AI 分析
    - 等待分析結果顯示

## 技術架構

-   **前端框架**：Flutter
-   **狀態管理**：flutter_hooks
-   **OCR 引擎**：Google ML Kit
-   **AI 模型**：OpenAI GPT-4
-   **本地儲存**：shared_preferences

### 使用的套件

-   `flutter_hooks`：React 風格的狀態管理
-   `google_ml_kit`：文字識別功能
-   `image_picker`：照片選擇和拍攝
-   `http`：API 請求處理
-   `shared_preferences`：本地資料儲存
-   `flutter_dotenv`：環境變數管理
-   `provider`：主題管理

## 貢獻指南

歡迎提交 Pull Request 或建立 Issue 來改進這個專案。請確保：

1. 程式碼符合專案的程式碼風格
2. 新功能包含適當的測試
3. 更新相關文件

## 授權條款

本專案採用 MIT 授權條款 - 詳見 [LICENSE](LICENSE) 檔案

# IngreSafe - Technical Documentation

> This document provides comprehensive technical guidance for working with the IngreSafe codebase.

## Overview

IngreSafe is a Flutter-based mobile application that leverages AI to analyze product ingredient safety for pregnant and breastfeeding women. The app combines OCR technology with Perplexity AI to provide real-time risk assessments of product ingredients.

### Core Capabilities
- **AI-Powered Analysis**: Perplexity API integration for ingredient risk classification
- **Multi-Image OCR**: Google ML Kit text recognition from product photos
- **Risk Classification**: Four-tier system (Safe, Warning, Danger, Unknown)
- **Multi-Language Support**: 6 languages with full localization
- **Offline Storage**: Local report persistence with Hive database
- **In-App Web Browsing**: Integrated WebView for external references

## Development Workflow

### Essential Commands

**Development**
```bash
flutter run                          # Launch in debug mode
flutter run -d <device_id>          # Target specific device
flutter pub get                      # Install dependencies
flutter analyze                      # Run static analysis
```

**Testing & Quality**
```bash
flutter test                         # Run all tests
flutter test test/widget_test.dart  # Run specific test
flutter analyze                      # Lint and static analysis
```

**Build & Deploy**
```bash
flutter build apk --release         # Android production build
flutter build ipa --release         # iOS production build
flutter clean                       # Clean build artifacts
```

**Firebase Configuration**
```bash
flutterfire configure               # Update Firebase options
```

## Environment Configuration

### Required Setup

Create a `.env` file in the project root:
```env
PERPLEXITY_API_KEY=your_api_key_here
```

**Important Notes:**
- This file is loaded via `flutter_dotenv` at app startup
- The `.env` file is gitignored for security
- Firebase configuration is auto-generated in `firebase_options.dart`
- Never commit API keys to version control

## Architecture & Design Patterns

### State Management Strategy

The application uses **Riverpod 2.x** as the primary state management solution, combined with Flutter Hooks for widget-local state:

| Pattern | Scope | Use Case |
|---------|-------|----------|
| **Riverpod `AsyncNotifier`** | Global | Reports list, Theme, Language |
| **Riverpod `StateProvider`** | Global | Analyzing count badge |
| **Riverpod `FutureProvider`** | Global | Device hex ID (cached) |
| **Riverpod `Provider<Interface>`** | DI | Service layer injection |
| **Flutter Hooks** | Widget-local | `useState`, `useEffect` in hook-based screens |

**Entry Point:** `main.dart` wraps the app in `ProviderScope`. `MyApp` is a `ConsumerStatefulWidget` that watches `themeNotifierProvider`.

**Rationale:** Riverpod decouples UI from concrete service implementations, enables easy mock injection for testing, and eliminates `setState` for shared state.

### Riverpod Providers Reference

**`lib/providers/service_providers.dart`** — Service injection layer

| Provider | Type | Returns | Concrete Impl |
|----------|------|---------|---------------|
| `reportStorageProvider` | `Provider<IReportStorage>` | Report CRUD | `ReportStorageService.instance` |
| `aiServiceProvider` | `Provider<IAIService>` | AI analysis | `AIService.instance` |
| `usageServiceProvider` | `Provider<IUsageService>` | Usage tracking | `ClickService.instance` |
| `deviceIdServiceProvider` | `Provider<IDeviceIdService>` | Device hex ID | `DeviceIdService.instance` |
| `tutorialServiceProvider` | `Provider<ITutorialService>` | Tutorial state | `TutorialService.instance` |
| `historyStorageProvider` | `Provider<IHistoryStorage>` | History log | `HistoryStorageService.instance` |

For tests, override any of these with `ProviderScope(overrides: [aiServiceProvider.overrideWithValue(MockAI())])`.

**`lib/providers/report_providers.dart`**

| Provider | Type | Purpose |
|----------|------|---------|
| `reportsNotifierProvider` | `AsyncNotifierProvider<ReportsNotifier, List<Report>>` | Full report list lifecycle |
| `analyzingCountProvider` | `StateProvider<int>` | Number of in-progress AI analyses |
| `deviceHexProvider` | `FutureProvider<String>` | Cached device identifier |

`ReportsNotifier` methods:
- `addReport(report)` — persist + update state
- `updateReport(report)` — optimistic update + persist
- `deleteReport(id)` — optimistic remove + persist
- `insertEphemeral(report)` — memory-only (analyzing placeholder, tutorial sample)
- `removeEphemeral(id)` — memory-only remove

**`lib/providers/theme_provider.dart`** — `AsyncNotifier<ThemeMode>`  
Loads from `SharedPreferences` on `build()`. Defaults to `ThemeMode.system` if no preference saved. `setThemeMode()` updates state immediately then persists.

**`lib/providers/language_provider.dart`** — `AsyncNotifier<String>`  
Loads `selected_language` from `SharedPreferences`. `setLanguage()` updates state immediately then persists.

### Navigation Architecture

**Route Flow:**
```
StartupScreen → LanguageSelectionScreen → ReportsScreen → ReportDetailScreen
     ↓                    ↓                      ↓
  (Splash)         (First Launch)         (Main Interface)
```

**Route Configuration:**
- All routes defined as named routes in `main.dart`
- Routes: `/` (startup), `/select-language`, `/reports`
- `StartupScreen` performs conditional routing based on `language_selected` preference
- Tutorial system activates within `ReportsScreen` after safety warning dismissal

### Service Layer Architecture

**Location:** `lib/services/`

All services follow the **Singleton + Abstract Interface** pattern:
- Each service exposes a `static final instance` singleton
- Each implements a corresponding interface from `lib/services/interfaces/`
- Riverpod providers in `service_providers.dart` wrap the singleton behind the interface type

**Abstract Interfaces** (`lib/services/interfaces/`)

| Interface | Implemented By | Key Contracts |
|-----------|---------------|---------------|
| `IAIService` | `AIService` | `processImageWithAI(images, langCode)` |
| `IReportStorage` | `ReportStorageService` | `loadReports()`, `addReport()`, `updateReport()`, `deleteReport()`, `resolveImagePath()` |
| `IHistoryStorage` | `HistoryStorageService` | `loadHistory()`, `saveHistory()` |
| `IUsageService` | `ClickService` | `recordClick(deviceHex)` |
| `ITutorialService` | `TutorialService` | `shouldShowTutorial()`, `markCompleted()`, `reset()`, `setShowcaseFinishCallback()` |
| `IDeviceIdService` | `DeviceIdService` | `getOrCreateHex()` |

**Concrete Services**

| Service | Primary Responsibility | Persistence Layer | Key Methods |
|---------|----------------------|-------------------|-------------|
| `AIService` | Perplexity API integration, risk parsing | In-memory | `processImageWithAI()` |
| `ReportStorageService` | Report CRUD operations | Hive (`reports` box) | `loadReports()`, `addReport()`, `deleteReport()`, `resolveImagePath()` |
| `DeviceIdService` (`text_storage_service.dart`) | Device identifier management | File system | `getOrCreateHex()` |
| `ClickService` (`usage_service.dart`) | Anonymous usage analytics | Firebase Firestore | `recordClick()` |
| `TutorialService` | Tutorial state coordination | SharedPreferences | `markCompleted()`, `reset()` |
| `HistoryStorageService` | History log persistence | Local JSON file | `loadHistory()`, `saveHistory()` |

**Design Principles:**
- Single Responsibility: Each service handles one domain
- Singleton Pattern: `static final instance = Service._()` private constructor
- Interface Segregation: UI/providers depend on interfaces, never concrete classes
- Testability: Swap any service via Riverpod `overrides` without touching business code

### AI Analysis Flow

**New Report:**
1. User captures/picks image(s) via `image_picker`
2. `UploadDialog` collects title + optional description (`userNote`)
3. `insertEphemeral(report)` shows placeholder card immediately
4. OCR text extraction via `google_mlkit_text_recognition`
5. Images + `userNote` sent to Perplexity API (`lib/services/ai/chat_service.dart`)
6. AI response parsed for `RiskLevel`; report updated via `updateReport()`
7. `removeEphemeral()` + final state reflected in UI

**Re-analyze (Update) Existing Report:**
1. User taps reanalyze icon on `ReportCard` footer or `ReportDetailScreen` AppBar
2. `UploadDialog` opens pre-filled with `report.title`, `report.userNote`, existing images
3. `updateReport(updatingReport)` called with `summary = t['analyzing']`, `fullAnalysis = null` — UI immediately shows analyzing state
4. AI re-processes; `updateReport()` called again with new result
5. `ReportDetailScreen` reflects result via local `setState`; list reflects via Riverpod

### Data Model
`Report` in `lib/models/report_model.dart` supports multiple images per report and has backward compatibility for old single-image data.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | UUID primary key |
| `title` | `String` | Report title |
| `summary` | `String` | Short summary / analyzing placeholder |
| `riskLevel` | `RiskLevel` | Enum: safe / warning / danger / unknown |
| `imageUrls` | `List<String>` | Relative file paths |
| `date` | `DateTime` | Creation/update timestamp |
| `fullAnalysis` | `String?` | Full Markdown analysis from AI |
| `userNote` | `String?` | User-provided description, injected into AI prompt on (re-)analysis |

**`copyWith` Sentinel Pattern:** Both `fullAnalysis` and `userNote` use an `_sentinel` object as default so callers can explicitly pass `null` to clear the field:
```dart
Object? fullAnalysis = _sentinel,  // passing null clears the field
Object? userNote = _sentinel,      // passing null clears the field
```

### Data Persistence Strategy

#### Report Storage (Hive NoSQL)

**Configuration:**
- **Box Name:** `'reports'`
- **Key:** `report.id` (String, UUID)
- **Value:** `Report` object serialized via `ReportAdapter`

**Type Adapters:**
| Adapter | Type ID | Purpose |
|---------|---------|---------|
| `RiskLevelAdapter` | 0 | Enum serialization |
| `ReportAdapter` | 1 | Report model serialization (8 fields) |

**`ReportAdapter` field index map:**
| Index | Field |
|-------|-------|
| 0 | `id` |
| 1 | `title` |
| 2 | `summary` |
| 3 | `riskLevel` |
| 4 | `imageUrls` |
| 5 | `date` (millisecondsSinceEpoch) |
| 6 | `fullAnalysis` |
| 7 | `userNote` ← added in v2.2 |

**Critical Constraints:**
- ⚠️ **Type IDs are immutable** - Never modify after production deployment
- ⚠️ **Field indices are append-only** - Always add new fields at the next index; never reorder
- Initialization sequence: `Hive.initFlutter()` → `ReportStorageService.init()`
- Automatic migration from legacy SharedPreferences on first launch

**Migration Flag:** `hive_migrated_v1` in SharedPreferences

#### Image Storage (File System)

**Storage Strategy:**
- **Location:** `getApplicationDocumentsDirectory()/report_images/`
- **Path Format:** Relative paths (`report_images/filename.jpg`)
- **Rationale:** Survives iOS app directory UUID changes

**Implementation Details:**
```dart
// Path resolution at runtime
ReportStorageService.resolveImagePath(storedPath)
```

**Lifecycle Management:**
- Images cached in `_docsPath` during `init()`
- Automatic cleanup on report deletion
- Cascade delete on `clearAllReports()`

#### Application Settings (SharedPreferences)

| Key | Purpose | Type |
|-----|---------|------|
| `language_selected` | Language preference flag | Boolean |
| `selected_language` | Active language code | String |
| `theme_mode` | Theme preference (`ThemeMode.toString()`) | String |
| `tutorial_completed` | Tutorial completion state | Boolean |
| `hasShownTutorial` | Home screen tutorial flag | Boolean |
| `safety_warning_shown` | Warning dismissal state | Boolean |
| `hive_migrated_v1` | Migration completion flag | Boolean |

### Internationalization
- 6 languages: English, Traditional Chinese, Japanese, Korean, Thai, Vietnamese
- All strings in `lib/constants/app_strings.dart` as `Map<String, Map<String, String>>`
- Language preference stored in `SharedPreferences`
- Date formatting uses `intl` package with `zh_TW` locale initialized at startup

### Theme System
- `AppTheme` in `lib/theme/app_theme.dart` defines colors, text styles, and `RiskLevelConfig` per risk level
- Primary color: `#4B9B79` (green), Warning: `#F5A623`, Danger: `#D63333`
- Typography: Google Fonts (Nunito)
- Both `AppTheme.lightTheme` and `AppTheme.darkTheme` are defined; `MyApp` passes both to `MaterialApp`

**RiskLevelConfig Dark Variants:** `RiskLevelConfig.safeDark`, `.warningDark`, `.dangerDark`, `.unknownDark`  
Dark variants use solid background + white text/icon (vs. transparent tint in light mode).  
Usage pattern in widgets:
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
final config = isDark ? RiskLevelConfig.safeDark : RiskLevelConfig.safe;
```

### Version
- Version managed in `pubspec.yaml` (`version: x.y.z+build`)
- Displayed in About Dialog via `package_info_plus` (`PackageInfo.fromPlatform()`)
- `AppAboutDialog._cachedVersion` caches the result after first load

### Device Identity
A unique hex ID is generated per device, stored as a text file, and used as the Firebase Firestore document key for anonymous usage tracking.

### External Link Handling

**Implementation:** `flutter_inappwebview` package via `WebViewService`

**Integration Points:**
- **ReportDetailScreen**: Markdown content links and reference citations
- **AppAboutDialog**: Buy Me a Coffee link (Android platform only)

**WebViewScreen Features:**
- Full-screen in-app browser with custom navigation bar
- Real-time loading progress indicator
- Comprehensive error handling with retry capability
- SSL certificate auto-trust for seamless browsing
- Support for JavaScript, DOM Storage, and modern web features

**Platform Configuration:**
- **iOS**: `NSAppTransportSecurity` enabled for external content
- **Android**: `usesCleartextTraffic` and `ACCESS_NETWORK_STATE` permissions

**Technical Details:**
```dart
WebViewService.openUrl(context, url, title: 'Optional Title');
```
This abstraction ensures consistent behavior across all external link interactions.

## Tutorial & Onboarding System

### Architecture Overview

**Implementation:** Multi-phase onboarding flow using `showcaseview` package  
**Coordinator:** `TutorialService` (Singleton pattern)

### State Management

| Persistence Key | Owner Component | Lifecycle Scope |
|----------------|-----------------|-----------------|
| `tutorial_completed` | `TutorialService` | Reports screen tutorial |
| `hasShownTutorial` | `HomeScreen` | Home screen showcase |

**Critical API:**
```dart
TutorialService.reset()  // Clears ALL tutorial state
```
⚠️ **Always use `reset()` for complete tutorial reset** - Manual key clearing may cause inconsistent state.

### Launch Sequence (ReportsScreen)
1. Load language → load reports
2. `_showSafetyWarning()` — waits for dialog to be **dismissed** before continuing
3. `_checkAndStartTutorial()` — only runs after safety warning is gone
4. Phase 1: ShowCase camera + gallery buttons → on finish → show `UploadDialog(isTutorial: true)`
5. Phase 2: ShowCase report card → on finish → mark tutorial completed + remove sample report

### isTutorial Mode (UploadDialog)
- Close button hidden
- `AbsorbPointer` blocks all interactions
- Tapping anywhere dismisses dialog → triggers phase 2

### Showcase Styling (all Showcase widgets)
```dart
tooltipPadding: EdgeInsets.all(20)
titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
descTextStyle: TextStyle(fontSize: 16)
```

### AnimatedReportCard Animation
- Skip animation when `showcaseKey != null` (tutorial sample card): `_controller.value = 1.0`
- Normal cards animate in with `300 + (index * 50)ms` staggered fade+slide

## Platform-Specific Implementations

### Android vs iOS Differentiation

**About Dialog Variations:**
| Platform | Description Content | Footer Actions |
|----------|-------------------|----------------|
| Android | `descriptionAndroid` (includes donation mention) | ☕ Buy Me a Coffee button |
| iOS | `description` (standard text) | Version info only |

**Configuration Source:** `app_strings.dart` → `aboutDialogTexts[lang]['descriptionAndroid']`

**Donation Link:** `https://buymeacoffee.com/ingresafe` (Android exclusive)

## UI Component Patterns

### Standard Dialog Architecture

**Layout Structure:**
```
Container (maxWidth: 382px, rounded corners, elevation shadow)
  └─ Column
      ├─ Flexible → SingleChildScrollView  // Scrollable content area
      └─ Fixed Footer (top border)         // Action buttons/links
```

**Implementation Examples:**

| Dialog | Content Strategy | Footer Configuration |
|--------|-----------------|---------------------|
| `SafetyWarningDialog` | Scrollable warning list | 2 buttons (`IntrinsicHeight` + `crossAxisAlignment: stretch`) |
| `AboutDialog` | Header + features + disclaimer | Safety link + Buy Me a Coffee (Android) + version |
| `UploadDialog` | Standard scroll | No footer in tutorial mode |

**Design Consistency:** All dialogs maintain uniform spacing, typography, and interaction patterns.

## Assets
- Logo: `assets/icon/logo.png` (used in `StartupScreen` and as app icon)
- Icons: `assets/images/icons/` (SVG, accessed via `AppIcons`)
- Registered in `pubspec.yaml` under `flutter.assets`

**`AppIcons` notable methods:**
| Method | SVG file | Usage |
|--------|----------|-------|
| `trash()` | `trash.svg` | Delete action |
| `reanalyze()` | `edit.svg` | Re-analyze / update report |
| `cross()` | `cross.svg` | Close / remove |
| `arrow2Left()` | `_-left.svg` | Back navigation |

## Key Widget Notes

### `UploadDialog`
Accepts optional `initialTitle` and `initialNote` to pre-fill fields for the re-analyze flow:
```dart
UploadDialog(
  initialImages: existingImages,
  initialTitle: report.title,    // pre-fills title field
  initialNote: report.userNote,  // pre-fills description field
  onSubmit: (title, description, images) async { ... },
)
```

### `ReportDetailScreen`
`ConsumerStatefulWidget` with local `_report` state for optimistic UI updates.  
AppBar actions (right to left): **reanalyze icon** → **trash icon**  
- Trash uses same two-tap + `OverlayEntry` toast pattern as `ReportCard`  
- On re-analyze: clears `fullAnalysis = null` so `_splitContent()` falls back to summary text, hiding stale references until AI completes

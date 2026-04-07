import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'interfaces/i_tutorial_service.dart';

/// Singleton that coordinates the multi-phase onboarding tutorial.
class TutorialService implements ITutorialService {
  static final TutorialService instance = TutorialService._();
  TutorialService._();

  // Called by ShowCaseWidget.onFinish in main.dart
  VoidCallback? _onShowcaseFinish;

  @override
  void setShowcaseFinishCallback(VoidCallback cb) {
    _onShowcaseFinish = cb;
  }

  @override
  void handleShowcaseFinish() {
    final cb = _onShowcaseFinish;
    _onShowcaseFinish = null;
    cb?.call();
  }

  @override
  Future<bool> shouldShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('tutorial_completed') ?? false);
  }

  @override
  Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_completed', true);
  }

  @override
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tutorial_completed');
    await prefs.remove('hasShownTutorial');
  }
}

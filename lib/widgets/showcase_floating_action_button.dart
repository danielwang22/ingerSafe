import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseFloatingActionButton extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String description;
  final String heroTag;
  final VoidCallback? onPressed;
  final String tooltip;
  final IconData icon;

  const ShowcaseFloatingActionButton({
    super.key,
    required this.showcaseKey,
    required this.description,
    required this.heroTag,
    required this.onPressed,
    required this.tooltip,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      description: description,
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onPressed,
        tooltip: tooltip,
        child: Icon(icon),
      ),
    );
  }
}

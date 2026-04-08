import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icons.dart';
import '../constants/app_strings.dart';

class UploadDialog extends StatefulWidget {
  final List<XFile> initialImages;
  final Function(String title, String description, List<XFile> images) onSubmit;
  final String langCode;
  final bool isTutorial;
  final String? initialTitle;
  final String? initialNote;

  const UploadDialog({
    super.key,
    required this.initialImages,
    required this.onSubmit,
    this.langCode = 'zh_Hant',
    this.isTutorial = false,
    this.initialTitle,
    this.initialNote,
  });

  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  Map<String, String> get _t =>
      AppStrings.uploadDialogTexts[widget.langCode] ??
      AppStrings.uploadDialogTexts['en']!;

  late List<XFile> _images;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  bool _isAddButtonHovered = false;
  bool _isAddButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialNote != null) {
      _descriptionController.text = widget.initialNote!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _addMoreImages() async {
    final List<XFile> newImages = await _picker.pickMultiImage();
    if (newImages.isNotEmpty) {
      setState(() {
        _images.addAll(newImages);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _handleSubmit() {
    final description = _descriptionController.text.trim();

    if (_images.isEmpty && description.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(_t['alertTitle']!,
              style: const TextStyle(
                  color: AppTheme.foregroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 28 / 18)),
          content: Text(_t['alertMessage']!,
              style: TextStyle(
                  color: AppTheme.foregroundColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.5)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.cardColor,
              ),
              child: Text(_t['alertConfirm']!,
                  style: const TextStyle(
                      color: AppTheme.cardColor,
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
      return;
    }

    if (_images.isEmpty) return;

    final title = _titleController.text.trim().isEmpty
        ? _t['defaultTitle']!
        : _titleController.text.trim();

    widget.onSubmit(title, description, _images);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? AppTheme.cardDarkColor : AppTheme.backgroundColor;
    final inputBg =
        isDark ? AppTheme.cardBackgroundDarkColor : AppTheme.backgroundColor;
    final titleColor = isDark ? AppTheme.cardColor : AppTheme.foregroundColor;
    final mutedColor =
        isDark ? AppTheme.mutedDarkColor : AppTheme.mutedForegroundColor;
    final hintColor = isDark
        ? AppTheme.textTertiaryColor
        : AppTheme.foregroundColor.withValues(alpha: 0.5);
    final addBtnBorderColor =
        isDark ? AppTheme.mutedDarkColor : AppTheme.borderColor;

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDark
            ? const BorderSide(color: AppTheme.borderDarkColor)
            : BorderSide.none,
      ),
      child: GestureDetector(
        onTap: widget.isTutorial ? () => Navigator.pop(context) : null,
        child: AbsorbPointer(
          absorbing: widget.isTutorial,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: (MediaQuery.of(context).size.width - 16).clamp(0, 520),
              maxHeight:
                  (MediaQuery.of(context).size.height - 80).clamp(0, 780),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tutorial hint banner
                    if (widget.isTutorial)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  AppTheme.primaryColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.school_outlined,
                                size: 18, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                (AppStrings.tutorialTexts[widget.langCode] ??
                                    AppStrings
                                        .tutorialTexts['en']!)['uploadHint']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme.primaryColor,
                                  height: 28 / 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // DialogHeader
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 32, bottom: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _t['dialogTitle']!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: titleColor,
                                      height: 28 / 18),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _t['dialogDescription']!,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: mutedColor,
                                      height: 20 / 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 24, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_t['foodPhotos']} (${_images.length})',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: titleColor,
                                height: 20 / 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: _images.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _images.length) {
                                  final isActive = _isAddButtonHovered ||
                                      _isAddButtonPressed;
                                  final activeColor = isActive
                                      ? AppTheme.primaryColor
                                          .withValues(alpha: 0.5)
                                      : isDark
                                          ? AppTheme.mutedDarkColor
                                          : AppTheme.mutedForegroundColor
                                              .withValues(alpha: 0.7);
                                  final borderColor = isActive
                                      ? AppTheme.primaryColor
                                          .withValues(alpha: 0.5)
                                      : addBtnBorderColor;

                                  return MouseRegion(
                                    onEnter: (_) => setState(
                                        () => _isAddButtonHovered = true),
                                    onExit: (_) => setState(
                                        () => _isAddButtonHovered = false),
                                    child: GestureDetector(
                                      onTapDown: (_) => setState(
                                          () => _isAddButtonPressed = true),
                                      onTapUp: (_) => setState(
                                          () => _isAddButtonPressed = false),
                                      onTapCancel: () => setState(
                                          () => _isAddButtonPressed = false),
                                      child: InkWell(
                                        onTap: _addMoreImages,
                                        borderRadius: BorderRadius.circular(12),
                                        hoverColor: Colors.transparent,
                                        splashColor: AppTheme.primaryColor
                                            .withValues(alpha: 0.05),
                                        highlightColor: AppTheme.primaryColor
                                            .withValues(alpha: 0.05),
                                        child: DottedBorder(
                                          color: borderColor,
                                          strokeWidth: 2,
                                          dashPattern: const [6, 3],
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(12),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppIcons.plus(
                                                  size: 12,
                                                  color: activeColor,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  _t['add']!,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: activeColor,
                                                      height: 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(_images[index].path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: InkWell(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: AppIcons.cross(
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _t['titleLabel']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: titleColor,
                                height: 20 / 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _titleController,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode),
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 20 / 16,
                                letterSpacing: 1.2,
                              ),
                              decoration: InputDecoration(
                                hintText: _t['titleHint'],
                                hintStyle: TextStyle(color: hintColor),
                                fillColor: inputBg,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _t['descriptionLabel']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: titleColor,
                                height: 20 / 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _descriptionController,
                              focusNode: _descriptionFocusNode,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _handleSubmit(),
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 20 / 16,
                                letterSpacing: 1.2,
                              ),
                              decoration: InputDecoration(
                                hintText: _t['descriptionHint'],
                                hintStyle: TextStyle(color: hintColor),
                                fillColor: inputBg,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                        height: 1,
                        color: isDark
                            ? AppTheme.borderDarkColor
                            : AppTheme.borderColor.withValues(alpha: 0.5)),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 16, bottom: 24),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppTheme.backgroundColor,
                                  foregroundColor: AppTheme.foregroundColor,
                                  side: const BorderSide(
                                      color: AppTheme.borderColor),
                                  elevation: 0,
                                  minimumSize: const Size(0, 46),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 20 / 16,
                                  ),
                                ),
                                child: Text(_t['cancel']!),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Opacity(
                                opacity: _images.isEmpty ? 0.5 : 1.0,
                                child: ElevatedButton(
                                  onPressed:
                                      _images.isEmpty ? null : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: AppTheme.cardColor,
                                    disabledBackgroundColor:
                                        AppTheme.primaryColor,
                                    disabledForegroundColor: AppTheme.cardColor,
                                    elevation: 0,
                                    minimumSize: const Size(0, 0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 13),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 20 / 16,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppIcons.photoLibs(
                                          size: 16, color: AppTheme.cardColor),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          _t['startAnalysis']!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (!widget.isTutorial)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: AppIcons.cross(
                            size: 30,
                            color: isDark
                                ? AppTheme.cardColor
                                : AppTheme.foregroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'showcase_floating_action_button.dart';
import 'about_us_dialog.dart';

class FloatingActionButtonsWidget extends StatelessWidget {
  final GlobalKey cameraKey;
  final GlobalKey galleryKey;
  final GlobalKey aboutUsKey;
  final Map<String, String> translations;
  final bool isProcessing;
  final Future<void> Function(XFile?) processImage;

  const FloatingActionButtonsWidget({
    super.key,
    required this.cameraKey,
    required this.galleryKey,
    required this.aboutUsKey,
    required this.translations,
    required this.isProcessing,
    required this.processImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShowcaseFloatingActionButton(
          showcaseKey: cameraKey,
          description: translations['cameraTip']!,
          heroTag: 'cameraBtn',
          onPressed: isProcessing
              ? null
              : () async {
                  try {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    await processImage(image);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(translations['cameraError']!),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
          tooltip: translations['takePhoto']!,
          icon: Icons.camera_alt,
        ),
        const SizedBox(width: 16),
        ShowcaseFloatingActionButton(
          showcaseKey: galleryKey,
          description: translations['galleryTip']!,
          heroTag: 'galleryBtn',
          onPressed: isProcessing
              ? null
              : () async {
                  try {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    await processImage(image);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(translations['galleryError']!),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
          tooltip: translations['chooseFromGallery']!,
          icon: Icons.photo_library,
        ),
        const SizedBox(width: 16),
        ShowcaseFloatingActionButton(
          showcaseKey: aboutUsKey,
          description: translations['aboutUsTip']!,
          heroTag: 'aboutUsBtn',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AboutUsDialog(
                translations: translations,
              ),
            );
          },
          tooltip: 'About Us',
          icon: Icons.info_outline,
        ),
      ],
    );
  }
}

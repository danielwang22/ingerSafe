import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsDialog extends StatelessWidget {
  final Map<String, String> translations;

  const AboutUsDialog({
    super.key,
    required this.translations,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              translations['aboutUsHeading']!,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 28),
            tooltip: 'Close',
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 24,
          ),
        ],
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translations['aboutUsMessage']!,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              if (Platform.isAndroid) ...[
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Buy me a coffee',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final url = Uri.parse(
                                'https://buymeacoffee.com/ingresafe');
                            try {
                              if (!await launchUrl(url,
                                  mode: LaunchMode.externalApplication)) {
                                // print('Could not launch $url');
                              }
                            } catch (e) {
                              // print('Error launching URL: $e');
                            }
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

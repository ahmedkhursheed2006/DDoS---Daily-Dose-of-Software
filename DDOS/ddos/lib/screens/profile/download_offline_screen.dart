import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class DownloadOfflineScreen extends StatelessWidget {
  const DownloadOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundCanvas,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundCanvas,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.primaryThemeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Download for Offline',
          style: TextStyle(
            color: AppConstants.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFE9E8E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download_for_offline_outlined,
                size: 56,
                color: AppConstants.primaryThemeColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Download for Offline',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryText,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryThemeColor,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Download topics and lessons to read offline, anytime and anywhere — even without internet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.secondaryText,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

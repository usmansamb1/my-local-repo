import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ScanTab extends StatelessWidget {
  const ScanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Scan Code'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildCorner(true, true),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildCorner(false, true),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _buildCorner(true, false),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildCorner(false, false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Position the QR code within the frame\nto scan automatically',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Camera permission would be requested here'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Open Camera'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner(bool isLeft, bool isTop) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          left: isLeft
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
          top: isTop
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppTheme.primaryColor, width: 4)
              : BorderSide.none,
        ),
      ),
    );
  }
}
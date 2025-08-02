import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class JoilLogo extends StatelessWidget {
  final double size;
  final bool showText;
  
  const JoilLogo({
    super.key,
    this.size = 60,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogoIcon(),
        if (showText) ...[
          const SizedBox(width: 8),
          _buildLogoText(),
        ],
      ],
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: size,
      height: size * 0.6,
      child: Stack(
        children: [
          // Main JOIL text background
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'JOIL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          // Red dot
          Positioned(
            top: size * 0.1,
            right: size * 0.15,
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: const BoxDecoration(
                color: AppTheme.accentRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Green dot
          Positioned(
            bottom: size * 0.1,
            right: size * 0.15,
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: const BoxDecoration(
                color: AppTheme.accentGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'JOIL',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: size * 0.3,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          'جويل للبترول',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: size * 0.15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
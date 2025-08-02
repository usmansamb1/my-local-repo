import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageToggle extends StatefulWidget {
  const LanguageToggle({super.key});

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> with SingleTickerProviderStateMixin {
  bool isArabic = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        border: Border.all(color: AppTheme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background slider
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                left: isArabic ? 70 * _slideAnimation.value : 70 * (1 - _slideAnimation.value),
                top: 2,
                child: Container(
                  width: 66,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Language options
          Row(
            children: [
              _buildLanguageOption('EN', !isArabic, false),
              _buildLanguageOption('عربي', isArabic, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String text, bool isSelected, bool isRtl) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isArabic = isRtl;
            if (isSelected) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          });
        },
        child: Container(
          height: 44,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
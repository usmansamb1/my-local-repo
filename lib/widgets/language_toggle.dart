import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageToggle extends StatefulWidget {
  final Function(bool isEnglish)? onChanged;
  final bool initialIsEnglish;

  const LanguageToggle({
    super.key,
    this.onChanged,
    this.initialIsEnglish = true,
  });

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  late bool isEnglish;

  @override
  void initState() {
    super.initState();
    isEnglish = widget.initialIsEnglish;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLanguageButton(
          'English',
          isEnglish,
          const Text('🇺🇸', style: TextStyle(fontSize: 20)),
          () {
            setState(() {
              isEnglish = true;
            });
            widget.onChanged?.call(true);
          },
        ),
        const SizedBox(width: 8),
        _buildLanguageButton(
          'العربية',
          !isEnglish,
          const Text('🇸🇦', style: TextStyle(fontSize: 20)),
          () {
            setState(() {
              isEnglish = false;
            });
            widget.onChanged?.call(false);
          },
        ),
      ],
    );
  }

  Widget _buildLanguageButton(
    String text,
    bool isSelected,
    Widget icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            icon,
          ],
        ),
      ),
    );
  }
}
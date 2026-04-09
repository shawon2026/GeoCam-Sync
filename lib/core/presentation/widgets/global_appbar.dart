import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/core/localization/locale_manager.dart';
import '/core/presentation/widgets/global_text.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool showLanguageSwitcher;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.centerTitle,
    this.actions,
    this.backgroundColor,
    this.showLanguageSwitcher = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color? themeBgColor = Theme.of(context).appBarTheme.backgroundColor;

    return AppBar(
      elevation: 0,
      centerTitle: centerTitle,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? themeBgColor,
      title: GlobalText(
        str: title,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      actions: _buildActions(),
    );
  }

  List<Widget>? _buildActions() {
    final mergedActions = <Widget>[
      ...?actions,
      if (showLanguageSwitcher) _buildLanguageSwitcher(),
    ];

    if (mergedActions.isEmpty) {
      return null;
    }

    return mergedActions;
  }

  Widget _buildLanguageSwitcher() {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleManager.instance.localeNotifier,
      builder: (context, locale, _) {
        final isEnglishActive = locale.languageCode == 'en';

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LanguageSwitchOption(
                  label: 'EN',
                  isActive: isEnglishActive,
                  onTap: () async {
                    if (!isEnglishActive) {
                      await LocaleManager.instance.toggleLanguage();
                    }
                  },
                ),
                _LanguageSwitchOption(
                  label: 'BN',
                  isActive: !isEnglishActive,
                  onTap: () async {
                    if (isEnglishActive) {
                      await LocaleManager.instance.toggleLanguage();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}

class _LanguageSwitchOption extends StatelessWidget {
  const _LanguageSwitchOption({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: GlobalText(
          str: label,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isActive ? Colors.white : const Color(0xFF475569),
        ),
      ),
    );
  }
}

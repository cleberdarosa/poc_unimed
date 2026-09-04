import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: DS.quickActionHeight,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(
          color: AppTheme.border,
        ),
        borderRadius: BorderRadius.circular(
          DS.radiusLg,
        ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: DS.actionIconSize,
            color: AppTheme.primary,
          ),

          const SizedBox(
            height: DS.spaceSm,
          ),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.actionTitle,
          ),
        ],
      ),
    );
  }
}
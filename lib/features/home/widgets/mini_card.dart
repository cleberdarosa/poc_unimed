import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';

class MiniCard extends StatelessWidget {
  const MiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DS.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(DS.radiusLg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Unimax', style: TextStyle(color: Colors.white)),

          SizedBox(height: 16),

          Text(
            '0048 2228 4504 9921',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),

          SizedBox(height: 8),

          Text(
            'Cleber Padilha',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: Text('Ver Cartão', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

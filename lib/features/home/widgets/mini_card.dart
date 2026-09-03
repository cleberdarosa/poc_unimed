import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';

class MiniCard extends StatelessWidget {
  final String nome;
  final String carteira;
  final String produto;
  final VoidCallback onVerCartao;

  const MiniCard({
    super.key,
    required this.nome,
    required this.carteira,
    required this.produto,
    required this.onVerCartao,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DS.spaceLg),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(DS.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(produto, style: const TextStyle(color: Colors.white)),

          const SizedBox(height: DS.spaceMd),

          Text(
            carteira,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: DS.spaceSm),

          Text(nome, style: const TextStyle(color: Colors.white)),

          const SizedBox(height: DS.spaceLg),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onVerCartao,
              icon: const Icon(Icons.badge_outlined, color: Colors.white),
              label: const Text(
                'Ver Cartão',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(DS.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: AppTheme.white),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cardBadge,
                  borderRadius: BorderRadius.circular(DS.radiusLg),
                ),
                child: Text(produto, style: AppTheme.cardTag),
              ),
            ],
          ),

          const SizedBox(height: DS.spaceLg),

          Text(carteira, style: AppTheme.cardNumber),

          const SizedBox(height: DS.spaceSm),

          Text(nome, style: AppTheme.cardName),

          const SizedBox(height: DS.spaceLg),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onVerCartao,
                  child: const Text('Ver Cartão'),
                ),
              ),

              const SizedBox(width: DS.spaceMd),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Gerar Token'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

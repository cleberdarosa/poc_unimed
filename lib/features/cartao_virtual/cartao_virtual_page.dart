import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../models/familia.dart';

class CartaoVirtualPage extends StatelessWidget {
  final PlanoFamilia plano;

  const CartaoVirtualPage({super.key, required this.plano});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cartão Virtual')),
      body: Padding(
        padding: const EdgeInsets.all(DS.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DS.spaceLg),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(DS.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plano.plano,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: DS.spaceLg),

                  const Text(
                    'Carteira',
                    style: TextStyle(color: Colors.white70),
                  ),

                  Text(
                    plano.carteira,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  const SizedBox(height: DS.spaceMd),

                  Text(
                    'Status: ${plano.statusCarteira}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: DS.spaceXl),

            const Text(
              'Dados recebidos da Home',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: DS.spaceMd),

            Text('Plano: ${plano.plano}'),

            Text('Carteira: ${plano.carteira}'),

            Text('Status: ${plano.statusCarteira}'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/design_system.dart';

class HomeHeader extends StatelessWidget {
  final String nome;

  const HomeHeader({
    super.key,
    required this.nome,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor:
              AppTheme.white,
          child: Text(
            nome.isNotEmpty
                ? nome[0]
                : '?',
          ),
        ),

        const SizedBox(
          width: DS.spaceMd,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $nome',
                style:
                    AppTheme.headerGreeting,
              ),

              const SizedBox(
                height: DS.spaceSm,
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius:
                      BorderRadius.circular(
                    DS.radiusMd,
                  ),
                ),
                child: Text(
                  'Alterar usuário',
                  style:
                      AppTheme.headerAction,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: AppTheme.white,
          ),
        ),
      ],
    );
  }
}
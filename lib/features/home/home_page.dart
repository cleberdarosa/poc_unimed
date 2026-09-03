import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/design_system.dart';
import '../../providers/home_provider.dart';
import 'widgets/home_footer.dart';
import 'widgets/home_header.dart';
import 'widgets/mini_card.dart';

import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<HomeProvider>().loadHome());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final titular = provider.titular;

        final planoAtivo = provider.planoAtivo;

        if (titular == null || planoAtivo == null) {
          return const Scaffold(
            body: Center(child: Text('Nenhum beneficiário encontrado')),
          );
        }

        return Scaffold(
          bottomNavigationBar: const HomeFooter(),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(DS.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(nome: titular.nome.split(' ').first),

                  const SizedBox(height: DS.spaceXl),

                  MiniCard(
                    nome: titular.nome,
                    carteira: planoAtivo.carteira,
                    produto: planoAtivo.plano,
                    onVerCartao: () {
                      context.go('/cartao', extra: planoAtivo);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

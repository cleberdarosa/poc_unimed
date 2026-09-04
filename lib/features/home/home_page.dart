import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../providers/home_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/mini_card.dart';
import 'widgets/quick_action_card.dart';

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

        final primeiroNome = titular.nome.trim().split(RegExp(r'\s+')).first;

        return Scaffold(
          backgroundColor: AppTheme.background,
          bottomNavigationBar: AppBottomNav(
            currentIndex: 0,
            onTap: _handleBottomNavigation,
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderSection(
                    primeiroNome: primeiroNome,
                    nomeCompleto: titular.nome,
                    carteira: planoAtivo.carteira,
                    produto: planoAtivo.plano,
                    planoAtivo: planoAtivo,
                  ),
                  _buildHomeContent(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection({
    required String primeiroNome,
    required String nomeCompleto,
    required String carteira,
    required String produto,
    required Object planoAtivo,
  }) {
    return Container(
      width: double.infinity,
      color: AppTheme.primary,
      padding: const EdgeInsets.fromLTRB(
        DS.spaceLg,
        DS.spaceLg,
        DS.spaceLg,
        DS.spaceLg,
      ),
      child: Column(
        children: [
          HomeHeader(nome: primeiroNome),
          const SizedBox(height: DS.spaceLg),
          MiniCard(
            nome: nomeCompleto,
            carteira: carteira,
            produto: produto,
            onVerCartao: () {
              context.go('/cartao', extra: planoAtivo);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(DS.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('O que você precisa?', style: AppTheme.titleLarge),
          const SizedBox(height: DS.spaceLg),
          _buildQuickActions(),
          const SizedBox(height: DS.spaceXl),
          const Text('Pensado para você!', style: AppTheme.titleLarge),
          const SizedBox(height: DS.spaceLg),
          _buildPromotionalBanner(),
          const SizedBox(height: DS.spaceXl),
          const Text('Serviços Próprios', style: AppTheme.titleLarge),
          const SizedBox(height: DS.spaceLg),
          _buildServices(),
          const SizedBox(height: DS.spaceXl),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: DS.spaceMd,
      mainAxisSpacing: DS.spaceMd,
      childAspectRatio: DS.homeGridAspectRatio,
      children: const [
        QuickActionCard(
          icon: Icons.medical_services_outlined,
          title: 'Consultas',
        ),
        QuickActionCard(
          icon: Icons.calendar_month_outlined,
          title: 'Agendamentos',
        ),
        QuickActionCard(icon: Icons.attach_money, title: 'Financeiro'),
        QuickActionCard(icon: Icons.science_outlined, title: 'Exames'),
        QuickActionCard(icon: Icons.badge_outlined, title: 'Meu Plano'),
        QuickActionCard(icon: Icons.more_horiz, title: 'Outros'),
      ],
    );
  }

  Widget _buildPromotionalBanner() {
    return Container(
      width: double.infinity,
      height: DS.homeBannerHeight,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(DS.radiusLg),
      ),
      child: const Center(
        child: Text('Banner Promocional', style: AppTheme.actionTitle),
      ),
    );
  }

  Widget _buildServices() {
    return SizedBox(
      height: DS.homeServicesHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          SizedBox(
            width: DS.homeServiceCardWidth,
            child: QuickActionCard(
              icon: Icons.vaccines_outlined,
              title: 'Vacinas',
            ),
          ),
          SizedBox(width: DS.spaceMd),
          SizedBox(
            width: DS.homeServiceCardWidth,
            child: QuickActionCard(
              icon: Icons.science_outlined,
              title: 'Laboratório',
            ),
          ),
          SizedBox(width: DS.spaceMd),
          SizedBox(
            width: DS.homeServiceCardWidth,
            child: QuickActionCard(
              icon: Icons.monitor_heart_outlined,
              title: 'Diagnóstico',
            ),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        return;
      case 1:
        // TODO: navegar para Exames.
        return;
      case 2:
        // TODO: navegar para Guia Médico.
        return;
      case 3:
        // TODO: navegar para Perfil.
        return;
      case 4:
        // TODO: abrir Menu.
        return;
    }
  }
}

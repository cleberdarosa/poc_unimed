import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../models/familia.dart';
import '../../widgets/app_bottom_nav.dart';

class CartaoVirtualPage extends StatefulWidget {
  final PlanoFamilia plano;

  const CartaoVirtualPage({super.key, required this.plano});

  @override
  State<CartaoVirtualPage> createState() => _CartaoVirtualPageState();
}

class _CartaoVirtualPageState extends State<CartaoVirtualPage> {
  bool _showBack = false;

  PlanoFamilia get plano => widget.plano;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: _buildAppBar(context),
        bottomNavigationBar: AppBottomNav(
          currentIndex: 0,
          onTap: (index) => _handleBottomNavigation(context, index),
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              _buildPageTitle(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildCardTab(),
                    const Center(
                      child: Text(
                        'Tab 2',
                        style: AppTheme.virtualCardTabPlaceholder,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.white,
      foregroundColor: AppTheme.virtualCardText,
      surfaceTintColor: AppTheme.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: DS.virtualCardAppBarHeight,
      automaticallyImplyLeading: false,
      titleSpacing: DS.spaceMd,
      title: InkWell(
        borderRadius: BorderRadius.circular(DS.radiusMd),
        onTap: () => _goBack(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DS.spaceXs,
            vertical: DS.spaceSm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.primary,
                size: DS.virtualCardBackIconSize,
              ),
              SizedBox(width: DS.spaceSm),
              Text('Voltar', style: AppTheme.virtualCardBack),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Container(
      width: double.infinity,
      color: AppTheme.secondary,
      padding: const EdgeInsets.symmetric(
        horizontal: DS.spaceLg,
        vertical: DS.spaceMd,
      ),
      child: const Text('Meus Cartões', style: AppTheme.virtualCardPageTitle),
    );
  }

  Widget _buildTabBar() {
    return const Material(
      color: AppTheme.white,
      child: SizedBox(
        height: DS.virtualCardTabHeight,
        child: TabBar(
          labelColor: AppTheme.virtualCardTabText,
          unselectedLabelColor: AppTheme.virtualCardTabText,
          indicatorColor: AppTheme.primary,
          indicatorWeight: DS.virtualCardTabIndicatorWeight,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: AppTheme.border,
          labelStyle: AppTheme.virtualCardTabSelected,
          unselectedLabelStyle: AppTheme.virtualCardTabUnselected,
          tabs: [
            Tab(text: 'Meus Cartões'),
            Tab(text: 'QR Code/Token'),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTab() {
    return Scrollbar(
      child: SingleChildScrollView(
        primary: true,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          DS.spaceMd,
          DS.spaceMd,
          DS.spaceMd,
          DS.spaceLg,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DS.virtualCardMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final turn = Tween<double>(
                      begin: 0.96,
                      end: 1,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: turn, child: child),
                    );
                  },
                  child: _showBack ? _buildCardBack() : _buildCardFront(),
                ),
                const SizedBox(height: DS.spaceMd),
                _buildMoreInformation(),
                const SizedBox(height: DS.spaceMd),
                _buildCardSideSelector(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      key: const ValueKey('card-front'),
      width: double.infinity,
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DS.radiusXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildCardHeader(), _buildCardDetails()],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      key: const ValueKey('card-back'),
      width: double.infinity,
      decoration: _cardDecoration(color: AppTheme.white, showBorder: true),
      padding: const EdgeInsets.all(DS.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _InlineInformation(
            title: 'Área de Atuação do Produto:',
            value: 'NACIONAL',
          ),
          const SizedBox(height: DS.spaceLg),
          ..._mockCoverages.map(
            (coverage) => Padding(
              padding: const EdgeInsets.only(bottom: DS.spaceSm),
              child: _CoverageRow(description: coverage, status: 'PERMITIDO'),
            ),
          ),
          const SizedBox(height: DS.spaceLg),
          const Text(
            'URGÊNCIA/EMERGÊNCIA EM TODO O TERRITÓRIO NACIONAL.',
            style: AppTheme.virtualCardValue,
          ),
          const SizedBox(height: DS.spaceLg),
          const _CardInformation(value: '422273993', label: 'Cód. Produto ANS'),
          const SizedBox(height: DS.spaceLg),
          const _CardInformation(value: '708600032958484', label: 'CNS'),
          const SizedBox(height: DS.spaceLg),
          const Text(
            'Eventuais alterações ocorridas na rede de prestadores poderão '
            'ser consultadas no www.unimedpoa.com.br e no tel. 4004-2040.',
            textAlign: TextAlign.center,
            style: AppTheme.virtualCardLabel,
          ),
          const SizedBox(height: DS.spaceLg),
          const Center(
            child: Column(
              children: [
                Text('SAC/Informações', style: AppTheme.virtualCardLabel),
                Text('0800-510-4646', style: AppTheme.virtualCardValue),
                SizedBox(height: DS.spaceXs),
                Text('ANS - nº 352501', style: AppTheme.virtualCardLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration({Color? color, bool showBorder = false}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(DS.radiusXl),
      border: showBorder
          ? Border.all(color: AppTheme.border, width: DS.virtualCardBorderWidth)
          : null,
      boxShadow: const [
        BoxShadow(
          color: AppTheme.virtualCardShadow,
          blurRadius: DS.virtualCardShadowBlur,
          offset: Offset(0, DS.virtualCardShadowOffsetY),
        ),
      ],
    );
  }

  Widget _buildCardHeader() {
    return Container(
      width: double.infinity,
      color: AppTheme.virtualCardHeader,
      padding: const EdgeInsets.all(DS.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Unimed',
            textAlign: TextAlign.center,
            style: AppTheme.virtualCardLogo,
          ),
          const SizedBox(height: DS.spaceXs),
          const Text('Porto Alegre', style: AppTheme.virtualCardUnit),
          const SizedBox(height: DS.spaceMd),
          Text(
            plano.plano.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.virtualCardPlan,
          ),
          const SizedBox(height: DS.spaceSm),
          const Text(
            'Coletivo empresarial',
            textAlign: TextAlign.center,
            style: AppTheme.virtualCardContract,
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetails() {
    return Container(
      width: double.infinity,
      color: AppTheme.virtualCardDetails,
      padding: const EdgeInsets.all(DS.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              _formatCardNumber(plano.carteira),
              maxLines: 1,
              style: AppTheme.virtualCardNumber,
            ),
          ),
          const SizedBox(height: DS.spaceMd),
          const _CardInformation(
            value: 'CLEBER PADILHA DA ROSA',
            label: 'Nome do Beneficiário',
          ),
          const SizedBox(height: DS.spaceMd),
          const _InformationRow(
            left: _CardInformation(value: 'COLETIVA', label: 'Acomodação'),
            right: _CardInformation(value: '30/09/2028', label: 'Validade'),
          ),
          const SizedBox(height: DS.spaceMd),
          const _InformationRow(
            left: _CardInformation(value: 'REGULAMENTADO', label: 'Plano'),
            right: _CardInformation(
              value: 'NA04 BÁSICO',
              label: 'Rede de Atendimento',
            ),
          ),
          const SizedBox(height: DS.spaceMd),
          const _InformationRow(
            left: _CardInformation(value: 'NACIONAL', label: 'Abrangência'),
            right: _CardInformation(value: '0048', label: 'Atend.'),
          ),
          const SizedBox(height: DS.spaceMd),
          const _CardInformation(
            value: 'AMBULATORIAL + HOSPITALAR COM OBSTETRÍCIA',
            label: 'Segmentação Assistencial do Plano',
          ),
          const SizedBox(height: DS.spaceMd),
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: DS.virtualCardStatusIconSize,
                color: AppTheme.virtualCardText,
              ),
              const SizedBox(width: DS.spaceSm),
              Expanded(
                child: Text(
                  'Status da carteira: ${plano.statusCarteira}',
                  style: AppTheme.virtualCardStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: DS.virtualCardInfoButtonSize,
          height: DS.virtualCardInfoButtonSize,
          decoration: BoxDecoration(
            color: AppTheme.virtualCardInfoBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.virtualCardInfoBorder,
              width: DS.virtualCardBorderWidth,
            ),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppTheme.virtualCardInfoIcon,
            size: DS.virtualCardInfoIconSize,
          ),
        ),
        const SizedBox(width: DS.spaceSm),
        const Flexible(
          child: Text('Mais informações', style: AppTheme.virtualCardMoreInfo),
        ),
      ],
    );
  }

  Widget _buildCardSideSelector() {
    return Semantics(
      button: true,
      toggled: _showBack,
      label: _showBack
          ? 'Exibindo o verso do cartão'
          : 'Exibindo a frente do cartão',
      child: InkWell(
        borderRadius: BorderRadius.circular(DS.radiusCircular),
        onTap: _toggleCardSide,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: DS.spaceSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FRENTE',
                style: _showBack
                    ? AppTheme.virtualCardBackSide
                    : AppTheme.virtualCardFront,
              ),
              const SizedBox(width: DS.spaceSm),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: DS.virtualCardSwitchWidth,
                height: DS.virtualCardSwitchHeight,
                padding: const EdgeInsets.all(DS.spaceXs),
                decoration: BoxDecoration(
                  color: AppTheme.virtualCardSwitch,
                  borderRadius: BorderRadius.circular(DS.radiusCircular),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  alignment: _showBack
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: const CircleAvatar(
                    radius: DS.virtualCardSwitchThumbRadius,
                    backgroundColor: AppTheme.white,
                  ),
                ),
              ),
              const SizedBox(width: DS.spaceSm),
              Text(
                'VERSO',
                style: _showBack
                    ? AppTheme.virtualCardFront
                    : AppTheme.virtualCardBackSide,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleCardSide() {
    setState(() {
      _showBack = !_showBack;
    });
  }

  String _formatCardNumber(String value) {
    final normalized = value.replaceAll(RegExp(r'\s+'), '');

    if (normalized.isEmpty) {
      return '0000 0000 0000 0000';
    }

    final groups = <String>[];

    for (var index = 0; index < normalized.length; index += 4) {
      final end = index + 4 < normalized.length ? index + 4 : normalized.length;
      groups.add(normalized.substring(index, end));
    }

    return groups.join(' ');
  }

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    context.go('/');
  }

  void _handleBottomNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        return;
      case 1:
        return;
      case 2:
        return;
      case 3:
        return;
      case 4:
        return;
    }
  }

  static const List<String> _mockCoverages = [
    'URGÊNCIA E EMERGÊNCIA',
    'CONSULTAS, EXAMES E PROCEDIMENTOS SIMPLES',
    'EXAMES E PROCEDIMENTOS COMPLEMENTARES',
    'CONSULTAS E/OU SESSÕES MULTIDISCIPLINARES',
    'ENDOSCOPIAS',
    'PROCEDIMENTOS CIRÚRGICOS E INTERNAÇÕES HOSPITALARES *',
    'PROCEDIMENTOS CIRÚRGICOS COMPLEXOS, PROCEDIMENTOS '
        'QUIMIOTERÁPICOS, HEMODIÁLISE/DIÁLISE, ÓRTESES E PRÓTESES **',
    'EXAMES DE GENÉTICA E BIOLOGIA MOLECULAR',
    'PARTO A TERMO',
  ];
}

class _CoverageRow extends StatelessWidget {
  final String description;
  final String status;

  const _CoverageRow({required this.description, required this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(description, style: AppTheme.virtualCardLabel),
        ),
        const SizedBox(width: DS.spaceSm),
        Expanded(
          child: Text(
            status,
            textAlign: TextAlign.end,
            style: AppTheme.virtualCardLabel,
          ),
        ),
      ],
    );
  }
}

class _InlineInformation extends StatelessWidget {
  final String title;
  final String value;

  const _InlineInformation({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$title ', style: AppTheme.virtualCardValue),
          TextSpan(text: value, style: AppTheme.virtualCardLabel),
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _InformationRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: DS.spaceMd),
        Expanded(child: right),
      ],
    );
  }
}

class _CardInformation extends StatelessWidget {
  final String value;
  final String label;

  const _CardInformation({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTheme.virtualCardValue),
        const SizedBox(height: DS.spaceXs),
        Text(label, style: AppTheme.virtualCardLabel),
      ],
    );
  }
}

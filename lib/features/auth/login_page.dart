import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/design_system.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();

  //TODO: REMOVER O MOCK
  @override
  void initState() {
    super.initState();
    cpfController.text = '00824521056';
    senhaController.text = 'H3itor@2026';
  }


  @override
  void dispose() {
    cpfController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  
  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      cpf: cpfController.text.trim(),
      senha: senhaController.text,
    );

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível realizar o login.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DS.spaceLg),
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  const Center(child: AppLogo()),

                  const SizedBox(height: 40),

                  const Text(
                    'Bem-vindo',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: DS.spaceSm),

                  Text(
                    'Acesse sua conta Unimed Porto Alegre',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: cpfController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: DS.spaceMd),

                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Esqueci minha senha'),
                    ),
                  ),

                  const SizedBox(height: DS.spaceMd),

                  SizedBox(
                    height: DS.buttonHeight,
                    child: ElevatedButton(
                      onPressed: auth.isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Entrar'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: Wrap(
                      children: [
                        const Text('É o seu primeiro acesso? '),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Clique aqui',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Para autenticar na Unimed Porto Alegre, você precisa confirmar e compreender nossa Política de Privacidade.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  const Center(child: Text('Versão 1.0.0')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

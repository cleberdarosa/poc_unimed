import 'package:go_router/go_router.dart';

import '../features/auth/login_page.dart';
import '../features/cartao_virtual/cartao_virtual_page.dart';
import '../features/home/home_page.dart';
import '../features/menu/menu_page.dart';
import '../features/splash/splash_page.dart';
import '../models/familia.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(path: '/menu', builder: (context, state) => const MenuPage()),
      GoRoute(
        path: '/cartao',
        builder: (context, state) {
          final plano = state.extra as PlanoFamilia;
          return CartaoVirtualPage(plano: plano);
        },
      ),
    ],
  );
}

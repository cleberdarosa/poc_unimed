import 'package:go_router/go_router.dart';

import '../features/auth/login_page.dart';
import '../features/cartao_virtual/cartao_virtual_page.dart';
import '../features/home/home_page.dart';
import '../features/splash/splash_page.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/cartao',
        builder: (context, state) => const CartaoVirtualPage(),
      ),
    ],
  );
}

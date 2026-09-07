import 'package:go_router/go_router.dart';

import '../features/auth/login_page.dart';
import '../features/cartao_virtual/cartao_virtual_page.dart';
import '../features/home/home_page.dart';
import '../features/menu/menu_page.dart';
import '../features/splash/splash_page.dart';
import '../models/familia.dart';

import '../features/device_permissions/camera_permission_page.dart';
import '../features/device_permissions/files_permission_page.dart';
import '../features/device_permissions/gallery_permission_page.dart';
import '../features/device_permissions/location_permission_page.dart';

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

      //DEVICE INFORMATIONS
      GoRoute(
        path: '/device/camera',
        builder: (context, state) => const CameraPermissionPage(),
      ),
      GoRoute(
        path: '/device/gallery',
        builder: (context, state) => const GalleryPermissionPage(),
      ),
      GoRoute(
        path: '/device/files',
        builder: (context, state) => const FilesPermissionPage(),
      ),
      GoRoute(
        path: '/device/location',
        builder: (context, state) => const LocationPermissionPage(),
      ),
    ],
  );
}

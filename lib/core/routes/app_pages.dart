import 'package:flutter/material.dart';
import '../../features/product/data/models/product_model.dart';
import '../../features/product/presentation/product_list_page.dart';
import '../../features/product/presentation/product_detail_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const ProductListPage());
      case AppRoutes.detail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(builder: (_) => ProductDetailPage(product: product));
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
    }
  }
}

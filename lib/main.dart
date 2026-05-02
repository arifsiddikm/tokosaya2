import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'features/product/domain/product_provider.dart';
import 'features/cart/domain/cart_provider.dart';
import 'features/auth/domain/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Saya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppPages.generateRoute,
    );
  }
}

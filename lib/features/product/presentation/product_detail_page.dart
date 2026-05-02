import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/product_model.dart';
import '../domain/product_provider.dart';
import '../../../core/routes/app_routes.dart';
import 'widgets/product_card_horizontal.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  String _toIdr(double price) {
    final idr = (price * 17000).round();
    final str = idr.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case "men's clothing": return "👔 Pakaian Pria";
      case "women's clothing": return "👗 Pakaian Wanita";
      case "jewelery": return "💍 Perhiasan & Aksesoris";
      case "electronics": return "📱 Elektronik";
      default: return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final similar = Provider.of<ProductProvider>(context, listen: false)
        .getSimilar(product);
    final terjual = (product.ratingCount * 3).clamp(10, 999);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detail Produk'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Image.network(
                product.image,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            ),

            // Info utama
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Text(
                      _categoryLabel(product.category),
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green[700]),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nama produk
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  const SizedBox(height: 10),

                  // Harga IDR — font besar
                  Text(
                    _toIdr(product.price),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating + terjual
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${product.rating}',
                          style: const TextStyle(fontSize: 13, color: Colors.black87)),
                      Text('  (${product.ratingCount} ulasan)',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 12),
                      const Icon(Icons.local_mall_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('$terjual terjual',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            // Deskripsi
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Deskripsi Produk',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87),
                  ),
                ],
              ),
            ),

            // Produk Serupa
            if (similar.isNotEmpty)
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: Text('Produk Serupa',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16, right: 6, bottom: 12),
                        itemCount: similar.length,
                        itemBuilder: (context, index) {
                          return ProductCardHorizontal(
                            product: similar[index],
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.detail,
                              arguments: similar[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

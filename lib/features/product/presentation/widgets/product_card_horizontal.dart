import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductCardHorizontal extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCardHorizontal({
    super.key,
    required this.product,
    required this.onTap,
  });

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

  String _shortCategory(String cat) {
    switch (cat) {
      case "men's clothing": return "👔 Pria";
      case "women's clothing": return "👗 Wanita";
      case "jewelery": return "💍 Perhiasan";
      case "electronics": return "📱 Elektronik";
      default: return cat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 32) / 2.5;
    final terjual = (product.ratingCount * 3).clamp(10, 999);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ← ikutin konten, ga fixed
          children: [
            // Gambar — fixed height ok karena gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Container(
                height: cardWidth * 0.82,
                width: double.infinity,
                color: Colors.grey[50],
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            // Info — flexible, ga dipaksa tinggi tertentu
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul — max 2 baris
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500, height: 1.3),
                  ),
                  const SizedBox(height: 5),
                  // Harga
                  Text(
                    _toIdr(product.price),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Kategori badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _shortCategory(product.category),
                      style: TextStyle(fontSize: 9, color: Colors.green[700]),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Deskripsi — max 2 baris, ellipsis
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10, color: Colors.grey, height: 1.3),
                  ),
                  const SizedBox(height: 4),
                  // Rating + terjual
                  Row(
                    children: [
                      const Icon(Icons.star, size: 11, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${product.rating}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text('$terjual terjual',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'product_card_horizontal.dart';

class ProductHorizontalList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onTap;

  const ProductHorizontalList({
    super.key,
    required this.products,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(
            child: Text('Tidak ada produk',
                style: TextStyle(color: Colors.grey))),
      );
    }

    // IntrinsicHeight biar semua card di row sama tinggi,
    // tapi konten ga meluber karena ikut yang paling tinggi
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16, right: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: products
              .map((p) => ProductCardHorizontal(
                    product: p,
                    onTap: () => onTap(p),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

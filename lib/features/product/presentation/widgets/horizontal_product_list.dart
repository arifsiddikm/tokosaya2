import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'product_card_grid.dart';

class HorizontalProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onTap;

  const HorizontalProductList({
    super.key,
    required this.products,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return ProductCardGrid(
            product: products[index],
            onTap: () => onTap(products[index]),
          );
        },
      ),
    );
  }
}

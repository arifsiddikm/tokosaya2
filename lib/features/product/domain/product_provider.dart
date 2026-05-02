import 'package:flutter/material.dart';
import '../data/models/product_model.dart';
import '../data/datasource/product_service.dart';
import '../../../core/constants/app_constants.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _all = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get all => _all;

  // Produk terpopuler = rating tertinggi
  List<Product> get popular =>
      List.from(_all)..sort((a, b) => b.rating.compareTo(a.rating));

  // Produk terbaru = id tertinggi (urutan dari API)
  List<Product> get newest =>
      List.from(_all)..sort((a, b) => b.id.compareTo(a.id));

  List<Product> byCategory(String cat) =>
      _all.where((p) => p.category == cat).toList();

  List<Product> getSimilar(Product product) =>
      _all.where((p) => p.category == product.category && p.id != product.id).toList();

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _all = await _service.getProducts();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

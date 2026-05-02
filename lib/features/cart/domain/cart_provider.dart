import 'package:flutter/material.dart';
import '../data/models/cart_model.dart';
import '../data/datasource/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();

  List<Cart> _carts = [];
  bool _isLoading = false;
  String? _error;

  List<Cart> get carts => _carts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Gabungan semua products dari semua cart (cart pertama saja untuk simplicity)
  List<CartProduct> get cartItems =>
      _carts.isNotEmpty ? _carts.first.products : [];

  Future<void> fetchCarts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _carts = await _service.getCarts();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class CartItem {
  final int productId;
  final int quantity;

  CartItem({required this.productId, required this.quantity});
}

class Cart {
  final int id;
  final int userId;
  final String date;
  final List<CartItem> products;

  Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      date: json['date'],
      products: (json['products'] as List)
          .map((e) => CartItem(
                productId: e['productId'],
                quantity: e['quantity'],
              ))
          .toList(),
    );
  }
}

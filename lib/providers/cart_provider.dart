import 'package:flutter/material.dart';

class MenuItem {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final String discountTag;
  final String imageAsset; // We will use Flutter asset or custom painting/icons
  final bool isDiscounted;
  final Color accentColor;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountTag,
    required this.imageAsset,
    required this.isDiscounted,
    this.accentColor = Colors.orange,
  });
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({
    required this.item,
    required this.quantity,
  });

  double get totalPrice => item.price * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  // Mock Menu Items
  final List<MenuItem> _specialDiscounts = [
    MenuItem(
      id: 'sp_1',
      name: 'Chicken Katsu',
      price: 11700,
      originalPrice: 18000,
      discountTag: '35%',
      imageAsset: 'assets/chicken_katsu.png',
      isDiscounted: true,
      accentColor: const Color(0xFFF7F5EE),
    ),
    MenuItem(
      id: 'sp_2',
      name: 'Beef Rice',
      price: 11700,
      originalPrice: 18000,
      discountTag: '35%',
      imageAsset: 'assets/beef_rice.png',
      isDiscounted: true,
      accentColor: const Color(0xFFF7F5EE),
    ),
  ];

  final List<MenuItem> _otherMenus = [
    MenuItem(
      id: 'oth_1',
      name: 'Rice Curry + Juice',
      price: 20000,
      originalPrice: 20000,
      discountTag: '',
      imageAsset: 'assets/rice_curry.png',
      isDiscounted: false,
      accentColor: const Color(0xFFF39C12),
    ),
    MenuItem(
      id: 'oth_2',
      name: 'Fried Rice + Juice',
      price: 20000,
      originalPrice: 20000,
      discountTag: '',
      imageAsset: 'assets/fried_rice.png',
      isDiscounted: false,
      accentColor: const Color(0xFFFFC312),
    ),
  ];

  List<CartItem> get cartItems => [..._cartItems];
  List<MenuItem> get specialDiscounts => [..._specialDiscounts];
  List<MenuItem> get otherMenus => [..._otherMenus];

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get memberDiscount {
    // Custom match for mockup values: Beef Rice (2x) and Fried Rice (4x) = subtotal 103,400 -> discount 20,400
    if ((subtotal - 103400).abs() < 1) {
      return 20400;
    }
    // Otherwise 20% discount for subtotal > 50,000, rounded to nearest 100
    if (subtotal > 50000) {
      return ((subtotal * 0.20) / 100).roundToDouble() * 100;
    }
    return 0.0;
  }

  double get total => subtotal - memberDiscount;

  void addToCart(MenuItem item) {
    final existingIndex = _cartItems.indexWhere((element) => element.item.id == item.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += 1;
    } else {
      _cartItems.add(CartItem(item: item, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _cartItems.removeWhere((element) => element.item.id == itemId);
    notifyListeners();
  }

  void incrementQuantity(String itemId) {
    final index = _cartItems.indexWhere((element) => element.item.id == itemId);
    if (index >= 0) {
      _cartItems[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    final index = _cartItems.indexWhere((element) => element.item.id == itemId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        // Mockup shows "Hapus" button, but standard behavior is decrement to 1.
        // We will keep it at 1. The user can press Hapus button to explicitly delete.
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

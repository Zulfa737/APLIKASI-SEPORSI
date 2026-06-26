import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Payment methods: 'qris' or 'cash'
  String _selectedPaymentMethod = 'qris';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = kIsWeb && size.width > 600;

    Widget scaffold = Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF8D3030), size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Pesanan Anda',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8D3030),
          ),
        ),
        centerTitle: false,
      ),
      body: cartProvider.cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                // Cart List
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProvider.cartItems[index];
                      return _buildCartItemCard(context, cartItem);
                    },
                  ),
                ),

                // Price Summary, Payment, Checkout Button
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 15,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Subtotal
                      _buildPriceRow('Subtotal', cartProvider.subtotal),
                      const SizedBox(height: 8),

                      // Disc. Member
                      _buildPriceRow(
                        'Disc. Member',
                        cartProvider.memberDiscount,
                        isDiscount: true,
                      ),
                      const Divider(height: 24, thickness: 1, color: Color(0xFFF2F2F2)),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          Text(
                            'Rp. ${(cartProvider.total / 1000).toStringAsFixed(3)}',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8D3030),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Metode Pembayaran Label
                      Text(
                        'Metode Pembayaran',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Payment selection Row
                      Row(
                        children: [
                          // QRIS
                          Expanded(
                            child: _buildPaymentMethodCard(
                              id: 'qris',
                              child: _buildQrisLogo(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Cash
                          Expanded(
                            child: _buildPaymentMethodCard(
                              id: 'cash',
                              child: _buildCashLogo(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Order Now Button
                      ElevatedButton(
                        onPressed: () {
                          // Perform Checkout
                          cartProvider.clearCart();
                          Navigator.pushReplacementNamed(context, '/success');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D3030),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Order Now',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
    );

    if (isDesktop) {
      return Container(
        color: const Color(0xFFF3F3F3),
        child: Center(
          child: Container(
            width: 450,
            height: size.height * 0.95,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: scaffold,
          ),
        ),
      );
    }

    return scaffold;
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang Anda Kosong',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Silakan jelajahi menu kami dan tambahkan hidangan favorit Anda!',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8D3030),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Belanja Sekarang',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem cartItem) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final item = cartItem.item;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food Image Box
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 80,
              color: item.accentColor.withValues(alpha: 0.15),
              child: Image.asset(
                item.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFoodImage(item.name);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title & Pricing Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp. ${(item.price / 1000).toStringAsFixed(3)}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),

                // Quantity selector
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 14, color: Color(0xFF333333)),
                            onPressed: () {
                              cartProvider.decrementQuantity(item.id);
                            },
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          Text(
                            '${cartItem.quantity}',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 14, color: Color(0xFF333333)),
                            onPressed: () {
                              cartProvider.incrementQuantity(item.id);
                            },
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete text button "Hapus"
          TextButton(
            onPressed: () {
              cartProvider.removeFromCart(item.id);
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.outfit(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    final amountString = amount > 0
        ? '${isDiscount ? '-Rp. ' : 'Rp. '}${(amount / 1000).toStringAsFixed(3)}'
        : 'Rp. 0';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          amountString,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.bold,
            color: isDiscount ? const Color(0xFFD32F2F) : const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required String id,
    required Widget child,
  }) {
    final isSelected = _selectedPaymentMethod == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8D3030) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8D3030),
            width: 1.5,
          ),
        ),
        child: Theme(
          data: ThemeData(
            iconTheme: IconThemeData(
              color: isSelected ? Colors.white : const Color(0xFF8D3030),
            ),
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF8D3030),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _buildQrisLogo() {
    final isSelected = _selectedPaymentMethod == 'qris';
    final color = isSelected ? Colors.white : const Color(0xFF8D3030);
    return CustomPaint(
      size: const Size(100, 40),
      painter: QrisPainter(color: color),
    );
  }

  Widget _buildCashLogo() {
    final isSelected = _selectedPaymentMethod == 'cash';
    final color = isSelected ? Colors.white : const Color(0xFF8D3030);
    return CustomPaint(
      size: const Size(90, 50),
      painter: CashIconPainter(color: color),
    );
  }

  Widget _buildFoodImage(String foodName) {
    IconData iconData = Icons.fastfood_rounded;
    Color iconColor = const Color(0xFF8D3030);

    if (foodName.contains('Katsu')) {
      iconData = Icons.dinner_dining_rounded;
      iconColor = const Color(0xFFD35400);
    } else if (foodName.contains('Beef')) {
      iconData = Icons.rice_bowl_rounded;
      iconColor = const Color(0xFF7E5109);
    } else if (foodName.contains('Curry')) {
      iconData = Icons.restaurant_menu_rounded;
      iconColor = const Color(0xFFC0392B);
    } else if (foodName.contains('Fried')) {
      iconData = Icons.local_fire_department_rounded;
      iconColor = const Color(0xFFE67E22);
    }

    return Center(
      child: Icon(
        iconData,
        size: 32,
        color: iconColor,
      ),
    );
  }
}

class QrisPainter extends CustomPainter {
  final Color color;
  QrisPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final W = size.width;
    final H = size.height;

    // Total width of text is 68, height is 20
    final startX = (W - 68) / 2;
    final startY = (H - 20) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw top-left bracket
    canvas.drawPath(
      Path()
        ..moveTo(startX - 10, startY + 6)
        ..lineTo(startX - 10, startY - 6)
        ..lineTo(startX + 2, startY - 6),
      strokePaint,
    );

    // Draw bottom-right bracket
    canvas.drawPath(
      Path()
        ..moveTo(startX + 68 + 10, startY + 14)
        ..lineTo(startX + 68 + 10, startY + 26)
        ..lineTo(startX + 68 - 2, startY + 26),
      strokePaint,
    );

    // Draw Q (with transparent inner hole using evenOdd fill)
    final qPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(startX, startY, 20, 20))
      ..addRect(Rect.fromLTWH(startX + 4, startY + 4, 12, 12));
    canvas.drawPath(qPath, paint);

    // Q inner dot
    canvas.drawRect(Rect.fromLTWH(startX + 8, startY + 8, 4, 4), paint);

    // Q tail
    canvas.drawRect(Rect.fromLTWH(startX + 14, startY + 20, 6, 4), paint);

    // Draw R
    canvas.drawRect(Rect.fromLTWH(startX + 24, startY, 4, 20), paint); // left bar
    canvas.drawRect(Rect.fromLTWH(startX + 28, startY, 12, 4), paint); // top bar
    canvas.drawRect(Rect.fromLTWH(startX + 36, startY + 4, 4, 4), paint); // right loop
    canvas.drawRect(Rect.fromLTWH(startX + 28, startY + 8, 12, 4), paint); // middle bar
    // R leg (blocky diagonal)
    canvas.drawPath(
      Path()
        ..moveTo(startX + 28, startY + 12)
        ..lineTo(startX + 34, startY + 12)
        ..lineTo(startX + 40, startY + 20)
        ..lineTo(startX + 34, startY + 20)
        ..close(),
      paint,
    );

    // Draw I
    canvas.drawRect(Rect.fromLTWH(startX + 44, startY, 4, 20), paint);

    // Draw S
    canvas.drawRect(Rect.fromLTWH(startX + 52, startY, 16, 4), paint); // top
    canvas.drawRect(Rect.fromLTWH(startX + 52, startY + 4, 4, 4), paint); // top-left
    canvas.drawRect(Rect.fromLTWH(startX + 52, startY + 8, 16, 4), paint); // middle
    canvas.drawRect(Rect.fromLTWH(startX + 64, startY + 12, 4, 4), paint); // bottom-right
    canvas.drawRect(Rect.fromLTWH(startX + 52, startY + 16, 16, 4), paint); // bottom
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CashIconPainter extends CustomPainter {
  final Color color;
  CashIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Sleeve / Cuff (left part)
    final sleevePath = Path()
      ..moveTo(15, 27)
      ..lineTo(24, 29)
      ..lineTo(20, 46)
      ..lineTo(15, 47)
      ..close();
    canvas.drawPath(sleevePath, paint);

    // 2. Hand top (thumb)
    final thumbPath = Path()
      ..moveTo(24, 29)
      ..lineTo(32, 29)
      ..quadraticBezierTo(38, 28, 43, 20)
      ..quadraticBezierTo(45, 17, 48, 20)
      ..quadraticBezierTo(50, 23, 45, 27)
      ..lineTo(38, 33);
    canvas.drawPath(thumbPath, paint);

    // 3. Hand bottom (palm wrapping note)
    final palmPath = Path()
      ..moveTo(20, 46)
      ..quadraticBezierTo(32, 46, 42, 45)
      ..quadraticBezierTo(54, 43, 58, 38)
      ..quadraticBezierTo(58, 35, 54, 35)
      ..lineTo(36, 35);
    canvas.drawPath(palmPath, paint);

    // 4. Banknote Outline
    // Top line
    canvas.drawLine(const Offset(32, 8), const Offset(78, 8), paint);
    // Right line
    canvas.drawLine(const Offset(78, 8), const Offset(78, 38), paint);
    // Bottom line (stops at hand edge)
    canvas.drawLine(const Offset(78, 38), const Offset(48, 38), paint);
    // Left line (stops at thumb)
    canvas.drawLine(const Offset(32, 8), const Offset(32, 23), paint);

    // Small dash at top-right of banknote
    canvas.drawLine(const Offset(66, 12), const Offset(72, 12), paint);

    // Dollar sign '$' inside center of banknote (centered around x=55, y=23)
    const textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$',
        style: textStyle.copyWith(color: color, fontFamily: 'Outfit'),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(48, 12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

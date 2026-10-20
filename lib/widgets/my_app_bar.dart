import 'package:flutter/material.dart';

import '../data/dummy/dummy_cart.dart';
import '../pages/cart_page.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  // Jumlah seluruh produk di keranjang (untuk badge)
  int get _totalItem => cartItems.fold(0, (sum, item) => sum + item.jumlah);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      title: Row(
        children: [
          // Search Bar
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  // fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Tombol Chat
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Fitur chat segera hadir'),
                    behavior: SnackBarBehavior.floating,
                    // margin bawah agar tidak tertutup navbar melayang
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 100),
                  ),
                );
            },
            icon: const Icon(Icons.chat_bubble_outline),
          ),

          // Tombol Keranjang (buka CartPage, badge update otomatis)
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            icon: ValueListenableBuilder<int>(
              valueListenable: cartVersion,
              builder: (context, _, __) => Badge(
                isLabelVisible: _totalItem > 0,
                label: Text('$_totalItem'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'data/dummy/dummy_cart.dart';
import 'pages/cart_page.dart';
import 'pages/feeds_screen.dart';
import 'pages/home_screen.dart';
import 'pages/login_screen.dart';
import 'pages/mall_screen.dart';
import 'pages/profile_screen.dart';
import 'pages/transactions_screen.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  // =========================
  // TEMA
  // =========================
  ThemeData _lightTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      );

  ThemeData _darkTheme() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeMode.system, // ikut setting sistem
      home: const LoginScreen(), // ⬅️ entry point
    );
  }
}

// =============================================================
// NAVIGATION SHELL (setelah user login)
// =============================================================
class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  // `const` list → widget tidak di-rebuild ulang tiap setState
  static const List<Widget> _pages = [
    HomeScreen(),
    FeedsScreen(),
    MallScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  bool _showNavigationBar = true;

  // Jumlah seluruh produk di keranjang (untuk badge)
  int get _totalItemKeranjang =>
      cartItems.fold(0, (sum, item) => sum + item.jumlah);

  void _handleScroll(ScrollNotification notification) {
    if (notification is! UserScrollNotification) return;

    if (notification.direction == ScrollDirection.reverse) {
      // scroll ke bawah → sembunyikan navbar
      if (_showNavigationBar) {
        setState(() => _showNavigationBar = false);
      }
    } else if (notification.direction == ScrollDirection.forward) {
      // scroll ke atas → tampilkan navbar
      if (!_showNavigationBar) {
        setState(() => _showNavigationBar = true);
      }
    }
  }

  void _onDestinationSelected(int index) {
    setState(() => currentPageIndex = index);
  }

  // Buka halaman keranjang
  void _bukaKeranjang() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScroll(notification);
          return false;
        },
        child: Stack(
          children: [
            _pages[currentPageIndex],

            // Tombol keranjang (di atas navbar, ikut animasi sembunyi)
            Positioned(
              right: 20,
              bottom: 104,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                offset:
                    _showNavigationBar ? Offset.zero : const Offset(0, 3),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: _showNavigationBar ? 1.0 : 0.0,
                  child: FloatingActionButton(
                    heroTag: 'fab_keranjang',
                    onPressed: _bukaKeranjang,
                    // badge otomatis update saat isi keranjang berubah
                    child: ValueListenableBuilder<int>(
                      valueListenable: cartVersion,
                      builder: (context, _, __) => Badge(
                        isLabelVisible: _totalItemKeranjang > 0,
                        label: Text('$_totalItemKeranjang'),
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Navbar melayang
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                offset:
                    _showNavigationBar ? Offset.zero : const Offset(0, 1.5),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: _showNavigationBar ? 1.0 : 0.0,
                  child: _FloatingNavBar(
                    selectedIndex: currentPageIndex,
                    onDestinationSelected: _onDestinationSelected,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// WIDGET NAVBAR MELAYANG
// =============================================================
class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _FloatingNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(25),
      clipBehavior: Clip.antiAlias,
      color: cs.surface,
      child: NavigationBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        onDestinationSelected: onDestinationSelected,
        indicatorColor: cs.primary,
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.video_collection, color: Colors.white),
            icon: Icon(Icons.video_collection_outlined),
            label: 'Feeds',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.store, color: Colors.white),
            icon: Icon(Icons.store_outlined),
            label: 'Mall',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt, color: Colors.white),
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.list_alt_outlined),
            ),
            label: 'Transactions',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: Colors.white),
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
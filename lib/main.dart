import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'pages/feeds_sreen.dart';
import 'pages/home_screen.dart';
import 'pages/mall_sreen.dart';
import 'pages/profile_screen.dart';
import 'pages/transactions_screen.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Explicitly enable Material 3 (Optional for modern Flutter versions)
        useMaterial3: true,
        // Generate a full M3 ColorScheme from a single seed color
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  List<Widget> pages = [
    HomeScreen(),
    FeedsScreen(),
    MallScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  // kondisi navbar muncul atau tidak
  bool _showNavigationBar = true;

  // penentu kemunculan navbar
  void _handleScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      // jika scroll kebawah (layar ke atas)
      if (notification.direction == ScrollDirection.reverse) {
        // sembunyikan navbar
        setState(() {
          _showNavigationBar = false;
        });
      } else if (notification.direction == ScrollDirection.forward) {
        // jika scroll keatas (layar ke bawah)
        // tampilkan navbar
        setState(() {
          _showNavigationBar = true;
        });
      }
    }
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
            pages[currentPageIndex],
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                // Muncul: Offset(0, 0)
                // Hilang: geser ke bawah
                offset: _showNavigationBar ? Offset.zero : const Offset(0, 1.5),

                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  opacity: _showNavigationBar ? 1.0 : 0.0,

                  child: _navBar(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBar() {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(25),
      clipBehavior: Clip.antiAlias,
      child: NavigationBar(
        // ketika menu diklik
        onDestinationSelected: (int selectedMenu) {
          setState(() {
            // ubah urutan menu dan halaman
            currentPageIndex = selectedMenu;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        // menunjukkan menu mana yang aktif
        selectedIndex: currentPageIndex,
        // kumpulan menu
        destinations: const <Widget>[
          // menu-menu di bawah
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
            icon: Badge(label: Text('2'), child: Icon(Icons.list_alt_outlined)),
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

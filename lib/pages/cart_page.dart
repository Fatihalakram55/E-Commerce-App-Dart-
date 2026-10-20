import 'package:flutter/material.dart';

import '../data/dummy/dummy_cart.dart';
import '../data/models/model_cart.dart';

// 8500000 -> Rp8.500.000
String formatRupiah(int angka) {
  final s = angka.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return 'Rp$buffer';
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get totalItem => cartItems.fold(0, (sum, item) => sum + item.jumlah);
  int get totalHarga => cartItems.fold(0, (sum, item) => sum + item.subtotal);

  void _tambah(int index) {
    setState(() => cartItems[index].jumlah++);
    cartVersion.value++;
  }

  void _kurang(int index) {
    if (cartItems[index].jumlah > 1) {
      setState(() => cartItems[index].jumlah--);
      cartVersion.value++;
    }
  }

  void _hapus(int index) {
    setState(() => cartItems.removeAt(index));
    cartVersion.value++;
  }

  void _checkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checkout berhasil diproses')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Keranjang ($totalItem)')),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const _EmptyCart()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) => _CartItemCard(
                      item: cartItems[index],
                      onTambah: () => _tambah(index),
                      onKurang: () => _kurang(index),
                      onHapus: () => _hapus(index),
                    ),
                  ),
          ),
          _CartSummary(
            total: totalHarga,
            onCheckout: cartItems.isEmpty ? null : _checkout,
          ),
        ],
      ),
    );
  }
}

// =============================================================
// KARTU ITEM KERANJANG
// =============================================================
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onTambah;
  final VoidCallback onKurang;
  final VoidCallback onHapus;

  const _CartItemCard({
    required this.item,
    required this.onTambah,
    required this.onKurang,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(top: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: cs.surfaceContainerHighest,
                  child: Icon(Icons.image_not_supported_outlined,
                      color: cs.outline),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatRupiah(item.harga)} × ${item.jumlah}',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  Text(
                    'Subtotal: ${formatRupiah(item.subtotal)}',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _QuantityControl(
                    jumlah: item.jumlah,
                    onTambah: onTambah,
                    onKurang: onKurang,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: cs.error),
              tooltip: 'Hapus',
              onPressed: onHapus,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// KONTROL JUMLAH [-] n [+]
// =============================================================
class _QuantityControl extends StatelessWidget {
  final int jumlah;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const _QuantityControl({
    required this.jumlah,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.remove, color: cs.onPrimaryContainer),
            onPressed: jumlah > 1 ? onKurang : null,
          ),
          Text(
            '$jumlah',
            style: TextStyle(
              color: cs.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.add, color: cs.onPrimaryContainer),
            onPressed: onTambah,
          ),
        ],
      ),
    );
  }
}

// =============================================================
// RINGKASAN TOTAL + CHECKOUT
// =============================================================
class _CartSummary extends StatelessWidget {
  final int total;
  final VoidCallback? onCheckout;

  const _CartSummary({required this.total, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      elevation: 10,
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Belanja',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
              Text(
                formatRupiah(total),
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: onCheckout,
                  child: const Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// TAMPILAN KERANJANG KOSONG
// =============================================================
class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: cs.outline),
          const SizedBox(height: 8),
          Text('Keranjang kosong', style: TextStyle(color: cs.outline)),
        ],
      ),
    );
  }
}
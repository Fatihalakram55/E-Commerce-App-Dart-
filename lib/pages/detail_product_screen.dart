import 'package:flutter/material.dart';

import '../data/models/model_produk.dart';

class DetailProductScreen extends StatelessWidget {
  final Product product;

  const DetailProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // =========================
          // SLIVER APP BAR + GAMBAR PRODUK
          // =========================
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            elevation: 0,
            backgroundColor: cs.surface,
            foregroundColor: cs.onSurface,
            surfaceTintColor: Colors.transparent,
            leading: _circleIconButton(
              context,
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
            actions: [
              _circleIconButton(
                context,
                icon: Icons.favorite_border_rounded,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              _circleIconButton(
                context,
                icon: Icons.share_outlined,
                onTap: () {},
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: product.image,
                    child: Image.network(product.image, fit: BoxFit.cover),
                  ),
                  // Gradient tipis supaya ikon di atas tetap kebaca
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.3, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // KONTEN UTAMA
          // =========================
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 38, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      product.name,
                      maxLines: 2,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        letterSpacing: -0.3,
                        color: cs.onSurface,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Rating
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.orange.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.8',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '128 ulasan',
                          style: TextStyle(
                            color: cs.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Harga
                    Text(
                      'Rp ${product.price}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 12),
                    Divider(color: cs.outlineVariant, thickness: 1),
                    const SizedBox(height: 20),

                    // =========================
                    // DESKRIPSI
                    // =========================
                    Text(
                      'Deskripsi Produk',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Produk berkualitas dengan bahan terbaik dan '
                      'desain yang nyaman digunakan. Cocok untuk '
                      'kebutuhan sehari-hari dan memiliki kualitas '
                      'yang tahan lama.',
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.6,
                        color: cs.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 28),
                    Divider(color: cs.outlineVariant, thickness: 1),
                    const SizedBox(height: 20),

                    // =========================
                    // ULASAN
                    // =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ulasan Pembeli',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          'Lihat semua',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    _reviewItem(
                      context,
                      name: 'Andi',
                      rating: 5,
                      comment: 'Produknya bagus dan sesuai dengan deskripsi.',
                    ),

                    _reviewItem(
                      context,
                      name: 'Budi',
                      rating: 4,
                      comment: 'Barang bagus, pengiriman juga cepat.',
                    ),

                    _reviewItem(
                      context,
                      name: 'Siti',
                      rating: 5,
                      comment: 'Puas banget dengan produknya!',
                      isLast: true,
                    ),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // =========================
      // TOMBOL BAWAH
      // =========================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(top: BorderSide(color: cs.outlineVariant, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Keranjang
              SizedBox(
                width: 52,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk dimasukkan ke keranjang'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: cs.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: cs.outlineVariant),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),

              const SizedBox(width: 12),

              // Beli sekarang
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Melanjutkan ke pembelian'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Beli Sekarang',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tombol ikon bulat di atas gambar
  Widget _circleIconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Material(
        color: cs.surface.withOpacity(0.9),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, size: 18, color: cs.onSurface),
          ),
        ),
      ),
    );
  }

  // Widget ulasan
  Widget _reviewItem(
    BuildContext context, {
    required String name,
    required int rating,
    required String comment,
    bool isLast = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: cs.primaryContainer,
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: cs.onSurface,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  rating,
                  (index) => Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(
              fontSize: 13.5,
              color: cs.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

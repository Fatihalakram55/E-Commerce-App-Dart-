import 'package:flutter/material.dart';

import '../data/models/model_produk.dart';

class DetailProductScreen extends StatelessWidget {
  final Product product;

  const DetailProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // GAMBAR PRODUK
            // =========================
            Image.network(
              product.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            // =========================
            // INFORMASI PRODUK
            // =========================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 22),
                      const SizedBox(width: 5),
                      const Text(
                        '4.8',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(128 ulasan)',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Harga
                  Text(
                    'Rp ${product.price}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Divider(),

                  const SizedBox(height: 16),

                  // =========================
                  // DESKRIPSI
                  // =========================
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Produk berkualitas dengan bahan terbaik dan '
                    'desain yang nyaman digunakan. Cocok untuk '
                    'kebutuhan sehari-hari dan memiliki kualitas '
                    'yang tahan lama.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // ULASAN
                  // =========================
                  const Text(
                    'Ulasan Pembeli',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  _reviewItem(
                    name: 'Andi',
                    rating: 5,
                    comment: 'Produknya bagus dan sesuai dengan deskripsi.',
                  ),

                  _reviewItem(
                    name: 'Budi',
                    rating: 4,
                    comment: 'Barang bagus, pengiriman juga cepat.',
                  ),

                  _reviewItem(
                    name: 'Siti',
                    rating: 5,
                    comment: 'Puas banget dengan produknya!',
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      // =========================
      // TOMBOL BAWAH
      // =========================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Keranjang
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk dimasukkan ke keranjang'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Keranjang'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Beli sekarang
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Melanjutkan ke pembelian')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Beli Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget ulasan
  Widget _reviewItem({
    required String name,
    required int rating,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(child: Text(name[0])),

              const SizedBox(width: 10),

              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: List.generate(
              rating,
              (index) => const Icon(Icons.star, size: 18, color: Colors.orange),
            ),
          ),

          const SizedBox(height: 5),

          Text(comment),
        ],
      ),
    );
  }
}

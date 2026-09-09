import 'package:flutter/material.dart';

import '../data/dummy/dummy_kategori.dart';
import '../data/dummy/dummy_produk.dart';
import '../data/models/model_produk.dart';
import '../widgets/my_app_bar.dart';
import 'detail_product_screen.dart';

// =========================
// HOME PAGE
// =========================

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Data kategori
  final List<Category> categories = [
    Category(name: 'Elektronik', image: 'https://picsum.photos/100?random=1'),
    Category(name: 'Fashion', image: 'https://picsum.photos/100?random=2'),
    Category(name: 'Makanan', image: 'https://picsum.photos/100?random=3'),
    Category(name: 'Olahraga', image: 'https://picsum.photos/100?random=4'),
    Category(name: 'Buku', image: 'https://picsum.photos/100?random=5'),
    Category(name: 'Gaming', image: 'https://picsum.photos/100?random=6'),
  ];

  // Data produk
  final List<Product> products = [
    Product(
      name: 'Wireless Headphone',
      image: 'https://picsum.photos/300/300?random=10',
      price: 250000,
    ),
    Product(
      name: 'Smart Watch',
      image: 'https://picsum.photos/300/300?random=11',
      price: 450000,
    ),
    Product(
      name: 'Running Shoes',
      image: 'https://picsum.photos/300/300?random=12',
      price: 350000,
    ),
    Product(
      name: 'Backpack',
      image: 'https://picsum.photos/300/300?random=13',
      price: 180000,
    ),
    Product(
      name: 'Mechanical Keyboard',
      image: 'https://picsum.photos/300/300?random=14',
      price: 650000,
    ),
    Product(
      name: 'Gaming Mouse',
      image: 'https://picsum.photos/300/300?random=15',
      price: 300000,
    ),
    Product(
      name: 'T-Shirt',
      image: 'https://picsum.photos/300/300?random=16',
      price: 120000,
    ),
    Product(
      name: 'Coffee Maker',
      image: 'https://picsum.photos/300/300?random=17',
      price: 550000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),

      // =========================
      // BODY
      // =========================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================
              // KATEGORI
              // ================
              Text(
                'Kategori',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: 115,
                child: ListView.builder(
                  // menentukan arah scroll
                  scrollDirection: Axis.horizontal,
                  // menentukan jumlah item
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Menyesuaikan tinggi kolom dengan isinya
                        children: [
                          // Kotak Berbayang untuk Gambar
                          Container(
                            width: 80, // Tentukan lebar kotak
                            height: 80, // Tentukan tinggi kotak
                            decoration: BoxDecoration(
                              color: Colors.white, // Warna latar belakang kotak
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // Membuat sudut kotak melengkung (radius)
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    0.1,
                                  ), // Warna bayangan tipis
                                  blurRadius: 8, // Efek blur bayangan
                                  offset: const Offset(
                                    0,
                                    4,
                                  ), // Posisi bayangan (x, y)
                                ),
                              ],
                            ),
                            // Alignment.center memastikan gambar berada tepat di tengah kotak
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Opsional: radius untuk gambar jika diperlukan
                              child: Image.network(
                                category.image,
                                width:
                                    48, // Ukuran gambar lebih kecil dari Container agar tidak memenuhi kotak
                                height:
                                    48, // Ukuran gambar lebih kecil dari Container agar tidak memenuhi kotak
                                fit: BoxFit
                                    .contain, // Memastikan gambar proporsional di dalam area center
                              ),
                            ),
                          ),

                          // Jarak antara kotak gambar dan teks nama
                          const SizedBox(height: 8),

                          // Teks Nama Kategori di Bawah Kotak
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis, // Memotong teks dengan (...) jika terlalu panjang
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // ================
              // PRODUK TERBARU
              // ================
              SizedBox(height: 20),
              Text(
                'Produk Terbaru',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                // menentukan jumlah item
                itemCount: products.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  // menentukan total kolom
                  crossAxisCount: 2,
                  // menentukan jarak samping horizontal
                  crossAxisSpacing: 12,
                  // menentukan jarak atas dan bawah
                  mainAxisSpacing: 12,
                  // menentukan rasio antar item
                  // childAspectRatio: 0.68,
                ),

                // untuk membuat konten tiam item
                // index menyimpan posisi item
                itemBuilder: (context, index) {
                  final product = products[index];
                  // masukkan produk ke dalam item sebagai argument
                  return _productItemView(product, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // ITEM VIEW
  // memiliki parameter product untuk menampung produk
  // =========================
  Widget _productItemView(Product product, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // pindah ke halaman detail dengan mengirimkan produk
              builder: (context) => DetailProductScreen(product: product),
            ),
          );
          // ketika di klik
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: Text(product.name),
          //       content: Text(product.name),
          //       actions: [
          //         TextButton(
          //           child: Text('Close'),
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //         ),
          //       ],
          //     );
          //   },
          // );
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk
            Expanded(
              child: Image.network(
                product.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Informasi produk
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Rp ${product.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text('4.8'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mysample/widgets/my_app_bar.dart';

class MallScreen extends StatelessWidget {
  const MallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7, // agar card lebih tinggi
          ),
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return StoreCard(store: store);
          },
        ),
      ),
    );
  }
}

// Model data toko
class Store {
  final String name;
  final String location;
  final double rating;
  final String imageUrl; // bisa pakai asset atau network
  final String category; // misal: Fashion, Elektronik, dll

  Store({
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.category,
  });
}

// Data dummy
final List<Store> stores = [
  Store(
    name: 'Toko Fashion A',
    location: 'Lantai 1, Blok A',
    rating: 4.5,
    imageUrl: 'https://picsum.photos/200/200?random=1',
    category: 'Fashion',
  ),
  Store(
    name: 'Elektronik B',
    location: 'Lantai 2, Blok B',
    rating: 4.2,
    imageUrl: 'https://picsum.photos/200/200?random=2',
    category: 'Elektronik',
  ),
  Store(
    name: 'Toko Sepatu C',
    location: 'Lantai 1, Blok C',
    rating: 4.7,
    imageUrl: 'https://picsum.photos/200/200?random=3',
    category: 'Sepatu',
  ),
  Store(
    name: 'Makanan D',
    location: 'Lantai 3, Food Court',
    rating: 4.0,
    imageUrl: 'https://picsum.photos/200/200?random=4',
    category: 'Kuliner',
  ),
  Store(
    name: 'Aksesoris E',
    location: 'Lantai 2, Blok D',
    rating: 3.8,
    imageUrl: 'https://picsum.photos/200/200?random=5',
    category: 'Aksesoris',
  ),
  Store(
    name: 'Toko Buku F',
    location: 'Lantai 3, Blok E',
    rating: 4.9,
    imageUrl: 'https://picsum.photos/200/200?random=6',
    category: 'Buku',
  ),
];

// Widget card untuk setiap toko
class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                store.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),
          ),
          // Info toko
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        store.location,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      store.rating.toString(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        store.category,
                        style: TextStyle(fontSize: 8, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
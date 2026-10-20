import 'package:flutter/material.dart';

import '../data/dummy/dummy_produk.dart';
import '../data/models/model_feeds.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final List<String> _categories = [
    'Semua',
    'Fashion',
    'Elektronik',
    'Rumah',
    'Olahraga',
  ];
  int _selectedCategory = 0;

  late final List<FeedPost> _posts;

  static const _stores = [
    'Gadget Corner',
    'Toko Jaya',
    'Sport Station',
    'Rumah Nyaman',
  ];
  static const _times = ['2 jam lalu', '5 jam lalu', '1 hari lalu', '2 hari lalu'];
  static const _captions = [
    'Stok terbatas, buruan checkout sebelum kehabisan!',
    'Kualitas terbaik dengan harga bersahabat.',
    'Best seller minggu ini, sudah banyak yang pakai.',
    'Gratis ongkir untuk pembelian hari ini.',
  ];

  @override
  void initState() {
    super.initState();
    _posts = List.generate(products.length, (i) {
      return FeedPost(
        product: products[i],
        storeName: _stores[i % _stores.length],
        timeAgo: _times[i % _times.length],
        caption: _captions[i % _captions.length],
        likes: 50 + i * 37,
        comments: 5 + i * 4,
      );
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  String _formatPrice(num price) {
    final s = price.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return 'Rp $buffer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feeds',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          // padding bawah besar agar tidak tertutup navbar melayang
          padding: const EdgeInsets.only(bottom: 110),
          children: [
            _buildCategories(),
            _buildPromoBanner(),
            ..._posts.map(_buildPostCard),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ChoiceChip(
            label: Text(_categories[index]),
            selected: _selectedCategory == index,
            onSelected: (_) => setState(() => _selectedCategory = index),
          );
        },
      ),
    );
  }

  Widget _buildPromoBanner() {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.all(20),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [cs.primary, cs.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flash Sale!',
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Diskon hingga 50% hari ini',
                  style: TextStyle(color: cs.onPrimary.withAlpha(200)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.surface,
                    foregroundColor: cs.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Lihat Sekarang'),
                ),
              ],
            ),
          ),
          Icon(Icons.local_offer, size: 64, color: cs.onPrimary.withAlpha(60)),
        ],
      ),
    );
  }

  Widget _buildProductImage(String url) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) => Container(
          color: cs.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image,
            size: 48,
            color: cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(FeedPost post) {
    final cs = Theme.of(context).colorScheme;
    final product = post.product;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: cs.primaryContainer,
              foregroundColor: cs.onPrimaryContainer,
              child: Text(post.storeName[0]),
            ),
            title: Text(
              post.storeName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(post.timeAgo),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),

          _buildProductImage(product.image),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? cs.primary : null,
                  ),
                  onPressed: () => setState(() => post.isLiked = !post.isLiked),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: post.isSaved ? cs.primary : null,
                  ),
                  onPressed: () => setState(() => post.isSaved = !post.isSaved),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${post.likes + (post.isLiked ? 1 : 0)} suka · ${post.comments} komentar',
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(post.caption),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatPrice(product.price),
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} ditambahkan ke keranjang'),
                      ),
                    );
                  },
                  child: const Text('Beli'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
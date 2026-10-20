import 'model_produk.dart';

class FeedPost {
  final Product product;
  final String storeName;
  final String timeAgo;
  final String caption;
  final int likes;
  final int comments;
  bool isLiked;
  bool isSaved;

  FeedPost({
    required this.product,
    required this.storeName,
    required this.timeAgo,
    required this.caption,
    required this.likes,
    required this.comments,
    this.isLiked = false,
    this.isSaved = false,
  });
}
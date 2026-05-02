class Review {
  final String id;
  final String propertyId;
  final String propertyAddress;
  final String authorName;
  final String authorTrade;
  final String text;
  final int rating;
  final List<String> imageUrls;
  final int upvotes;
  final int commentsCount;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.propertyId,
    required this.propertyAddress,
    required this.authorName,
    required this.authorTrade,
    required this.text,
    required this.rating,
    required this.imageUrls,
    required this.upvotes,
    required this.commentsCount,
    required this.createdAt,
  });
}

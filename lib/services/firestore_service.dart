import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import '../models/property.dart';
import 'mock_data_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<List<Review>> streamReviews() {
    try {
      return _db
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                return Review(
                  id: doc.id,
                  propertyId: data['propertyId'] ?? '',
                  propertyAddress: data['propertyAddress'] ?? 'Unknown Address',
                  authorName: data['authorName'] ?? 'Unknown',
                  authorTrade: data['authorTrade'] ?? '',
                  text: data['text'] ?? '',
                  rating: data['rating'] ?? 0,
                  imageUrls: List<String>.from(data['imageUrls'] ?? []),
                  upvotes: data['upvotes'] ?? 0,
                  commentsCount: data['commentsCount'] ?? 0,
                  createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                );
              }).toList())
          .handleError((error) {
        // Fallback to mock data if Firebase config is missing or invalid
        print('Firebase stream error, falling back to mock reviews: $error');
        return MockDataService.reviews;
      });
    } catch (e) {
      return Stream.value(MockDataService.reviews);
    }
  }

  static Stream<List<Property>> streamProperties() {
    try {
      return _db.collection('properties').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) {
            final data = doc.data();
            return Property(
              id: doc.id,
              address: data['address'] ?? 'Unknown Address',
              lat: (data['lat'] as num?)?.toDouble() ?? 0.0,
              lng: (data['lng'] as num?)?.toDouble() ?? 0.0,
              averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
            );
          }).toList())
          .handleError((error) {
        // Fallback to mock data
        print('Firebase stream error, falling back to mock properties: $error');
        return MockDataService.properties;
      });
    } catch (e) {
      return Stream.value(MockDataService.properties);
    }
  }

  static Future<void> addReview(Review review) async {
    try {
      await _db.collection('reviews').doc(review.id).set({
        'propertyId': review.propertyId,
        'propertyAddress': review.propertyAddress,
        'authorName': review.authorName,
        'authorTrade': review.authorTrade,
        'text': review.text,
        'rating': review.rating,
        'imageUrls': review.imageUrls,
        'upvotes': review.upvotes,
        'commentsCount': review.commentsCount,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Firebase add review error: $e');
    }
  }
}

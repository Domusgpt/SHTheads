import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';
import '../models/property.dart';
import '../models/chat.dart';
import 'mock_data_service.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<List<Review>> streamReviews({String searchQuery = '', String category = 'All'}) {
    try {
      return _db
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
             var reviews = snapshot.docs.map((doc) {
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
              }).toList();

              if (category != 'All') {
                 // For MVP, if it's a danger tag, we filter by bad rating (<= 2).
                 // Otherwise we filter by trade.
                 if (category.contains('Bad') || category.contains('No Permits')) {
                    reviews = reviews.where((r) => r.rating <= 2).toList();
                 } else {
                    reviews = reviews.where((r) => r.authorTrade.toLowerCase().contains(category.toLowerCase())).toList();
                 }
              }

              if (searchQuery.isNotEmpty) {
                 final lowerQuery = searchQuery.toLowerCase();
                 reviews = reviews.where((r) =>
                    r.propertyAddress.toLowerCase().contains(lowerQuery) ||
                    r.text.toLowerCase().contains(lowerQuery) ||
                    r.authorName.toLowerCase().contains(lowerQuery)
                 ).toList();
              }

              return reviews;
          })
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

  // --- Messaging Logic ---

  static Stream<List<ChatRoom>> streamInbox(String currentUserId) {
    try {
      return _db
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastUpdatedAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                return ChatRoom(
                  id: doc.id,
                  participants: List<String>.from(data['participants'] ?? []),
                  lastMessage: data['lastMessage'] ?? '',
                  lastUpdatedAt: (data['lastUpdatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                );
              }).toList());
    } catch (e) {
      print('Inbox error: $e');
      return Stream.value([]);
    }
  }

  static Stream<List<ChatMessage>> streamChatMessages(String roomId) {
    try {
      return _db
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                return ChatMessage(
                  id: doc.id,
                  senderId: data['senderId'] ?? '',
                  senderName: data['senderName'] ?? 'Unknown',
                  text: data['text'] ?? '',
                  createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
                );
              }).toList());
    } catch (e) {
      print('Messages error: $e');
      return Stream.value([]);
    }
  }

  static Future<void> sendMessage(String roomId, String senderId, String senderName, String text) async {
    try {
      final batch = _db.batch();
      final roomRef = _db.collection('chats').doc(roomId);
      final msgRef = roomRef.collection('messages').doc();

      batch.set(msgRef, {
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      batch.update(roomRef, {
        'lastMessage': text,
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      print('Send message error: $e');
    }
  }

  static Future<String> getOrCreateChatRoom(String currentUserId, String targetUserId) async {
    final roomId = currentUserId.compareTo(targetUserId) < 0
      ? '${currentUserId}_$targetUserId'
      : '${targetUserId}_$currentUserId';

    final roomRef = _db.collection('chats').doc(roomId);
    final doc = await roomRef.get();

    if (!doc.exists) {
      await roomRef.set({
        'participants': [currentUserId, targetUserId],
        'lastMessage': 'Chat started',
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      });
    }

    return roomId;
  }
}

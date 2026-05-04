import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastUpdatedAt;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastUpdatedAt,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.createdAt,
  });
}

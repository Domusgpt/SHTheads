import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/chat.dart';
import '../../theme/app_theme.dart';
import '../../widgets/knife_transition.dart';
import '../../widgets/reactive_tile.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In MVP, we mock the current user ID if auth is skipped, otherwise use real uid
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.currentUserId ?? 'mock_user_1';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.darkBackground,
            child: const Text('Direct Messages', style: TextStyle(color: AppTheme.accentOrange, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder<List<ChatRoom>>(
              stream: FirestoreService.streamInbox(currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.accentOrange));
                }

                final rooms = snapshot.data ?? [];

                if (rooms.isEmpty) {
                  return const Center(child: Text('No messages yet. Reach out to a Pro from the Feed!', style: TextStyle(color: AppTheme.textSecondary)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    // Find the other participant's ID
                    final otherUserId = room.participants.firstWhere((id) => id != currentUserId, orElse: () => 'Unknown');

                    return KnifeTransition(
                      delay: Duration(milliseconds: 100 * index),
                      initialOffset: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReactiveTile(
                          height: 90,
                          onTap: () => context.push('/tradesman/chat/${room.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppTheme.metallicLight,
                                  child: Icon(Icons.person, color: AppTheme.textSecondary),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Pro: $otherUserId', style: const TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text(
                                        room.lastMessage,
                                        style: const TextStyle(color: AppTheme.textSecondary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String roomId;
  const ChatDetailScreen({super.key, required this.roomId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _msgController = TextEditingController();

  void _send() async {
    if (_msgController.text.trim().isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.currentUserId ?? 'mock_user_1';

    await FirestoreService.sendMessage(widget.roomId, currentUserId, 'Sparky Dan (Me)', _msgController.text.trim());
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthProvider>().currentUserId ?? 'mock_user_1';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat', style: TextStyle(color: AppTheme.accentOrange)),
        backgroundColor: AppTheme.darkSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentOrange),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: FirestoreService.streamChatMessages(widget.roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.accentOrange));
                }

                final messages = snapshot.data ?? [];

                return ListView.builder(
                  reverse: true, // Newest at bottom
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == currentUserId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isMe ? AppTheme.accentOrange.withOpacity(0.8) : AppTheme.darkSurface,
                          borderRadius: BorderRadius.circular(16).copyWith(
                            bottomRight: isMe ? const Radius.circular(0) : null,
                            bottomLeft: !isMe ? const Radius.circular(0) : null,
                          ),
                          border: Border.all(color: isMe ? AppTheme.accentOrange : AppTheme.metallicLight),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(color: isMe ? Colors.white : AppTheme.textPrimary),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: AppTheme.darkSurface,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(color: AppTheme.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppTheme.metallicLight),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.accentOrange,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

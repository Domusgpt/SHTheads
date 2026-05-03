import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reactive_tile.dart';
import '../../widgets/search_filter_header.dart';
import '../../widgets/knife_transition.dart';
import '../../models/review.dart';
import '../../services/firestore_service.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentOrange,
        onPressed: () => _showAddReviewDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          const SearchFilterHeader(),
          Expanded(
            child: StreamBuilder<List<Review>>(
              stream: FirestoreService.streamReviews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppTheme.accentOrange));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }

                final reviews = snapshot.data ?? [];

                if (reviews.isEmpty) {
                  return const Center(child: Text('No reviews found.', style: TextStyle(color: AppTheme.textSecondary)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                  return KnifeTransition(
                    delay: Duration(milliseconds: 100 * index), // Staggered knife unsheathing
                    initialOffset: 150.0 + (index * 20.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ReactiveTile(
                        height: 320, // Increased height for rich media and actions
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header (Address + Star Rating)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    review.propertyAddress,
                                    style: const TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.bold, fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < review.rating ? Icons.star : Icons.star_border,
                                      color: AppTheme.accentYellow,
                                      size: 18,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Rich Media Placeholder
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.metallicLight),
                              ),
                              child: const Center(
                                child: Icon(Icons.broken_image, color: AppTheme.textSecondary, size: 36),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Text Content
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showReviewDetail(context, review),
                                child: Text(
                                  '"${review.text}"',
                                  style: const TextStyle(color: AppTheme.textPrimary, fontStyle: FontStyle.italic),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            // Author
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text('- ${review.authorName} (${review.authorTrade})', style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                            ),

                            const Divider(color: AppTheme.metallicLight, height: 24),

                            // Social Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildActionBtn(Icons.thumb_up_outlined, review.upvotes.toString()),
                                _buildActionBtn(Icons.chat_bubble_outline, review.commentsCount.toString()),
                                _buildActionBtn(Icons.share_outlined, 'Share'),
                              ],
                            )
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

  Widget _buildActionBtn(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 20),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      ],
    );
  }

  void _showReviewDetail(BuildContext context, Review review) {
    showDialog(
      context: context,
      builder: (context) => _ReviewDetailDialog(review: review),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddReviewDialog(),
    );
  }
}

class _ReviewDetailDialog extends StatelessWidget {
  final Review review;

  const _ReviewDetailDialog({required this.review});

  @override
  Widget build(BuildContext context) {
    return KnifeTransition(
      initialOffset: 200, // Slide up from bottom
      child: AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(review.propertyAddress, style: const TextStyle(color: AppTheme.accentOrange)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: List.generate(5, (starIndex) {
                  return Icon(
                    starIndex < review.rating ? Icons.star : Icons.star_border,
                    color: AppTheme.accentYellow,
                    size: 24,
                  );
                }),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.metallicLight),
                ),
                child: const Center(
                  child: Icon(Icons.broken_image, color: AppTheme.textSecondary, size: 64),
                ),
              ),
              const SizedBox(height: 16),
              Text('"${review.text}"', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
              const SizedBox(height: 24),
              const Divider(color: AppTheme.metallicLight),
              const Text('Comments', style: TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (review.commentsCount == 0)
                const Text('No comments yet.', style: TextStyle(color: AppTheme.textSecondary))
              else
                const Text('Mock Comment: Yeah, this guy tried the same thing with me last month.', style: TextStyle(color: AppTheme.textPrimary, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.accentYellow)),
          ),
        ],
      ),
    );
  }
}

class AddReviewDialog extends StatefulWidget {
  const AddReviewDialog({super.key});

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  bool _imageSelected = false;

  void _simulateImagePicker() async {
    // Tomorrow: Use image_picker and upload to FirebaseStorage/GCS
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _imageSelected = true);
  }

  @override
  Widget build(BuildContext context) {
    return KnifeTransition(
      initialOffset: -200, // Drop in from top like a guillotine
      child: AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Add Review', style: TextStyle(color: AppTheme.accentOrange)),
        content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: AppTheme.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
              ),
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Review / Warning',
                labelStyle: TextStyle(color: AppTheme.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
              ),
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _simulateImagePicker,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: AppTheme.metallicLight, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _imageSelected ? Icons.check_circle : Icons.camera_alt,
                        color: _imageSelected ? AppTheme.accentYellow : AppTheme.textSecondary,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _imageSelected ? 'Image Ready for GCS Upload' : 'Tap to select evidence photo',
                        style: TextStyle(color: _imageSelected ? AppTheme.accentYellow : AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
        ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

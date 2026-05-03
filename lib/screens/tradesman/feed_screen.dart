import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reactive_tile.dart';
import '../../widgets/search_filter_header.dart';
import '../../widgets/knife_transition.dart';
import '../../models/review.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../providers/filter_provider.dart';

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../services/storage_service.dart';
import '../../services/geocoding_service.dart';
import '../../models/property.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();
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
              stream: FirestoreService.streamReviews(
                searchQuery: filterProvider.searchQuery,
                category: filterProvider.selectedCategory,
              ),
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
  final _addressController = TextEditingController();
  final _textController = TextEditingController();
  int _rating = 1;

  bool _isSubmitting = false;
  Uint8List? _imageBytes;
  String? _fileExtension;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _fileExtension = image.name.split('.').last.toLowerCase();
        if (_fileExtension == null || _fileExtension!.isEmpty) {
          _fileExtension = 'png';
        }
      });
    }
  }

  Future<void> _submitReview() async {
    if (_addressController.text.isEmpty || _textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Address and Review are required')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 1. Geocode Address
      final latLng = await GeocodingService.geocodeAddress(_addressController.text);
      if (latLng == null) {
        throw Exception('Could not locate address on map. Please verify.');
      }

      // 2. Upload Image (if selected)
      List<String> imageUrls = [];
      if (_imageBytes != null && _fileExtension != null) {
        final url = await StorageService.uploadReviewImage(_imageBytes!, _fileExtension!);
        if (url != null) imageUrls.add(url);
      }

      // 3. Create Property Doc (or we'd update existing in a full prod app)
      final propertyId = const Uuid().v4();
      final newProperty = Property(
        id: propertyId,
        address: _addressController.text,
        lat: latLng.latitude,
        lng: latLng.longitude,
        averageRating: _rating.toDouble(),
      );
      // We would have a FirestoreService.addProperty here, but adding review is enough for MVP feed

      // 4. Create Review Doc
      final reviewId = const Uuid().v4();
      final newReview = Review(
        id: reviewId,
        propertyId: propertyId,
        propertyAddress: _addressController.text,
        authorName: 'Live User',
        authorTrade: 'Verified Trade',
        text: _textController.text,
        rating: _rating,
        imageUrls: imageUrls,
        upvotes: 0,
        commentsCount: 0,
        createdAt: DateTime.now(),
      );

      await FirestoreService.addReview(newReview);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Review published successfully!'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _textController.dispose();
    super.dispose();
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
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                labelStyle: TextStyle(color: AppTheme.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Review / Warning',
                labelStyle: TextStyle(color: AppTheme.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rating:', style: TextStyle(color: AppTheme.textSecondary)),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: AppTheme.accentYellow,
                      ),
                      onPressed: () => setState(() => _rating = index + 1),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: AppTheme.metallicLight, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                  image: _imageBytes != null
                      ? DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken))
                      : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _imageBytes != null ? Icons.check_circle : Icons.camera_alt,
                        color: _imageBytes != null ? AppTheme.accentYellow : AppTheme.textSecondary,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _imageBytes != null ? 'Image Selected' : 'Tap to select evidence photo',
                        style: TextStyle(color: _imageBytes != null ? AppTheme.accentYellow : AppTheme.textSecondary),
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
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
        ),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitReview,
            child: _isSubmitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

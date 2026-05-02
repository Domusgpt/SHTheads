import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reactive_tile.dart';
import '../../widgets/search_filter_header.dart';
import '../../widgets/knife_transition.dart';

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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) {
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
                              Text(
                                "Property Address ${index + 1}",
                                style: const TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    starIndex < 1 ? Icons.star : Icons.star_border,
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
                          const Expanded(
                            child: Text(
                              '"Terrible experience. The client refused to pay for the drywall patching after I fixed the stud they broke. Required 3 trips and constant haggling. Avoid if possible."',
                              style: TextStyle(color: AppTheme.textPrimary, fontStyle: FontStyle.italic),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Author
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Text('- Sparky Dan (Electrician)', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                          ),

                          const Divider(color: AppTheme.metallicLight, height: 24),

                          // Social Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildActionBtn(Icons.thumb_up_outlined, '24'),
                              _buildActionBtn(Icons.chat_bubble_outline, '5'),
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

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddReviewDialog(),
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

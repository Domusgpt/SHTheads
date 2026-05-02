import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reactive_tile.dart';

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ReactiveTile(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Property Address ${index + 1}",
                          style: const TextStyle(color: AppTheme.accentOrange, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.metallicLight),
                          ),
                          child: const Text("1.0/5", style: TextStyle(color: AppTheme.accentYellow, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Expanded(
                      child: Text(
                        '"Terrible experience. The client refused to pay for the drywall patching after I fixed the stud they broke. Required 3 trips and constant haggling. Avoid if possible."',
                        style: TextStyle(color: AppTheme.textPrimary, fontStyle: FontStyle.italic),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Text('- Sparky Dan (Electrician)', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
    return AlertDialog(
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
    );
  }
}

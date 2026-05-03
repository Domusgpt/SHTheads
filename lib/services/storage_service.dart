import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final Uuid _uuid = const Uuid();

  static Future<String?> uploadReviewImage(Uint8List fileBytes, String fileExtension) async {
    try {
      // Create a unique file name
      final fileName = '${_uuid.v4()}.$fileExtension';
      final ref = _storage.ref().child('reviews/$fileName');

      // Upload bytes
      final uploadTask = await ref.putData(fileBytes, SettableMetadata(contentType: 'image/$fileExtension'));

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Storage upload error: $e');
      return null;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  // Free OpenStreetMap Nominatim API
  static Future<LatLng?> geocodeAddress(String address) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(address)}&format=json&limit=1');

      final response = await http.get(url, headers: {
        'User-Agent': 'SHTheadsApp/1.0',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
      return null;
    } catch (e) {
      print('Geocoding error: $e');
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reactive_tile.dart';
import '../../widgets/search_filter_header.dart';
import '../../models/property.dart';
import '../../services/firestore_service.dart';
import '../../models/review.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _mapCenter = const LatLng(39.7817, -89.6501); // Centered on mock data

  void _showComingSoon() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Hold Your Horses!', style: TextStyle(color: AppTheme.accentOrange)),
        content: const Text('This feature is still under construction. Check back later!', style: TextStyle(color: AppTheme.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: AppTheme.accentYellow)),
          ),
        ],
      ),
    );
  }

  void _showLoginStub() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Tradesman Login', style: TextStyle(color: AppTheme.accentOrange)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: AppTheme.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
              ),
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: AppTheme.textSecondary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
              ),
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text('Login functionality coming soon in V2!', style: TextStyle(color: AppTheme.accentYellow, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHTheads'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.accentOrange),
          onPressed: _showComingSoon,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login, color: AppTheme.accentOrange),
            onPressed: _showLoginStub,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map Background
          FlutterMap(
            options: MapOptions(
              initialCenter: _mapCenter,
              initialZoom: 15.0,
            ),
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  -1,  0,  0, 0, 255, // Invert R
                   0, -1,  0, 0, 255, // Invert G
                   0,  0, -1, 0, 255, // Invert B
                   0,  0,  0, 1,   0, // Alpha
                ]),
                child: ColorFiltered(
                  // Add a slight orange tint to fit the industrial theme after inverting
                  colorFilter: ColorFilter.mode(
                    Colors.orange.withOpacity(0.1),
                    BlendMode.colorBurn
                  ),
                  child: TileLayer(
                    // Using standard OSM for MVP, but a dark styled map would be better in prod
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.shtheads.app',
                  ),
                ),
              ),
              StreamBuilder<List<Property>>(
                stream: FirestoreService.streamProperties(),
                builder: (context, snapshot) {
                  final properties = snapshot.data ?? [];
                  return MarkerLayer(
                    markers: properties.map((prop) {
                      return Marker(
                        point: LatLng(prop.lat, prop.lng),
                        width: 50,
                        height: 50,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: _showComingSoon, // In the future, this would scroll to the specific card
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.darkSurface,
                                shape: BoxShape.circle,
                                border: Border.all(color: prop.averageRating < 2.5 ? AppTheme.accentOrange : AppTheme.accentYellow, width: 2),
                                boxShadow: [
                                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 2))
                                ]
                              ),
                              child: Center(
                                child: Text(
                                  prop.averageRating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: prop.averageRating < 2.5 ? AppTheme.accentOrange : AppTheme.accentYellow,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              ),
            ],
          ),

          // UI Overlay for live properties and reviews using Reactive Tiles
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: SizedBox(
              height: 180,
              child: StreamBuilder<List<Review>>(
                stream: FirestoreService.streamReviews(),
                builder: (context, reviewSnapshot) {
                  if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.accentOrange));
                  }
                  final reviews = reviewSnapshot.data ?? [];
                  if (reviews.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return StreamBuilder<List<Property>>(
                    stream: FirestoreService.streamProperties(),
                    builder: (context, propSnapshot) {
                      final properties = propSnapshot.data ?? [];

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final prop = properties[index];
                          // Find a review associated with this property from the live stream
                          final associatedReview = reviews.firstWhere(
                            (r) => r.propertyId == prop.id,
                            orElse: () => reviews.first, // fallback
                          );
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _buildMockReviewCard(
                              title: prop.address,
                              rating: "${prop.averageRating}/5",
                              comment: associatedReview.text,
                              author: associatedReview.authorName,
                            ),
                          );
                        },
                      );
                    }
                  );
                }
              ),
            ),
          ),

          // Search and Filter Header (Top Overlay)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SearchFilterHeader(),
          ),
        ],
      ),
    );
  }

  Widget _buildMockReviewCard({required String title, required String rating, required String comment, required String author}) {
    return ReactiveTile(
      width: 300,
      height: 180,
      onTap: _showComingSoon,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.accentOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.metallicLight),
                  ),
                  child: Text(
                    rating,
                    style: const TextStyle(color: AppTheme.accentYellow, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                '"$comment"',
                style: const TextStyle(color: AppTheme.textPrimary, fontStyle: FontStyle.italic),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '- $author',
                style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

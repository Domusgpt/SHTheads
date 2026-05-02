import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../widgets/reactive_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Coordinates based on "E Bergen Ave" reference (approximate coordinates for demo)
  // We'll use a generic location in NJ for demonstration
  final LatLng _mapCenter = const LatLng(40.8872, -74.0326); // Hackensack area, Bergen Ave

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
              initialZoom: 18.0, // High zoom to see houses like in the image
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
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(40.88725, -74.0326),
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.home_repair_service, color: AppTheme.accentOrange, size: 40),
                  ),
                  Marker(
                    point: const LatLng(40.88715, -74.0325),
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.warning_amber_rounded, color: AppTheme.accentYellow, size: 40),
                  ),
                ],
              ),
            ],
          ),

          // UI Overlay for mock reviews using Reactive Tiles
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildMockReviewCard(
                    title: "42 E Bergen Ave",
                    rating: "2.1/5",
                    comment: "Customer thinks 'flushable wipes' means flushable. Sent snake down, pulled up a sweater.",
                    author: "Joe's Plumbing",
                  ),
                  const SizedBox(width: 16),
                  _buildMockReviewCard(
                    title: "38 E Bergen Ave",
                    rating: "4.5/5",
                    comment: "Paid in cash and offered me a cold beer. Electrical panel was a rat's nest but good folks.",
                    author: "Sparky Dan",
                  ),
                  const SizedBox(width: 16),
                  _buildMockReviewCard(
                    title: "50 E Bergen Ave",
                    rating: "1.0/5",
                    comment: "Refused to pay for the drywall patching after I fixed the stud they broke. Avoid.",
                    author: "Mike the Builder",
                  ),
                ],
              ),
            ),
          )
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

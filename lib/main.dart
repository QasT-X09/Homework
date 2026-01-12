import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  
  // Use reliable network image URLs so images load in the gallery.
  // picsum.photos with seeds provides consistent, HTTPS-hosted images.
  static final List<String> images = List.generate(
    8,
    (i) => 'https://picsum.photos/seed/${i + 1}/600/400',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.image, size: 28, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: const [
                Icon(Icons.photo_library, size: 32, color: Colors.deepPurple),
                SizedBox(width: 8),
                Expanded(child: Text('Local and network images — scroll the gallery')),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              children: images.map((path) {
                final bool isNetwork = path.startsWith('http');
                return Container(
                  height: 180,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image (asset or network)
                      isNetwork
                          ? Image.network(
                              path,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
                            )
                          : Image.asset(
                              path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
                            ),
                      // Slight overlay with icon in bottom-right
                      const Positioned(
                        right: 6,
                        bottom: 6,
                        child: Icon(Icons.image, color: Colors.white70, size: 20),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

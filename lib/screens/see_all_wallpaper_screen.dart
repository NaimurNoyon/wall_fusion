import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wall_fusion/screens/single_wallpaper_screen.dart';

class SeeAllWallpaperScreen extends StatelessWidget {
  const SeeAllWallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> largeWallpaperUrls = [
      "https://jazakallah-server.product8.net/../storage/wallpaper_images/wallpaper_1709038289.jpg",
      "https://jazakallah-server.product8.net/../storage/wallpaper_images/wallpaper_1709038356.jpeg",
      "https://jazakallah-server.product8.net/../storage/wallpaper_images/wallpaper_1709038340.jpg"      // Add more image URLs here
    ];
    final List<String> smallWallpaperUrls = [
      "https://jazakallah-server.product8.net/../storage/thumbnail_images/thumbnail_1709038289.jpg",
      "https://jazakallah-server.product8.net/../storage/thumbnail_images/thumbnail_1709038356.jpeg",
      "https://jazakallah-server.product8.net/../storage/thumbnail_images/thumbnail_1709038340.jpg"      // Add more image URLs here
    ];

    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: smallWallpaperUrls.length,
        itemBuilder: (context, index) {
          return GridTile(
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SingleWallPaperScreen(largeImage: largeWallpaperUrls[index],smallImage: smallWallpaperUrls[index],)),
                );
              },
              child: CachedNetworkImage(
                imageUrl: smallWallpaperUrls[index],
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

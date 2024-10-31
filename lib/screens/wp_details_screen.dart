import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:zingo_wallpapers/model/curated_model.dart';
import 'package:zingo_wallpapers/providers/curated_provider.dart';
import 'package:zingo_wallpapers/screens/wallpaper_main_screen.dart';

class WallpaperDetailScreen extends StatefulWidget {
  final Photos? imageUrl;

  const WallpaperDetailScreen({super.key, this.imageUrl});

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final curatedProvider =
        Provider.of<CuratedProvider>(context, listen: false);

    return Scaffold(
        body: Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl!.src!.original!,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        bottom: 80,
        left: 20,
        child: Text(
          widget.imageUrl?.photographer ?? '', // Display photographer name
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            backgroundColor: Colors.black54,
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: ElevatedButton(
          onPressed: () async {
            if (Platform.isAndroid) {
              if (await Permission.storage.request().isGranted ||
                  await Permission.manageExternalStorage.request().isGranted) {
                await curatedProvider.downloadWallpaper(
                    widget.imageUrl!, context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Permission denied. Cannot save image.')),
                );
              }
            }
          },
          child: Text(
            "Download",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    ]));
  }
}

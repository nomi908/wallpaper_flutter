import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zingo_wallpapers/providers/curated_provider.dart';
import 'package:zingo_wallpapers/screens/wallpaper_main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CuratedProvider()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zingo Wallpapers',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WallpaperMainScreen(),
    );
  }
}

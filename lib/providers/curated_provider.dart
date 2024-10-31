import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zingo_wallpapers/model/curated_model.dart';
import 'package:zingo_wallpapers/service/curated_apiservice.dart';


class CuratedProvider extends ChangeNotifier {

  List<Photos> _curatedList = [];
  int _page = 1;
  int _perPage = 80;
  int _totalResults = 0;
  String _nextPage = "";
  bool _isLoading = false;


  List<Photos> get curatedList => _curatedList;

  int get page => _page;

  int get perPage => _perPage;

  int get totalResults => _totalResults;

  String get nextPage => _nextPage;

  bool get isLoading => _isLoading;


  Future<void> getCuratedImages() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    final CuratedApiService curatedApiService = CuratedApiService();

    try {
      _curatedList = await curatedApiService.getCuratedImages(_page, _perPage);
      _curatedList.sort((a, b) => a.id!.compareTo(b.id!));
      print('Curated List ${_curatedList.length}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error!! ${e.toString()}');
      _isLoading = false;
      notifyListeners();
    }
  }

  //
  Future<PermissionStatus> requestPermission(Permission permission) async {
    // Check the current status of the permission
    final status = await permission.status;

    if (status.isGranted) {
      print('Permission Already Granted');
      return status;
    }

    if (status.isDenied) {
      // Request the permission
      final newStatus = await permission.request();

      if (newStatus.isGranted) {
        print('Permission Granted');
      } else if (newStatus.isPermanentlyDenied) {
        print('Permission Permanently Denied');
        // Optionally, you can open app settings
        openAppSettings();
      } else {
        print('Permission Denied');
      }
    }
    return status;
  }

  Future<void> downloadWallpaper(Photos imageurl, BuildContext context) async {
    try {
      // Get the Downloads directory
      final directory = Directory('/storage/emulated/0/Download');

      // Specify the new folder name for downloads
      final newFolderName = 'ZingoWallpapers';
      final wallpapersDir = Directory('${directory.path}/$newFolderName');

      // Create the directory if it doesn't exist
      if (!(await wallpapersDir.exists())) {
        await wallpapersDir.create(recursive: true);
      }

      // Specify the file path for the downloaded image
      final filePath = '${wallpapersDir.path}/${imageurl.id}.jpg';

      // Fetch the image data from the URL
      final response = await Dio().get(
        imageurl.src!.original!,
        options: Options(responseType: ResponseType.bytes),
      );

      // Create the file and write the bytes
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      // Log the file path
      print('Wallpaper saved to: $filePath');

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wallpaper Downloaded to $filePath')),
      );
    } catch (e) {
      print('Error downloading wallpaper: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download wallpaper')),
      );
    }
  }

}
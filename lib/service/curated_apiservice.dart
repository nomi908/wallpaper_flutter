import 'dart:convert';

import 'package:zingo_wallpapers/model/curated_model.dart';
import 'package:http/http.dart' as http;
import 'package:zingo_wallpapers/secret.dart';
class CuratedApiService {
  static String baseUrl = "https://api.pexels.com/v1/curated?per_page=1";
  CuratedModel? curatedModel;


  Future<List<Photos>> getCuratedImages(int page, int perPage) async {

    try{
      final Url = "$baseUrl&page=$page&per_page=$perPage";
      final response = await http.get(Uri.parse(Url),
          headers: {
            "Authorization" : Secret.secretApiKey
          });

      var data = jsonDecode(response.body);
      print('data curated ${data}');

      if(response.statusCode == 200){
        curatedModel = CuratedModel.fromJson(data);
        print('curatedModel ${curatedModel!.photos!.length}');
        return curatedModel!.photos!;
      }else{
        throw Exception("Something went wrong");
      }
    }catch(e){
      throw Exception("Error caused by ${e.toString()}");
    }

  }

}


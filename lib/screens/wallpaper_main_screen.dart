import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:zingo_wallpapers/providers/curated_provider.dart';
import 'package:zingo_wallpapers/screens/wp_details_screen.dart';

class WallpaperMainScreen extends StatefulWidget {
  const WallpaperMainScreen({super.key});

  @override
  State<WallpaperMainScreen> createState() => _WallpaperMainScreenState();
}

class _WallpaperMainScreenState extends State<WallpaperMainScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((value){
    final curatedProvider =  Provider.of<CuratedProvider>(context, listen: false);
    curatedProvider.getCuratedImages();

    });
  }

  @override
  Widget build(BuildContext context) {
    final curatedProvider = Provider.of<CuratedProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallpaper"),
      ),
      body: curatedProvider.isLoading ? const Center(child: CircularProgressIndicator())

          :GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
            (crossAxisCount: 2,
          mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemCount: curatedProvider.curatedList.length,
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> WallpaperDetailScreen(
                  imageUrl: curatedProvider.curatedList[index],
                )));
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 1,
                child: CachedNetworkImage(
                  imageUrl: curatedProvider.curatedList[index].src!.original!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );

      })
      //     : MasonryGridView.count(
      //     crossAxisCount: 2,
      //     mainAxisSpacing: 4,
      //     crossAxisSpacing: 4,
      //     itemCount: curatedProvider.curatedList.length,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         clipBehavior: Clip.antiAlias,
      //         elevation: 1,
      //
      //         child: Column(
      //           children: [
      //             Image.network(curatedProvider.curatedList[index].src!.original!,
      //               fit: BoxFit.cover,)
      //           ],
      //         ),
      //       );
      //
      //     }
      // )

    );
  }
}

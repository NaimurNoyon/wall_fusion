import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';

class SingleWallPaperScreen extends StatefulWidget {
  final String largeImage, smallImage;
  const SingleWallPaperScreen({super.key, required this.largeImage, required this.smallImage});

  @override
  State<SingleWallPaperScreen> createState() => _SingleWallPaperScreenState();
}

class _SingleWallPaperScreenState extends State<SingleWallPaperScreen> {

  late Stream<String> progressString;
  late String res;
  bool downloading = false;
  var result = "Waiting to set wallpaper";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isLongPress = false;
    return Stack(
      children: [
        GestureDetector(
          onLongPressStart: (value) {
            setState(() {
              isLongPress = true;
            });
          },
          onLongPressEnd: (value) {
            setState(() {
              isLongPress = false;
            });
          },
          child: Image.network(
            widget.largeImage,
            loadingBuilder: (BuildContext? context, Widget? child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child!;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.smallImage), fit: BoxFit.cover),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          ' Press & Hold for preview ',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            backgroundColor: Colors.black45,
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        CircularProgressIndicator(
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white),
                          strokeWidth: 2.0,
                          backgroundColor: Colors.black45,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            fit: BoxFit.cover,
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        downloading?
        imageDownloadDialog() : SizedBox(),
        Positioned(
          left: 0,
            right: 0,
            bottom: 20,
            child: IconButton(
              icon: const Icon(Icons.download, color: Colors.white,),
              onPressed: () async{
                await dowloadImage();
                //await Wallpaper.bothScreen();
              },
            )
        ),
      ],
    );
  }

  Future<void> dowloadImage() async {
    progressString = Wallpaper.imageDownloadProgress(widget.largeImage);
    progressString.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      Wallpaper.bothScreen();
      setState(() {
        downloading = false;
      });
      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }

  Widget imageDownloadDialog() {
    return Container(
      height: 120.0,
      width: 200.0,
      child: Card(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20.0),
            Text(
              "Downloading File : $res",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

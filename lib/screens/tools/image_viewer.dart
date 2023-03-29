import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;

class ImageViewer extends StatelessWidget {
  final String image;
  const ImageViewer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              // height: double.maxFinite,
              child: Image.network(
                filterQuality: FilterQuality.high,
                image,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child: Image.asset("assets/images/preload.gif",
                                height: 50),
                          ),
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(CupertinoIcons.photo, size: 100),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white),
                  icon: const Icon(Icons.arrow_back_outlined,
                      color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white),
                  icon: const Icon(Icons.download_rounded, color: Colors.black),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    await saveImage().then((value) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 10,
                          backgroundColor: AppTheme.themeData(false, context)
                              .backgroundColor,
                          content: const Text("Image saved to gallery",
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  saveImage() async {
    var response = await http.get(Uri.parse(image), headers: {
      "Accept": "image/png",
    });
    if (response.statusCode == 200) {
      await ImageGallerySaver.saveImage(
        response.bodyBytes,
        quality: 100,
        name: "IK_image",
      );
    }
  }
}

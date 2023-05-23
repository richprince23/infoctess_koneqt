import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

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
                  icon: const BackButtonIcon(),
                  color: Colors.black,
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
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => Center(
                        child: Image.asset("assets/images/preload.gif",
                            height: 50.h),
                      ),
                    );
                    await saveImage().then((value) {
                      Navigator.of(context).pop();
                      StatusAlert.show(
                        context,
                        duration: const Duration(seconds: 2),
                        title: "Image saved",
                        titleOptions: StatusAlertTextConfiguration(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp + 1,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        maxWidth: 50.vw,
                        configuration: IconConfiguration(
                          icon: Icons.check,
                          color: Colors.green,
                          size: 50.w,
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

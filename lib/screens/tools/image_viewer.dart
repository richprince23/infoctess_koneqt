import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String image;
  const ImageViewer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Image.network(
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
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Save Image'),
          ),
        ],
      ),
    );

    
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:path_provider/path_provider.dart';

class FileProvider extends ChangeNotifier {
  DownloadStatus? status ;
  double progress = 0.0;
  

  /// Download file from url and saves it to the device
  ///
  /// [url] is the url of the file to be downloaded
  ///
  downloadFile({required String url}) async {
    var dl = DownloadManager();
    final appDir = await getApplicationDocumentsDirectory();

    dl.addDownload(
        url, appDir.path + path.basename(File(url.split("?")[0]).path));

    DownloadTask? task = dl.getDownload(url);

    task?.status.addListener(() {
      print(task.status.value);
      status = task.status.value;
    });

    task?.progress.addListener(() {
      print(task.progress.value);
      progress = task.progress.value;
    });

    await dl.whenDownloadComplete(url);
    notifyListeners();
  }


  /// Open the downloaded file using the open_file package
  ///
  /// [filePath] is the path to the downloaded file
  ///
  void openDownloadedFile(String filePath) {
    OpenFile.open(filePath);
  }

}

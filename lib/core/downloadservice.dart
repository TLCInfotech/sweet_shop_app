import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

abstract class DownloadService {
  Future<void> download({required String url});
}

class WebDownloadService implements DownloadService {
  @override
  Future<void> download({required String url}) {
    throw UnimplementedError();
  }
}

class MobileDownloadService implements DownloadService {
  MobileDownloadService(this.name,this.type,this.context);
  final name,type,context;



  Future<void> download({required String url}) async {
    print("Here");
    // Requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    // Gets the directory where we will download the file.
    Directory? dir;
    if (Platform.isIOS) {
      dir = await getTemporaryDirectory();
    } else {
      dir = await getExternalStorageDirectory();
    }

    if (dir == null) {
      _showAlertDialog("Error", "Unable to get download directory");
      return;
    }

    // Define the file name
    String fileName = Uri.parse(url).pathSegments.last;

    try {
      // Make the HTTP request to download the file
      final response = await http.get(Uri.parse(url));
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Save the file
        final filePath = '${dir.path}/$fileName.$type';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print(filePath);
        // Open the file
        OpenFile.open(filePath);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        _showAlertDialog("Something went wrong", "Unable to download the file: ${response.statusCode}");
     //   _showAlertDialog("Client Error", "Unable to download the file: ${response.statusCode}");
      } else if (response.statusCode >= 500) {
      //  _showAlertDialog("Server Error", "Failed to download the file: ${response.statusCode}");
       _showAlertDialog("Something went wrong", "Unable to download the file: ${response.statusCode}");
      } else {
        _showAlertDialog("Error", "Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      print("HTTP Error: $e");
      _showAlertDialog("Error", "An error occurred: $e");
    }
  }
/*
  @override
  Future<void> download({required String url}) async {
    print("Here");
    // Requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    // Gets the directory where we will download the file.
    var dir;
    if (Platform.isIOS) {
      dir = await getTemporaryDirectory();
    } else {
      dir = await getExternalStorageDirectory();
    }

    // Define the file name
    String fileName = Uri.parse(url).pathSegments.last;

    try {
      // Make the HTTP request to download the file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Save the file
        final filePath = '${dir.path}/$fileName.$type';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print(filePath);
        // Open the file
        OpenFile.open(filePath);
      } else {
        throw Exception('Failed to download the file');
      }
    } catch (e) {
      print("HTTP Error: $e");
      // showAlertDialog(context: context, title: "Error", content: "$e");
    }
  }*/

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
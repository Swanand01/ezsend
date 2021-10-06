import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:sharefile/api_manager.dart';
import 'package:sharefile/models/filemodel.dart';

class DownloadPage extends StatefulWidget {
  final String enc;

  const DownloadPage({Key? key, required this.enc}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  bool fileExists = true;
  String fileName = "";
  String size = "";

  getFile() async {
    FileData fileData = FileData();
    FileModel file = await fileData.getFileData(widget.enc);
    if (file.filename == "") {
      setState(() {
        fileExists = false;
      });
    } else {
      setState(() {
        fileName = file.filename;
        size = file.size;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: fileExists
            ? Column(
                children: [
                  Center(
                    child: Text(fileName),
                  ),
                  Center(
                    child: Text(size),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String enc = widget.enc;
                        downloadFile(
                            "http://127.0.0.1:8000/app/download/$enc/");
                      },
                      child: Text("Download")),
                ],
              )
            : Center(child: Text("NOT FOUND")));
  }
}

void downloadFile(String url) {
  html.AnchorElement anchorElement = new html.AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.click();
}

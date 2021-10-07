import 'package:beamer/beamer.dart';
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
  double mb = 0;

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
        mb = double.parse(size) / 1000000;
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
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: 600,
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Image.network(
                                  "https://i.ibb.co/WBz0PSw/undraw-cloud-files-wmo8.png")),
                          Expanded(
                              flex: 1,
                              child: Text(fileName,
                                  style: TextStyle(fontSize: 16))),
                          Expanded(
                              flex: 1,
                              child: Text("Size: " + mb.toString() + " MB",
                                  style: TextStyle(fontSize: 16))),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff6C63FF),
                                    minimumSize: Size(150, 50)),
                                onPressed: () async {
                                  String enc = widget.enc;
                                  downloadFile(
                                      "http://127.0.0.1:8000/app/download/$enc/");
                                },
                                child: Text("Download",
                                    style: TextStyle(fontSize: 16))),
                          ),
                          Expanded(child: Center(child: Text("OR"))),
                          Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    Beamer.of(context).beamToNamed('/');
                                  },
                                  child: Text("Send your files")))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(child: Text("NOT FOUND")));
  }
}

void downloadFile(String url) {
  html.AnchorElement anchorElement = new html.AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.click();
}

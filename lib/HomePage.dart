import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool uploading = false;
  FilePickerCross? file;
  String fileName = "";
  String downloadurl = "";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () async {
                            file = await FilePickerCross.importFromStorage();
                            setState(() {
                              fileName = file!.fileName!;
                            });
                          },
                          child: Image.network(
                              "https://i.ibb.co/nPkr1Dt/undraw-Add-files-re-v09g.png"),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(
                            fileName,
                            style: TextStyle(fontSize: 16),
                          )),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: uploading
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff6C63FF),
                                      minimumSize: Size(150, 50)),
                                  child: Text(
                                    "Upload",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    if (file != null) {
                                      makePostRequest(file);
                                    } else {
                                      showToast("Please select a file");

                                      print(width);
                                    }
                                  }),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: downloadurl));
                                showToast("Link copied");
                              },
                              child: Text(
                                downloadurl,
                                style: TextStyle(fontSize: 16),
                              )))
                    ],
                  )),
            ),
          ),
          width > 600
              ? Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            "ezSend",
                            style: TextStyle(fontSize: 48),
                          )),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 24,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "1. Upload a file.",
                            style: TextStyle(fontSize: 24, color: Colors.grey),
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "2. Share the download link!",
                            style: TextStyle(fontSize: 24, color: Colors.grey),
                          )),
                      Expanded(
                        flex: 5,
                        child: Image.network(
                            "https://i.ibb.co/zXtB9th/undraw-uploading-go67.png"),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future makePostRequest(var file) async {
    setState(() {
      uploading = true;
    });
    String url = 'http://127.0.0.1:8000/app/';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    Uint8List data = await file.toUint8List();
    List<int> list = data.cast();

    request.files.add(
        http.MultipartFile.fromBytes('file', list, filename: file.fileName));

    var response = await request.send();
    print("DONE");

    response.stream.bytesToString().asStream().listen((event) {
      var parsedJson = json.decode(event);
      String fileId = parsedJson['file'];

      setState(() {
        downloadurl = Uri.base.toString() + "download/" + fileId;
      });
    });

    setState(() {
      uploading = false;
    });
  }
}

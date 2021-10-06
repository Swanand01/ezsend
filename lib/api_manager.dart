import 'dart:convert';
import 'package:http/http.dart';
import 'package:sharefile/models/filemodel.dart';

class FileData {
  Future getFileData(String enc) async {
    var response = await get(Uri.parse("http://127.0.0.1:8000/app/$enc/"));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] != 404) {
      FileModel fileModel = FileModel(
          filename: jsonData['filename'], size: jsonData['size'].toString());

      return fileModel;
    } else {
      FileModel fileModel = FileModel(filename: "", size: "");

      return fileModel;
    }
  }
}

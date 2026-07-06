import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui';

import '../file_picker_cross.dart';

/// Implementation of file selection dialog using dart:html for the web
Future<Map<String, Uint8List>> selectSingleFileAsBytes({
  required FileTypeCross type,
  required String fileExtension,
}) {
  Completer<Map<String, Uint8List>> loadEnded = Completer();

  String accept = _fileTypeToAcceptString(type, fileExtension);
  html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.draggable = true;
  uploadInput.accept = accept;
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    final file = files![0];
    final reader = new html.FileReader();

    reader.onLoadEnd.listen((e) {
      loadEnded.complete({
        uploadInput.value!.replaceAll('\\', '/'): reader.result as Uint8List,
      });
    });
    reader.readAsArrayBuffer(file);
  });
  return loadEnded.future;
}

/// Implementation of file selection dialog for multiple files using dart:html for the web
Future<Map<String, Uint8List>> selectMultipleFilesAsBytes({
  required FileTypeCross type,
  required String fileExtension,
}) {
  Completer<Map<String, Uint8List>> loadEnded = Completer();

  String accept = _fileTypeToAcceptString(type, fileExtension);
  html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.draggable = true;
  uploadInput.accept = accept;
  uploadInput.multiple = true;
  uploadInput.click();

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    int counter = 0;

    Map<String, Uint8List> fileBytes = {};

    files!.forEach((currentFile) {
      final reader = new html.FileReader();
      reader.onLoadEnd.listen((e) {
        fileBytes[(currentFile.relativePath! + '/' + currentFile.name)
            .replaceAll('\\', '/')] = reader.result as Uint8List;
        counter++;
        if (counter >= files.length) loadEnded.complete(fileBytes);
      });
      reader.readAsArrayBuffer(currentFile);
    });
  });
  return loadEnded.future;
}

/// Implementation of file selection dialog for the web
Future<String> pickSingleFileAsPath({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  /// TODO: implement using NativeFileSystem API
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<Uint8List> internalFileByPath({
  required String path,
}) async {
  Completer<Uint8List> completer = Completer();
  completer.complete(Uint8List.fromList(openLocalFileSystem()[path]!));
  return completer.future;
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<bool> saveInternalBytes({
  required Uint8List bytes,
  required String path,
}) async {
  final fs = openLocalFileSystem();
  fs[path] = bytes;
  saveLocalFileSystem(fs);
  return true;
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<String?> exportToExternalStorage({
  required Uint8List bytes,
  String? fileName,
  String? subject,
  String? text,
  Rect? sharePositionOrigin,
}) async {
  html.AnchorElement link = html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(
          html.Blob([bytes], 'application/octet-stream')))
    ..download = fileName;
  link.click();
  return (fileName);
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<List<String>> listFiles({
  Pattern? at,
  Pattern? name,
}) async {
  Iterable<String> fs = openLocalFileSystem().keys.toList();
  if (at != null) {
    fs = fs.where((element) => element.startsWith(at));
  }
  if (name != null) {
    fs = fs.where((element) => element.lastIndexOf(name) >= 0);
  }
  return fs.toList();
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<bool> deleteInternalPath({
  required String path,
}) async {
  final fs = openLocalFileSystem();
  fs.remove(path);
  saveLocalFileSystem(fs);
  return true;
}

Future<FileQuotaCross> getInternalQuota() async {
  try {
    if (!await html.window.navigator.storage!.persisted())
      await html.window.navigator.storage!.persist();
  } catch (e) {
    print('Persistent storage not supported. Using default storage instead.');
  }

  final quota = await html.window.navigator.storage!.estimate();

  return FileQuotaCross(quota: quota!['quota'], usage: quota['usage']);
}

String _fileTypeToAcceptString(FileTypeCross type, String fileExtension) {
  String accept;
  switch (type) {
    case FileTypeCross.any:
      accept = '';
      break;
    case FileTypeCross.audio:
      accept = 'audio/*';
      break;
    case FileTypeCross.image:
      accept = 'image/*';
      break;
    case FileTypeCross.video:
      accept = 'video/*';
      break;
    case FileTypeCross.custom:
      accept = fileExtension;
      break;
  }
  return accept;
}

const kLocalStorageKey = 'file_picker_cross_file_system';

/// Opening the json file system and converting it to typed data
Map<String, List<int>> openLocalFileSystem() {
  if (html.window.localStorage.containsKey(kLocalStorageKey)) {
    Map<String, List> map = Map<String, List>.from(
        jsonDecode(html.window.localStorage[kLocalStorageKey]!));

    Map<String, List<int>> returnMap = {};
    map.forEach((key, value) {
      returnMap[key] = List<int>.from(value);
    });
    return returnMap;
  } else
    return {};
}

void saveLocalFileSystem(Map<String, List<int>> fileSystem) {
  getInternalQuota();
  html.window.localStorage[kLocalStorageKey] = jsonEncode(fileSystem);
}

import 'dart:typed_data';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:file_selector/file_selector.dart';

import 'file_picker_io.dart';

/// Implementation of file selection dialog using file_chooser for desktop platforms
Future<Map<String, Uint8List>> selectFilesDesktop({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  final file = await ((parseExtension(fileExtension) == null)
      ? openFile()
      : openFile(acceptedTypeGroups: [
          XTypeGroup(label: 'files', extensions: parseExtension(fileExtension))
        ]));

  if (file != null) {
    String path = file.path;
    return {path: await fileByPath(path).readAsBytes()};
  } else
    return {};
}

/// Implementation of file selection dialog for multiple files using file_chooser for desktop platforms
Future<Map<String, Uint8List>> selectMultipleFilesDesktop({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  final files = await ((parseExtension(fileExtension) == null)
      ? openFiles()
      : openFiles(acceptedTypeGroups: [
          XTypeGroup(label: 'images', extensions: parseExtension(fileExtension))
        ]));

  Map<String, Uint8List> fileBytes = {};
  files.forEach((element) {
    final path = element.path;
    fileBytes[path] = fileByPath(path).readAsBytesSync();
  });
  return fileBytes;
}

/// Implementation of file selection dialog using file_chooser for desktop platforms
Future<String?> saveFileDesktop({
  required String fileExtension,
  String? suggestedFileName,
}) async {
  return await (parseExtension(fileExtension) == null)
      ? getSavePath(suggestedName: suggestedFileName, acceptedTypeGroups: [
          XTypeGroup(label: 'images', extensions: parseExtension(fileExtension))
        ])
      : getSavePath(
          suggestedName: suggestedFileName,
        );
}

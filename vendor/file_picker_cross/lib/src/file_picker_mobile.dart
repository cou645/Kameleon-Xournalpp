import 'dart:io';
import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

import 'file_picker_io.dart';

/// Implementation of file selection dialog using file_picker for mobile platforms
Future<Map<String, Uint8List>> selectFilesMobile({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  final filePickerResults = await FilePicker.platform.pickFiles(
      type: fileTypeCrossParse(type),
      allowedExtensions: parseExtension(fileExtension),
      withData: true);

  if (filePickerResults == null || filePickerResults.files.isEmpty) {
    throw StateError('no file selected');
  }

  final pf = filePickerResults.files.single;

  // Cloud providers (Google Photos, Drive) return null path but supply bytes directly.
  if (pf.path != null) {
    final file = File(pf.path!);
    return {file.path: await file.readAsBytes()};
  } else if (pf.bytes != null) {
    final name = pf.name;
    final tmp = File('${(await Directory.systemTemp.createTemp('fp_')).path}/$name');
    await tmp.writeAsBytes(pf.bytes!);
    return {tmp.path: pf.bytes!};
  } else {
    throw StateError('no file data');
  }
}

/// Implementation of file selection dialog for multiple files using file_picker for mobile platforms
Future<Map<String, Uint8List>> selectMultipleFilesMobile({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  final files = await FilePicker.platform.pickFiles(
      type: fileTypeCrossParse(type),
      allowMultiple: true,
      allowedExtensions: parseExtension(fileExtension));

  // FilePickerResult files = f!;

  Map<String, Uint8List> filesMap = {};
  if (files is FilePickerResult) {
    files.paths.forEach((path) {
      filesMap[path!] = File(path).readAsBytesSync();
    });
  }

  return filesMap;
}

Future<String> saveFileMobile({
  required FileTypeCross type,
  required String fileExtension,
}) async {
  /// TODO: implement
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

import 'dart:typed_data';
import 'dart:ui';

import '../file_picker_cross.dart';

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<Map<String, Uint8List>> selectSingleFileAsBytes(
    {required FileTypeCross type, required String fileExtension}) async {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<Map<String, Uint8List>> selectMultipleFilesAsBytes(
    {required FileTypeCross type, required String fileExtension}) async {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<String> pickSingleFileAsPath(
    {required FileTypeCross type, required String fileExtension}) async {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<Uint8List> internalFileByPath({required String path}) {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<bool> saveInternalBytes(
    {required Uint8List bytes, required String path}) {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<String?> exportToExternalStorage({
  required Uint8List bytes,
  required String fileName,
  String? subject,
  String? text,
  Rect? sharePositionOrigin,
}) {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<bool> deleteInternalPath({required String path}) {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<List<String>> listFiles({Pattern? at, Pattern? name}) async {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

/// Dummy implementation throwing an error. Should be overwritten by conditional imports.
Future<FileQuotaCross> getInternalQuota() async {
  throw UnimplementedError('Unsupported Platform for file_picker_cross');
}

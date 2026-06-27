// PDF rasterization stubbed out (printing package removed for build compatibility)
import 'dart:typed_data';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:xournalpp/src/XppPage.dart';

Future<int> pdfPageCount(FilePickerCross pdf) async => 0;

Future<Uint8List> pdfImage(FilePickerCross pdf, int? page) async =>
    Uint8List(0);

Future<XppPageSize> pdfPageSize(FilePickerCross pdf, int page) async =>
    XppPageSize(width: 595, height: 842);

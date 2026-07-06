import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'src/file_picker_stub.dart'
// ignore: uri_does_not_exist
    if (dart.library.io) 'src/file_picker_io.dart'
// ignore: uri_does_not_exist
    if (dart.library.html) 'src/file_picker_web.dart';

/// FilePickerCross allows you to select files on any of Flutters platforms.
class FilePickerCross {
  /// The allowed [FileTypeCross] of the file to be selected
  final FileTypeCross type;

  /// The allowed file extension of the file to be selected
  final String fileExtension;

  /// Returns the path the file is located at
  final String? path;

  final Uint8List _bytes;

  FilePickerCross(
    this._bytes, {
    this.path,
    this.type = FileTypeCross.any,
    this.fileExtension = '',
  });

  /// Deprecated. Use [importFromStorage] instead
  @deprecated
  static Future<FilePickerCross> pick(
          {FileTypeCross type = FileTypeCross.any,
          String fileExtension = ''}) =>
      importFromStorage(type: type, fileExtension: fileExtension);

  /// Shows a dialog for selecting a file from your device's internal storage.
  /// If thee selected file is a [Null] byte, a  [NullThrownError] is thrown.
  /// If the file selection was canceled by the user, a  [FileSelectionCanceledError]
  /// is thrown.
  static Future<FilePickerCross> importFromStorage({
    FileTypeCross type = FileTypeCross.any,
    String fileExtension = '',
  }) async {
    try {
      final Map<String, Uint8List> file = await selectSingleFileAsBytes(
        type: type,
        fileExtension: fileExtension,
      );

      String _path = file.keys.toList()[0];
      Uint8List? _bytes = file[_path];

      if (_bytes == null) {
        throw StateError("null file");
      }
      return FilePickerCross(_bytes,
          path: _path, fileExtension: fileExtension, type: type);
    } catch (e) {
      throw FileSelectionCanceledError(e);
    }
  }

  /// Imports multiple files into your application. See [importFromStorage]
  /// for further details.
  static Future<List<FilePickerCross>> importMultipleFromStorage({
    FileTypeCross type = FileTypeCross.any,
    String fileExtension = '',
  }) async {
    try {
      final Map<String, Uint8List> files = await selectMultipleFilesAsBytes(
        type: type,
        fileExtension: fileExtension,
      );

      if (files.isEmpty) {
        throw StateError("null file");
      }

      List<FilePickerCross> filePickers = [];
      files.forEach((path, file) {
        filePickers.add(
          FilePickerCross(
            file,
            path: path,
            fileExtension: fileExtension,
            type: type,
          ),
        );
      });

      return filePickers;
    } catch (e) {
      throw FileSelectionCanceledError(e);
    }
  }

  /// Deprecated. Use [saveToPath] or [exportToStorage] instead.
  @deprecated
  static Future<FilePickerCross> save({
    FileTypeCross type = FileTypeCross.any,
    String fileExtension = '',
  }) async {
    final String? path =
        await pickSingleFileAsPath(type: type, fileExtension: fileExtension);

    if (path != null)
      return FilePickerCross(Uint8List(0),
          path: path, fileExtension: fileExtension, type: type);
    else
      throw FileSelectionCanceledError();
  }

  /// Lists all internal files inside the app's internal memory
  static Future<List<String>> listInternalFiles({
    Pattern? at,
    Pattern? name,
  }) {
    return listFiles(at: at, name: name);
  }

  /// Creates a [FilePickerCross] from a local path.
  /// This does **not** allow you to open a file from the local storage but only a file previously saved by [saveToPath].
  /// If you want to open the file to the shared, local memory, use [importFromStorage] instead.
  static Future<FilePickerCross> fromInternalPath({
    required String path,
  }) async {
    final Uint8List? file = await internalFileByPath(path: path);

    if (file == null) {
      throw StateError("null file");
    }

    return FilePickerCross(file, path: path);
  }

  /// Save the file to an internal path.
  /// This does **not** allow you to save the file to the device's public storage like `Documents`, `Downloads`
  /// or `Photos` but saves the [FilePickerCross] in an **app specific**, internal folder for later access by *this app only*. To export a file to
  /// the local storage, use [exportToStorage] instead.
  Future<bool> saveToPath({
    required String path,
  }) {
    return saveInternalBytes(bytes: toUint8List(), path: path);
  }

  /// finally deletes a file stored in the given path of your application's fake filesystem
  static Future<bool> delete({
    required String path,
  }) {
    return deleteInternalPath(path: path);
  }

  /// returns the maximally available storage space
  static Future<FileQuotaCross> quota() {
    return getInternalQuota();
  }

  /// Export the file to the external storage.
  /// This shows a file dialog allowing to select the file name and location and
  /// will return the finally selected, absolute path to the file.
  ///
  /// The optional [subject] parameter can be used to populate a subject if the
  /// user chooses to send an email on Android or iOS.
  ///
  /// The optional [sharePositionOrigin] parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads. It has no effect
  /// on non-iPads.
  ///
  Future<String?> exportToStorage({
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
    String? fileName,
  }) {
    assert(
        fileName != null || this.fileName != null,
        'You nether provided a file name nor an original file name could be'
        'found for the path. You probably created a FilePickerCross from'
        'an Uint8List and tried to export it without providing a file name.');
    return exportToExternalStorage(
      bytes: toUint8List(),
      fileName: fileName ?? this.fileName!,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Returns the name of the file. This typically is the part of the path after the last `/` or `\`.
  String? get fileName {
    final parsedPath = '/' + path!.replaceAll(r'\', r'/');
    return parsedPath.substring(parsedPath.lastIndexOf('/') + 1);
  }

  /// Returns the directory the file is located in. This it typically everything before the last `/` or `\`.
  /// *Note:* Even on Windows and web platforms, where file paths are typically presented using `\` instead
  /// of `/`, the path's single directories are separated using `/`.
  String get directory {
    final parsedPath = '/' + path!.replaceAll(r'\', r'/');
    return parsedPath.substring(0, parsedPath.lastIndexOf('/'));
  }

  /// Returns a sting containing the file contents of plain text files. Please use it in a try {} catch (e) {} block if you are unsure if the opened file is plain text.
  String toString() => Utf8Codec().decode(_bytes);

  /// Returns the file as a list of bytes.
  Uint8List toUint8List() => _bytes;

  /// Returns the file as base64-encoded String.
  String toBase64() => base64.encode(_bytes);

  /// Returns the file as MultiPartFile for use with tha http package. Useful for file upload in apps.
  http.MultipartFile toMultipartFile({String? filename}) {
    if (filename == null) {
      filename = fileName;
    }

    return http.MultipartFile.fromBytes(
      'file',
      _bytes,
      contentType: new MediaType('application', 'octet-stream'),
      filename: filename,
    );
  }

  /// Returns the file's length in bytes
  int get length => _bytes.lengthInBytes;
}

/// Supported file types
enum FileTypeCross { image, video, audio, any, custom }

/// represents the storage quota of the [FilePickerCross]
class FileQuotaCross {
  /// the maximal number of bytes available for use
  final int quota;

  /// the current use of storage in bytes
  final int usage;

  FileQuotaCross({
    required this.quota,
    required this.usage,
  });

  /// the number of bytes free for use
  int get remaining => quota - usage;

  /// returns the relative share used
  ///
  /// 0 if no storage is used; 1 if storage is full
  double get relative => usage / quota;

  @override
  String toString() {
    return 'instance of FileQuotaCross{ quota: $quota, usage: $usage }';
  }
}

/// [Exception] if the selection oof a file was canceled
class FileSelectionCanceledError implements Exception {
  var _msg;
  var platformError;

  FileSelectionCanceledError([var msg = '']) {
    this._msg = msg;
  }

  // Helps developer collect specific exception
  // reasoning to act up-on
  String reason() {
    String _err = _msg.toString();

    // Provide PlatformException specific messages
    String _platformError() {
      String _reasonCollector = '';

      // Access data from first parameter
      _reasonCollector = _err.split(':')[1];
      _reasonCollector = _reasonCollector.split('(')[1];
      _reasonCollector = _reasonCollector.split(',')[0];

      return _reasonCollector;
    }

    // List of known exceptions to handle
    String _methodMap(String exceptionType) {
      String _reasonCollector;

      switch (exceptionType) {
        case 'RangeError (index)':
          {
            _reasonCollector = 'selection_canceled';
          }
          break;

        case 'NoSuchMethodError':
          {
            _reasonCollector = 'selection_canceled';
          }
          break;

        case 'PlatformException':
          {
            _reasonCollector = _platformError();
          }
          break;

        default:
          {
            _reasonCollector = '';
          }
          break;
      }

      return _reasonCollector;
    }

    String _reasonResult = '';
    String _exception = '';
    String _methodData;

    // Patch string with different format before processing
    if (_err.substring(0, 17) == 'PlatformException') {
      _err = _err.split('(')[0] + ': (' + _err.split('(')[1];
    }

    // Get exception type
    _exception = _err.split(':')[0];
    _methodData = _methodMap(_exception);

    // Check if exception is handled, otherwise fallback to verbose
    if (_methodData != '') {
      _reasonResult = _methodData;
    } else {
      _reasonResult = _msg;
    }

    return _reasonResult;
  }

  @override
  String toString() => 'FileSelectionCanceledError: $_msg';
}

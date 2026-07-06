# file_picker_cross

> The only Flutter plugin to select, open, choose, pick and create documents, images videos or other files on Android, iOS, the desktop and the web for reading, writing, use as String, byte list or HTTP uploads.

## Getting Started

`file_picker_cross` allows you to select, edit and save files from your device and is compatible with Android, iOS, Desktops (using both go-flutter or FDE) and the web.

**Note:** *we recently had API changes. Please update your code accordingly.*

```dart

// show a dialog to open a file
FilePickerCross myFile = await FilePickerCross.importFromStorage(
  type: FileTypeCross.any,       // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
  fileExtension: 'txt, md'     // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
);

// save our file to the fictional directory. It is not necessary that it already exists.
myFile.saveToPath('/my/awesome/folder/' + myFile.fileName);

// save our file to the internal storage or share to other apps
myFile.exportToStorage();

// for sharing to other apps you can also specify optional `text` and `subject`
myFile.exportToStorage(
  subject: "Awesome file",
  text: "Here is the file you've been waiting for",
);

// on iPad you may also need to specify the `sharePositionOrigin` for native share UI
GlobalKey widgetKey = GlobalKey();
...
RenderBox renderBox = widgetKey.currentContext.findRenderObject();
Offset position = renderBox.localToGlobal(Offset.zero);
filePickerCross.exportToStorage(
    position.dx, position.dy, renderBox.size.width, renderBox.size.height);

List<FilePickerCross> myMultipleFiles = await FilePickerCross.importMultipleFromStorage();
print(myMultipleFiles);

// list all previously opened files
List<String> paths = await FilePickerCross.listInternalFiles();
print(paths);

// open an existing file
FilePickerCross anotherFile = FilePickerCross.fromInternalPath(paths[0]);

// delete our perfect file
FilePickerCross.delete(paths[0]);

// get the file storage size
print(await FilePickerCross.quota());

// you can access the following properties on a FilePickerCross instance:

myFile.toString();

myFile.toUint8List();

myFile.toBase64();

myFile.toMultipartFile(filename: 'myFile.txt');

myFile.length;

myFile.path;

myFile.fileName;

myFile.fileExtension;

myFile.directory;
```

To get details about the certain properties and methods, check out the [API documentation](https://pub.dev/documentation/file_picker_cross/latest/file_picker_cross/FilePickerCross-class.html).

## Exception handling

Different platforms will throw different exceptions whether it is due to user action or platform restrictions. For instance, you may want to know if a user had denied access to storage and act upon it. There is a method to help out with that.

```dart
await FilePickerCross.importFromStorage().then(() {
  // ...
}).onError((error, _) {
  String _exceptionData = error.reason();
  print('----------------------');
  print('REASON: ${_exceptionData}');
  if (_exceptionData == 'read_external_storage_denied') {
    print('Permission was denied');
  } else if (_exceptionData == 'selection_canceled') {
    print('User canceled operation');
  } 
  print('----------------------');
});
```

When the `FileSelectionCanceledError` exception is thrown, you can access the `reason()` method to collect underlying exception information. It has a return type of `String`.

Behavior:
- On user cancelation, `selection_canceled` is returned
- When `PlatformException` exception occurs, the raw error value is extracted and then returned (i.e. `read_external_storage_denied`)
- As a fallback, exceptions that were not 'handled' will be returned in full

## The scope of this package

**TL;DR:** *We provide a parallel, platform-independent implementation of a fake file system, in which you can create, open and save files for your app - even on the web. Moreover, we provide APIs to interact with the **real** file system as well to import and export files from and to your device.*

It is very difficult to handle files in cross platform apps. While desktops have one files system used for all apps, mobile platforms have isolated file systems for each app. The web does not really have a working file system available on all browsers. Hence, it is hard to implement storage and access to files on all platforms - and you do not have to because we already did this for you.

With `file_picker_cross`, we provide a fake file system for use in your app. Unlike other packages, we do not only provide a dialog for reading or saving files, but we provide a whole file system *inside* your app's storage, in which you can use any operation like searching files, opening them and saving them. Of cause, there are APIs too for importing files from the shared storage (device storage, home folder, etc.) or exporting to these - even on the web.

### Where files are saved

There are two important methods to export/save files: [`exportToStorage`](https://pub.dev/documentation/file_picker_cross/latest/file_picker_cross/FilePickerCross/exportToStorage.html) and [`saveToPath`](https://pub.dev/documentation/file_picker_cross/latest/file_picker_cross/FilePickerCross/saveToPath.html).

- `exportToStorage` shows a dialog and allows the user to **select** where to save the file.
- `saveToPath` is meant for automated saving in case files are automatically created by an application for further use only **within** the application. For the web, it means, files are stored in the localStorage, on Windows, the path is `%LOCALAPPDATA%\your_app_name\` and on all other platforms the files are stored in `${getApplicationDocumentsDirectory()}/your_app_name/`.

### A word on directories

**Why is isn't it possible to pick directories?** That's what we are asked commonly. There is a simple reason: mobile and web device's security mechanisms.

Anyway, there are two workarounds available, depending on what you plan to do.

If you have plenty of files, you simply need to store somewhere, you may use our provided `saveToPath('/my/path')` API. This allows you to save any file to an app-internal path. See the [API documentation](https://pub.dev/documentation/file_picker_cross/latest/file_picker_cross/FilePickerCross/saveToPath.html) for further details.

Another use case is saving files to a user-defined directory. For single files, you may use the `exportToStorage()` API ([documentation](https://pub.dev/documentation/file_picker_cross/latest/file_picker_cross/FilePickerCross/exportToStorage.html)). But if you want to *once* pick a directory and save continuously save and read files there, it will generally be impossible on most devices except of desktops. All other device types prevent this by their security mechanisms. **On desktops** (and unfortunately *only* on desktops), there is a workaround available:

```dart
// for the first file, you show an export as dialog
FilePickerCross myFile = ...

String pathForExports = await myFile.exportToStorage(); // <- will return the file's path on desktops

// you parse the file's directory and use it for later automated exports.
pathForExports = pathForExports.substring(0,pathForExports.lastIndexOf(r'/'));
print(pathForExports);

// now save the path for later use using shared preferences etc.
...

// next time, check whether you are overwriting an existing file or simply write the file
print(await File(pathForExports+'/myNextFile.csv').exists());
File myCsvFile = await File(pathForExports+'/myNextFile.csv').writeAsString('comma,separated,values'); // <- This only works on desktops. All other devices prevent this.
```

*(Source: [Issue #11](https://gitlab.com/testapp-system/file_picker_cross/-/issues/11#note_406443054))*

Moreover, we plan to support direct write access on certain shared storage locations of the device like Documents, Downloads etc. Our plans on that as well as the API are not ready yet but you might expect this to be supported.

### go-flutter and FDE

Flutter initially only supported Android and iOS. To add support for desktop platforms, some people started the [go-flutter](https://github.com/go-flutter-desktop/go-flutter) providing Flutter applications on Windows, Linux and macOS using the Go language.

Later, Flutter itself announced desktop support (FDE) but still, it's not stable yet.

We try to support both as much as possible.

### Web

Of cause, it requires Flutter to be set up for web development.

[Set up Flutter for Web](https://flutter.dev/web)

### All Desktop platforms

Of cause, it requires Flutter to be set up for your platform.

Please note, Windows is not officially supported by Google. Linux and macOS support is in alpha state. Expect issues and sometimes incompatible versions requiring manual hand work.

```shell
flutter channel dev # or master
flutter upgrade
flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
```

#### More information

[Set up go-flutter](https://hover.build/) or [Set up FDE](https://flutter.dev/desktop)

### Mobile platforms

*No setup required :tada:.*

### macOS (using FDE)

You will need to [add an
entitlement](https://github.com/google/flutter-desktop-embedding/blob/master/macOS-Security.md)
for either read-only access:

```plist
 <key>com.apple.security.files.user-selected.read-only</key>
 <true/>
```

or read/write access:

```plist
 <key>com.apple.security.files.user-selected.read-write</key>
 <true/>
```

depending on your use case.

### Linux (using FDE)

This plugin requires the following libraries:

* GTK 3
* pkg-config
* xdg-user-dirs

Installation example for Debian-based systems:

```shell
sudo apt-get install libgtk-3-dev pkg-config xdg-user-dirs
```

**Note:** You do no longer have to modify any files unlike in previous versions.

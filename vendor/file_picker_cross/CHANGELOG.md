## 4.5.0

* updated dependencies

## 4.4.1

* made path optional

## 4.4.0

* tag to avoid confusion of the latest version number

## 4.3.0

* got rid of non-null-safety dependencies

## 4.2.9

* Removed noisy output
* Added optional parameters subject, text, and sharePositionOrigin to the `FilePickerCross.exportToStorage()` 

## 4.2.8

* Updated dependencies
* Fixed incompatibility with old gradle version

## 4.2.7

* Fixed implementation of save file dialog on desktop platforms requiring leading dots to be doubled

## 4.2.6

* Fixed general errors during file selection on Desktops

## 4.2.5

* Fixed null byte errors on mobile

## 4.2.4

* Fixed incompatibility on mobile devices

## 4.2.3

* Added custom errors

## 4.2.2

* Fixed selection of multiple files on web
* Fixed determination of quota on older web devices

## 4.2.0

* Added option to select multiple files by using `FilePickerCross.importMultipleFromStorage()`

## 4.1.1

* Fixed of by one error when getting file name

## 4.1.0

* implemented `FileQuotaCross` to access statistics like quota or usage of the file system

## 4.0.1

* minor bug fixes

## 4.0.0

* Implemented an emulated file system with support for the web
* Implemented saving files internally and externally
* Created API to import files from local disk into fake filesystem

## 3.1.0

* Added initial support for saving files. Currently, on desktop only.

## 3.0.0

* Breaking API changes. Please update your code.
* Support for getting file path on web

## 2.1.0

* Implemented `String get path` (#1, #5, #6)

## 2.0.0

* Added support for Flutter's official Desktop runtime (FDE)

## 1.2.0

* Fixed crashes on io-Devices (Desktop, Android, iOS) if the fileExtension is empty

## 1.1.0

* Fixed compatibility issues for Android and iOS

## 1.0.0

* Basic functionality working on the web

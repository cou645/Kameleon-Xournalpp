# <img src="assets/xournalpp-adaptive.png" width="64" style="height: auto;"/> Xournal++ Mobile

***Warning:*** *Xournal++ Mobile is currently in development and **not 100%** stable. Use with caution!*

[![Current version](https://img.shields.io/badge/dynamic/yaml?label=Current%20version&query=version&url=https%3A%2F%2Fgitlab.com%2FTheOneWithTheBraid%2Fxournalpp_mobile%2Fraw%2Fmaster%2Fpubspec.yaml%3Finline%3Dfalse&style=for-the-badge&logo=flutter&logoColor=white)](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/tags) [![Bitrise build](https://img.shields.io/bitrise/dd58f8fe5b4bf6c0?style=for-the-badge&token=Ihrbr8U0mqFlVBOocwtnQA&logo=bitrise&logoColor=white)](https://app.bitrise.io/app/dd58f8fe5b4bf6c0) [![Gitlab pipeline status](https://img.shields.io/gitlab/pipeline/TheOneWithTheBraid/xournalpp_mobile/master?style=for-the-badge&logo=gitlab&logoColor=white)](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/pipelines) [![Google Play](https://img.shields.io/endpoint?color=689f38&url=https%3A%2F%2Fplayshields.herokuapp.com%2Fplay%3Fi%3Donline.xournal.mobile%26l%3DGoogle-Play%26m%3D%24version&style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=online.xournal.mobile) [![Snap Store](https://img.shields.io/badge/Get%20it%20from%20the-Snap%20Store-%230e8620?style=for-the-badge&logo=snapcraft&logoColor=white)](https://snapcraft.io/xournalpp-mobile)

A port of the main features of Xournal++ to various Flutter platforms like Android.

![Feature banner](https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile/-/raw/master/assets/feature-banner.svg)

## Try it out

***Mission completed:** We can now render strokes, images and text and LaTeX!. We thereby support the full `.xopp` file format.* :tada:

- Android
  - [Download APK](https://github.com/cou645/kameleon_xournalpp/)

### Visible parts already working

- [x] Read the document title
- [x] Read and display the number of pages
- [x] Create thumbnails of the pages for the navigation bar
- [x] Smooth fade in after thumbnail rendering
- [x] Render images on the canvas
- [x] Render text on the canvas
- [x] Render LaTeX on the canvas
- [x] Strokes (pen)
- [x] Highlighter
- [x] Classic eraser
- [x] Whiteout eraser
- [x] Shape tools (line, rectangle, ellipse)
- [x] Text tool (new text via dialog; existing text edited inline on the page)
- [x] Image insertion from device storage
- [x] Selection tool with hit-testing
- [x] Move, resize and rotate selected objects
- [x] Copy / cut / paste / delete within the app
- [x] Layer management (add, rename, delete, reorder, switch active layer)
- [x] Page backgrounds (plain, lined, ruled, graph, dotted; PDF or image)
- [x] Recent files list
- [x] Saving
- [x] Basic PDF rendering
- [x] Export page to PNG
- [x] Export document to PDF

## Known issues

- **Immense memory consumption**: *If you open immense files, you get immense memory consumption. That's logic. Usually, Xournal++ Mobile takes twice the file size plus around 50MB for itself.*
- But **why** does it take twice the memory?: *No idea. ¯\\\_(ツ)_/¯*
- **The snap does not start on Linux when using wayland**: *Please set the environment variable `DISABLE_WAYLAND=1` before you start Xournal++ Mobile.*

## Getting started


Get your information about the `.xopp` file format at http://www-math.mit.edu/~auroux/software/xournal/manual.html#file-format .

Install Flutter first. See [flutter.dev](https://flutter.dev/docs/get-started/install) for more details.

```shell
# Run Flutter doctor to check whether the installation was successful
flutter doctor
```

### Get the sources and run

Connect any Android or iOS device, or enable a desktop target (see below).

```shell
git clone https://gitlab.com/TheOneWithTheBraid/xournalpp_mobile.git
cd xournalpp_mobile
flutter pub get
flutter run
```
If you want to test for Linux, Windows or macOS, please run:

```shell
flutter config --enable-linux-desktop # or --enable-macos-desktop or --enable-windows-desktop
flutter run -d linux # or macos or windows
```

### Feature roadmap

See [FEATURES.md](FEATURES.md) for the full feature list and [TODO.md](TODO.md) for the roadmap to desktop parity.

### Fonts

- Display Text: Open Sans Extra Bold *(800)* `Apache 2.0`, *accent color* or *light color*
- Title and Heading: Open Sans Regular *(400)* `Apache 2.0`, *light color*
- Emphasis: Glacial Indifference Regular *(400)* `SIL Open Font License`, *light color*, *UPPERCASE*
- Body: Open Sans Light *(300)* `Apache 2.0`, *light color*

## Misc

*Like this project? [Donate via PayPal]: cou645@gmail.com


## Legal notes

This project is licensed under the terms and conditions of the EUPL-1.2 found in [LICENSE](LICENSE).
This software is without warranty, use at own risk.

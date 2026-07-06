# Xournal++ Mobile — Feature List

## Core note-taking
- Create, open and save Xournal++ (`.xopp`) files
- Multiple pages per document with add / delete / reorder support
- Undo / redo history for page content
- Recent files list with preview thumbnails
- Auto-save of tool color and stroke width preferences

## Drawing tools
- Pen with pressure-sensitive width
- Highlighter with adjustable opacity
- Real whiteout eraser that removes underlying strokes
- Classic eraser
- Shape tools: line, rectangle, ellipse
- Text tool with rotation (new text is created via a dialog; existing text can be edited inline on the page)
- Image insertion from device storage

## Selection and editing
- Tap-to-select any object (strokes, text, images)
- Move, scale and rotate selected objects via on-canvas handles
- Copy / cut / paste / delete within the app
- Clipboard persists for the current editing session

## Layers
- Add, rename, reorder and delete layers
- Current-layer drawing and selection
- Layer names preserved in `.xopp` files

## Page backgrounds
- Lined, ruled, graph and dotted paper styles
- Plain solid-color background
- Import PDF as page background
- Import image as page background

## Import / export / sharing
- Export any page to PNG and share
- Export the whole document to PDF
- Import existing PDF documents
- Share screenshots of pages
- “Send to KP” network export

## UI and localization
- Light / dark theme support
- Localized UI in English, German, Portuguese and Welsh
- Responsive canvas with pinch-to-zoom and pan
- Bottom page thumbnail strip for quick navigation

## Desktop compatibility
- Preserves Xournal++ stroke attributes, layer names, page backgrounds and rotation
- Round-trips files with desktop Xournal++

## Build and platform compatibility
- Modernized for Flutter 3.41, Android Gradle Plugin 8 and Kotlin 1.9
- Targets Android, iOS, Web, Linux, Windows and macOS
- Null-safe Dart 3 codebase

## Known limitations and roadmap
A few commonly requested features are not yet implemented, including inline text creation, layer visibility toggles, duplicate page, custom page sizes, drag-to-reorder pages, multiple selection / lasso select, and undo/redo per layer. See [TODO.md](TODO.md) for the full roadmap and suggested next tasks.

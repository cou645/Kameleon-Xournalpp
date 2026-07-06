# Xournal++ Mobile — Roadmap to Desktop Parity

This file tracks what has been implemented and what remains to bring the Flutter companion app closer to the desktop Xournal++ feature set.

## Recently completed

- [x] Build modernization for Flutter 3.41 / AGP 8 / Kotlin 1.9.
- [x] Media-file embedding and Android 13+ file picker fixes.
- [x] Data-loss bug fixes:
  - Text save crash (`fontFamily` default + XML escaping).
  - Desktop eraser strokes preserved on import.
  - Dotted background import.
  - Layer names round-trip.
  - Background image/PDF `domain` attribute round-trip.
  - Stroke `capStyle`, `fill`, `style`, audio `ts`/`fn` attribute round-trip.
- [x] Move / resize / rotate for all content types.
- [x] Selection tool with hit-testing.
- [x] Copy / cut / paste / delete clipboard.
- [x] Layer management UI (add, rename, delete, reorder, switch active layer).
- [x] Shape tools: line, rectangle, ellipse.
- [x] Real whiteout tool (erases underlying ink instead of drawing white strokes).
- [x] PDF export (full-resolution, one PDF page per note page).
- [x] Set PDF or image as page background from the UI.
- [x] Top-bar and drawer theming fixes for readability.

## Known gaps vs. desktop

### High value / commonly used

- [ ] **Text editing inline** — currently a dialog; desktop allows direct on-page text boxes.
- [ ] **LaTeX editing inline / preview improvements** — currently a dialog and simple Math.tex widget.
- [ ] **Image cropping / replacement** — no way to change an embedded image after insertion.
- [ ] **Page management parity**:
  - [ ] Duplicate page.
  - [ ] Page size customisation (currently fixed presets + PDF/image size).
  - [ ] Reorder pages via drag-and-drop in the page list.
- [ ] **Layer visibility toggle** — layers can be reordered/renamed but not hidden.
- [ ] **Multiple selection / lasso select** — only single-tap selection exists.
- [ ] **Undo/redo per layer** — undo stack snapshots the active layer, but switching layers does not swap undo stacks.

### Medium value

- [ ] **Stroke smoothing / pressure curves** — pressure is used raw; desktop has configurable smoothing.
- [ ] **Fill and style for strokes** — attributes are preserved but not editable in the UI.
- [ ] **Cap style for strokes** — preserved but not editable.
- [ ] **Default tool preferences** — persist default pen color/width per tool.
- [ ] **Grid/snapping** — no snap-to-grid or ruler assistance.
- [ ] **Hand tool vs. MOVE** — MOVE currently enables zoom/pan; a dedicated pan hand would be clearer.
- [ ] **Recent files / home screen improvements** — thumbnails, search, sort.

### Large / lower priority for companion app

- [ ] **Audio recording and playback** — `ts`/`fn` attributes are preserved, but no actual recorder/player exists.
- [ ] **PDF annotation import** — importing an annotated PDF and editing its annotations.
- [ ] **Plugins / Lua scripting** — desktop plugin system.
- [ ] **Laser pointer / presentation mode** — ephemeral red dot.
- [ ] **Shape recognizer** — convert rough strokes to perfect lines/rectangles/ellipses.
- [ ] **Geometric assist tools** — ruler, compass, etc.
- [ ] **Shared stylus button mapping** — e.g. eraser side button on S Pen / Apple Pencil.
- [ ] **Collaborative / cloud sync** — beyond local files.

## Suggested next tasks (in order of impact)

1. **Inline text editing** — biggest daily usability win over the dialog.
2. **Layer visibility toggle** — small UI change, large workflow benefit.
3. **Duplicate / custom page size / drag-to-reorder pages** — page management parity.
4. **Multiple selection / lasso** — complements move/resize/rotate.
5. **Audio recording/playback** — only if explicitly requested; large scope.

## Out of scope for the initial companion push

- Plugin / Lua scripting.
- Presentation/laser pointer mode.
- Advanced geometric tools (ruler, compass, shape recognizer).
- Cloud sync.

## Notes

- Many desktop XML attributes that are not yet editable are already **preserved** on import/export, so round-tripping through the mobile app does not destroy desktop features.
- The app is currently a **companion**: it reads and edits desktop `.xopp` files while gracefully degrading unsupported features rather than dropping them.

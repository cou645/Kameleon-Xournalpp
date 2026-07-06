import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/src/XppBackground.dart';
import 'package:xournalpp/src/XppPage.dart';

class ToolBoxBottomSheet extends StatefulWidget {
  @required
  final EditingTool? tool;
  final Function(EditingTool)? onToolChange;
  final Function(XppBackground)? onBackgroundChange;

  const ToolBoxBottomSheet(
      {Key? key, this.tool, this.onToolChange, this.onBackgroundChange})
      : super(key: key);

  @override
  _ToolBoxBottomSheetState createState() => _ToolBoxBottomSheetState();
}

class _ToolBoxBottomSheetState extends State<ToolBoxBottomSheet> {
  double _height = 320;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {
          Navigator.of(context).pop();
        },
        elevation: 16,
//        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        builder: (context) => Container(
              height: _height,
              child: ListView(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                children: [
                  Text(
                    S.of(context).pageBackground,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                    height: 128,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: SizedBox(
                                      width: 96,
                                      height: 96,
                                      child: XppBackground.none.render()),
                                ),
                                Text('None')
                              ],
                            ),
                            onTap: () =>
                                widget.onBackgroundChange!(XppBackground.none),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: XppBackgroundSolidPlain(
                                          size: XppPageSize(
                                              width: 96, height: 96),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary)
                                      .render(),
                                ),
                                Text(S.of(context).color)
                              ],
                            ),
                            onTap: () async => widget.onBackgroundChange!(
                                XppBackgroundSolidPlain(
                                    color: await pickBackgroundColor())),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: XppBackgroundSolidLined(
                                          size: XppPageSize(
                                              width: 96, height: 96))
                                      .render(),
                                ),
                                Text(S.of(context).lined)
                              ],
                            ),
                            onTap: () async => widget.onBackgroundChange!(
                                XppBackgroundSolidLined(
                                    color: await pickBackgroundColor())),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: XppBackgroundSolidRuled(
                                          size: XppPageSize(
                                              width: 96, height: 96))
                                      .render(),
                                ),
                                Text(S.of(context).ruled)
                              ],
                            ),
                            onTap: () async => widget.onBackgroundChange!(
                                XppBackgroundSolidRuled(
                                    color: await pickBackgroundColor())),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: XppBackgroundSolidGraph(
                                          size: XppPageSize(
                                              width: 96, height: 96))
                                      .render(),
                                ),
                                Text(S.of(context).graph)
                              ],
                            ),
                            onTap: () async => widget.onBackgroundChange!(
                                XppBackgroundSolidGraph(
                                    color: await pickBackgroundColor())),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: XppBackgroundSolidDot(
                                          size: XppPageSize(
                                              width: 96, height: 96))
                                      .render(),
                                ),
                                Text(S.of(context).dotted)
                              ],
                            ),
                            onTap: () async => widget.onBackgroundChange!(
                                XppBackgroundSolidDot(
                                    color: await pickBackgroundColor())),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: Icon(Icons.picture_as_pdf, size: 48),
                                ),
                                Text(S.of(context).pdf)
                              ],
                            ),
                            onTap: () => _pickPdfBackground(),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: Icon(Icons.image, size: 48),
                                ),
                                Text(S.of(context).image)
                              ],
                            ),
                            onTap: () => _pickImageBackground(),
                          ),
                        ),
                      ],
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                ],
              ),
            ));
  }

  Future<Color?> pickBackgroundColor() async => await showDialog(
      context: context,
      builder: (c) => AlertDialog(
            content: MaterialPicker(
              pickerColor: Colors.white,
              onColorChanged: (newColor) => Navigator.of(context).pop(newColor),
            ),
          ));

  Future<void> _pickPdfBackground() async {
    try {
      final picked = await FilePickerCross.importFromStorage(
          type: FileTypeCross.custom, fileExtension: 'pdf');
      if (picked.path == null) return;
      final pageNo = await _askPdfPage() ?? 1;
      widget.onBackgroundChange!(XppBackgroundPdf(
        onUnavailable: (_) async => throw 'PDF background not available',
        filename: picked.path,
        page: pageNo,
      ));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).couldNotSetPdfBackground(e.toString()))));
    }
  }

  Future<void> _pickImageBackground() async {
    try {
      final picked =
          await FilePickerCross.importFromStorage(type: FileTypeCross.image);
      if (picked.path == null) return;
      widget.onBackgroundChange!(
          XppBackgroundImage(filename: picked.path));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).couldNotSetImageBackground(e.toString()))));
    }
  }

  Future<int?> _askPdfPage() async {
    final controller = TextEditingController(text: '1');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).pdfPage),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: S.of(context).pageNumber),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(int.tryParse(controller.text) ?? 1);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return result;
  }
}

enum EditingTool {
  STYLUS,
  HIGHLIGHT,
  TEXT,
  LATEX,
  IMAGE,
  MOVE,
  SELECT,
  ERASER,
  WHITEOUT,
  LINE,
  RECTANGLE,
  ELLIPSE,
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'dart:io' show Platform;
import 'package:xournalpp/widgets/ToolBoxBottomSheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xournalpp/widgets/ToolSettingDialog.dart';

class EditingToolBar extends StatefulWidget {
  final Function(Map<PointerDeviceKind?, EditingTool>?)? onNewDeviceMap;
  final Function(double newWidth)? onWidthChange;
  final Map<PointerDeviceKind?, EditingTool>? deviceMap;
  final Function(Color)? onColorChange;
  final Function()? getColor;
  final Function()? getWidth;
  final VoidCallback? onImageTapped;

  const EditingToolBar(
      {Key? key,
      this.onNewDeviceMap,
      this.deviceMap,
      this.onWidthChange,
      this.onColorChange,
      this.getColor,
      this.getWidth,
      this.onImageTapped})
      : super(key: key);

  @override
  EditingToolBarState createState() => EditingToolBarState();
}

class EditingToolBarState extends State<EditingToolBar> {
  PointerDeviceKind? currentDevice;

  double width = 2.5;

  @override
  Widget build(BuildContext context) {
    initializeTool();
    return Container(
      height: 64,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: MouseRegion(
        onHover: (event) {
          currentDevice = event.kind;
        },
        child: ListView(
          children: [
            getInkwellButton(EditingTool.STYLUS, FontAwesomeIcons.penAlt, enableSettings: true),
            getInkwellButton(EditingTool.HIGHLIGHT, FontAwesomeIcons.highlighter, enableSettings: true),
            getInkwellButton(EditingTool.MOVE, Icons.pan_tool, usePrimaryColor: true),
            getInkwellButton(EditingTool.TEXT, Icons.keyboard, usePrimaryColor: true),
            getInkwellButton(EditingTool.LATEX, Icons.science, usePrimaryColor: true),
            getInkwellButton(EditingTool.ERASER, FontAwesomeIcons.eraser, enableSettings: true, usePrimaryColor: true),
            getInkwellButton(EditingTool.WHITEOUT, Icons.format_paint, usePrimaryColor: true),
            getInkwellButton(EditingTool.IMAGE, Icons.add_photo_alternate, usePrimaryColor: true, onTapExtra: widget.onImageTapped),
            getInkwellButton(EditingTool.LINE, Icons.show_chart, usePrimaryColor: true),
            getInkwellButton(EditingTool.RECTANGLE, Icons.check_box_outline_blank, usePrimaryColor: true),
            getInkwellButton(EditingTool.ELLIPSE, Icons.radio_button_unchecked, usePrimaryColor: true),
            getInkwellButton(EditingTool.SELECT, Icons.tab_unselected, usePrimaryColor: true),
            if (_hasSettings(getTool()))
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FloatingActionButton(
                  heroTag: 'toolSettings',
                  onPressed: () => showCustomDialog(context),
                  child: const Icon(Icons.tune),
                  tooltip: S.of(context).colorAndThickness,
                ),
              ),
          ],
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  void saveDeviceTable() => widget.onNewDeviceMap!(widget.deviceMap);

  void showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return ToolSettingDialog(width: widget.getWidth!(), color: widget.getColor!(), onColorChange: widget.onColorChange, onWidthChange: widget.onWidthChange);
      },
    );
  }

  InkWell getInkwellButton(EditingTool tool, IconData icon, {bool enableSettings = false, bool usePrimaryColor = false, VoidCallback? onTapExtra}) {
    return InkWell(
      onLongPress: () {},
      child: FloatingActionButton(
        heroTag: tool,
        onPressed: () {
          if(enableSettings && getTool() == tool){
            showCustomDialog(context);
          } else {
            setState(() => setTool(tool));
            saveDeviceTable();
            onTapExtra?.call();
          }
        },
        child: FaIcon(icon),
        elevation: 6,
        foregroundColor: Colors.white,
        backgroundColor:
        getTool() == tool ? (!usePrimaryColor ? widget.getColor!() : Theme.of(context).colorScheme.primary) : Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }

  void initializeTool() {
    if(getTool() == null) {
      setTool(EditingTool.STYLUS);
    }
  }

  void setTool(EditingTool tool){
    PointerDeviceKind? device = currentDevice;
    if (Platform.isAndroid || Platform.isIOS) {
      device = PointerDeviceKind.touch;
    }
    widget.deviceMap![device] = tool;
  }

  EditingTool? getTool() {
    PointerDeviceKind? device = currentDevice;
    if (Platform.isAndroid || Platform.isIOS) {
      device = PointerDeviceKind.touch;
    }
    return widget.deviceMap![device];
  }

  bool _hasSettings(EditingTool? tool) {
    return tool == EditingTool.STYLUS ||
        tool == EditingTool.HIGHLIGHT ||
        tool == EditingTool.ERASER;
  }
}



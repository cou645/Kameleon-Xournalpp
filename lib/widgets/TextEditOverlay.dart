import 'package:flutter/material.dart';
import 'package:xournalpp/layer_contents/XppText.dart';

/// An on-canvas text editor for an [XppText] object.
class TextEditOverlay extends StatefulWidget {
  final XppText text;
  final double maxWidth;
  final ValueChanged<String> onDone;
  final VoidCallback onCancel;

  const TextEditOverlay({
    Key? key,
    required this.text,
    required this.maxWidth,
    required this.onDone,
    required this.onCancel,
  }) : super(key: key);

  @override
  _TextEditOverlayState createState() => _TextEditOverlayState();
}

class _TextEditOverlayState extends State<TextEditOverlay> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text.text);
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _finish() {
    widget.onDone(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: widget.text.color ?? Colors.black,
      fontSize: widget.text.size ?? 16,
      fontFamily: widget.text.fontFamily,
    );

    return Positioned(
      left: widget.text.offset!.dx,
      top: widget.text.offset!.dy,
      child: Container(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Material(
          color: Colors.transparent,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: style,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            onSubmitted: (_) => _finish(),
            onEditingComplete: () {},
            onTapOutside: (_) => _finish(),
          ),
        ),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppLayer.dart';

/// A transformed bounding box with drag handles for moving, scaling and
/// rotating a selected [XppContent] object.
class ObjectSelectionOverlay extends StatefulWidget {
  final XppContent content;
  final VoidCallback onChanged;
  final VoidCallback onCommit;
  final VoidCallback? onCopy;
  final VoidCallback? onCut;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ObjectSelectionOverlay(
      {Key? key,
      required this.content,
      required this.onChanged,
      required this.onCommit,
      this.onCopy,
      this.onCut,
      this.onDelete,
      this.onEdit})
      : super(key: key);

  @override
  _ObjectSelectionOverlayState createState() => _ObjectSelectionOverlayState();
}

enum _HandleType { move, scale, rotate }

class _ObjectSelectionOverlayState extends State<ObjectSelectionOverlay> {
  @override
  Widget build(BuildContext context) {
    final bounds = widget.content.getBounds();
    const handleSize = 24.0;
    const half = handleSize / 2;

    return Positioned(
      left: bounds.left - half,
      top: bounds.top - half,
      width: math.max(math.max(bounds.width, 1.0), 20.0) + handleSize,
      height: math.max(math.max(bounds.height, 1.0), 20.0) + handleSize,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (_) => _beginGesture(_HandleType.move),
        onPanUpdate: (details) {
          widget.content.translate(details.delta);
          widget.onChanged();
        },
        onPanEnd: (_) => widget.onCommit(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // selection border
            Container(
              margin: const EdgeInsets.all(half),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, width: 1.5),
              ),
            ),
            // action buttons (top-right)
            Positioned(
              top: 0,
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(Icons.copy, widget.onCopy),
                  _buildActionButton(Icons.cut, widget.onCut),
                  _buildActionButton(Icons.delete, widget.onDelete),
                ],
              ),
            ),
            // scale handle (bottom-right)
            _buildHandle(
              alignment: Alignment.bottomRight,
              icon: Icons.open_in_full,
              type: _HandleType.scale,
            ),
            // rotate handle (top-center)
            _buildHandle(
              alignment: Alignment.topCenter,
              icon: Icons.rotate_right,
              type: _HandleType.rotate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(
      {required Alignment alignment,
      required IconData icon,
      required _HandleType type}) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) => _beginGesture(type),
        onPanUpdate: (details) => _handleUpdate(details, type),
        onPanEnd: (_) => widget.onCommit(),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Icon(icon, size: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback? onPressed) {
    if (onPressed == null) return SizedBox.shrink();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.only(left: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  void _beginGesture(_HandleType type) {
    // Push a single undo snapshot for the whole gesture.
    widget.onCommit();
  }

  void _handleUpdate(DragUpdateDetails details, _HandleType type) {
    final bounds = widget.content.getBounds();
    if (type == _HandleType.scale) {
      // Scale uniformly around the top-left corner. Dragging right/down grows.
      final denom = math.max(math.max(bounds.width, bounds.height), 20.0);
      final scaleDelta = 1 + details.delta.dx / denom;
      if (scaleDelta > 0.1) {
        widget.content.applyScaleDelta(scaleDelta, anchor: bounds.topLeft);
      }
    } else if (type == _HandleType.rotate) {
      // Dragging left/right rotates around the bounding-box center.
      final radians = details.delta.dx / 80;
      widget.content.applyRotationDelta(radians, center: bounds.center);
    }
    widget.onChanged();
  }
}

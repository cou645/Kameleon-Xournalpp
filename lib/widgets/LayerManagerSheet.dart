import 'package:flutter/material.dart';
import 'package:xournalpp/generated/l10n.dart';
import 'package:xournalpp/src/XppLayer.dart';
import 'package:xournalpp/src/XppPage.dart';

class LayerManagerSheet extends StatelessWidget {
  final XppPage page;
  final int currentLayer;
  final ValueChanged<int> onLayerSelected;
  final VoidCallback onAddLayer;
  final Function(int index, String name) onRename;
  final Function(int index) onDelete;
  final Function(int index, int delta) onMove;

  const LayerManagerSheet({
    Key? key,
    required this.page,
    required this.currentLayer,
    required this.onLayerSelected,
    required this.onAddLayer,
    required this.onRename,
    required this.onDelete,
    required this.onMove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layers = page.layers!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(S.of(context).layers,
                style: Theme.of(context).textTheme.titleLarge),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              tooltip: S.of(context).addLayer,
              onPressed: () {
                Navigator.of(context).pop();
                onAddLayer();
              },
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: layers.length,
              itemBuilder: (context, index) {
                final layer = layers[index];
                final isActive = index == currentLayer;
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: index > 0
                            ? () => onMove(index, -1)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: index < layers.length - 1
                            ? () => onMove(index, 1)
                            : null,
                      ),
                    ],
                  ),
                  title: GestureDetector(
                    onTap: () => _rename(context, index, layer),
                    child: Text(layer.name?.isNotEmpty == true
                        ? layer.name!
                        : 'Layer ${index + 1}'),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive)
                        const Icon(Icons.check, color: Colors.green)
                      else
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onLayerSelected(index);
                          },
                          child: const Text('SELECT'),
                        ),
                      if (layers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            Navigator.of(context).pop();
                            onDelete(index);
                          },
                        ),
                    ],
                  ),
                  selected: isActive,
                  onTap: () {
                    Navigator.of(context).pop();
                    onLayerSelected(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _rename(BuildContext context, int index, XppLayer layer) {
    final controller =
        TextEditingController(text: layer.name ?? 'Layer ${index + 1}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).renameLayer),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: S.of(context).layerName),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(S.of(ctx).cancel)),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              onRename(index, controller.text.trim());
            },
            child: Text(S.of(ctx).apply),
          ),
        ],
      ),
    );
  }
}

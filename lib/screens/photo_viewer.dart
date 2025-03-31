import 'dart:io';

import 'package:digident/services/string_manipulators.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PhotoViewer extends StatefulWidget {
  final File photo;
  final VoidCallback onDelete;

  const PhotoViewer({super.key, required this.photo, required this.onDelete});

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Viewer'), elevation: 4),
      body: Column(
        children: [
          InteractiveViewer(child: Center(child: Image.file(widget.photo))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              formatDateTime("${File(widget.photo.path).lastModifiedSync()}"),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final bool? confirmDelete = await showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Delete Photo'),
                          content: const Text(
                            'Are you sure you want to delete this photo?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                  );

                  if (confirmDelete == true) {
                    await File(widget.photo.path).delete();
                    widget
                        .onDelete(); // Notify Smart Gallery View to update itself
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  // Share functionality
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  await Share.shareXFiles(
                    [XFile(widget.photo.path)],
                    subject: formatDateTime(
                      "${File(widget.photo.path).lastModifiedSync()}",
                    ),
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size,
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

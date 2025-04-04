import 'dart:io';

import 'package:digident/services/image_classification_service.dart';
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
  // Variables ------

  bool? isPredicted;
  Map<String, double> prediction = {};
  @override
  Widget build(BuildContext context) {
    // ----------------

    // Widgets ---------
    ElevatedButton deleteButton = ElevatedButton.icon(
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
          widget.onDelete(); // Notify Smart Gallery View to update itself
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      icon: const Icon(Icons.delete),
      label: const Text('Delete'),
    );

    ElevatedButton shareButton = ElevatedButton.icon(
      onPressed: () async {
        // Share functionality
        final RenderBox box = context.findRenderObject() as RenderBox;
        await Share.shareXFiles(
          [XFile(widget.photo.path)],
          subject: formatDateTime(
            "${File(widget.photo.path).lastModifiedSync()}",
          ),
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        );
      },
      icon: const Icon(Icons.share),
      label: const Text('Share'),
    );

    ElevatedButton predictButton = ElevatedButton.icon(
      onPressed: () async {
        ImageClassificationService aiService = ImageClassificationService();
        setState(() {
          isPredicted = false;
        });
        Map<String, dynamic> gottenPrediction = await aiService.classifyImage(
          await widget.photo.readAsBytes(),
        );

        prediction = gottenPrediction.map(
          (key, value) => MapEntry(key, value as double),
        );

        setState(() {
          isPredicted = true;
        });
      },
      icon: const Icon(Icons.analytics),
      label: const Text("Predict"),
    );

    Widget predictionResult =
        isPredicted == null
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Press the button to predict",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
            : isPredicted == false
            ? const CircularProgressIndicator()
            : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Prediction Result",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...prediction.entries.map((entry) {
                    final isHighest =
                        entry.value ==
                        prediction.values.reduce((a, b) => a > b ? a : b);
                    return Text(
                      "${entry.key}: ${entry.value.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isHighest ? FontWeight.bold : FontWeight.normal,
                        color:
                            isHighest
                                ? (entry.key == "No Caries"
                                    ? Colors.green
                                    : entry.key == "Intermediate Caries"
                                    ? Colors.orange
                                    : Colors.red)
                                : Colors.black,
                      ),
                    );
                  }),
                ],
              ),
            );

    // -----------------

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
            children: [deleteButton, shareButton],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Divider(thickness: 2),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "AI Analysis",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                predictButton,
              ],
            ),
          ),
          const SizedBox(height: 30),
          Align(alignment: Alignment.topLeft, child: predictionResult),
        ],
      ),
    );
  }
}

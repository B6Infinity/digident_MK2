import 'dart:io';

import 'package:flutter/material.dart';
import '../widgets/camera_view_widget.dart';

class CameraViewScreen extends StatefulWidget {
  const CameraViewScreen({super.key});

  @override
  State<CameraViewScreen> createState() => _CameraViewScreenState();
}

class _CameraViewScreenState extends State<CameraViewScreen> {
  bool _isCapturingPhoto = false;

  @override
  Widget build(BuildContext context) {
    File? lastPhoto;

    // Widgets -------
    AppBar appBar = AppBar(
      title: const Text('DigiDent Device Stream'),
      centerTitle: true,
      elevation: 2,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );

    Widget cameraView = Expanded(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: CameraViewWidget(),
        ),
      ),
    );

    Widget captureWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Capture Button
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _isCapturingPhoto = true;
            });
            // Call the method to capture and save the photo
            // lastPhoto = await CameraViewWidget.captureAndSavePhoto();
            lastPhoto = null;
            print("BUTEL!!!");
            await Future.delayed(const Duration(seconds: 1));
            if (lastPhoto != null) {
              // Update the state to show the preview of the last photo
              // This requires converting this StatelessWidget to StatefulWidget
            }
            setState(() {
              _isCapturingPhoto = false;
            });
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child:
              _isCapturingPhoto
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Icon(Icons.camera_alt, size: 32, color: Colors.white),
        ),
        const SizedBox(width: 16),
        // Last Photo Preview
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                lastPhoto != null
                    ? Image.file(lastPhoto!, fit: BoxFit.cover)
                    : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
          ),
        ),
      ],
    );

    // ---------------

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cameraView,
              captureWidget,
              // Make sure ... message
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Make sure you are connected to the DigiDent WiFi',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

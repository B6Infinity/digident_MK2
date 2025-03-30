import 'package:flutter/material.dart';
import '../widgets/camera_view_widget.dart';

class CameraViewScreen extends StatelessWidget {
  const CameraViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

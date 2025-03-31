// camera_view_widget.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/udp_service.dart';

class CameraViewWidget extends StatefulWidget {
  const CameraViewWidget({super.key});

  @override
  State<CameraViewWidget> createState() => _CameraViewWidgetState();
}

class _CameraViewWidgetState extends State<CameraViewWidget> {
  final UDPService _udpService = UDPService();
  Uint8List? _currentFrame;
  bool _isConnected = false;
  String? _errorMessage;

  // Capture Variables
  bool _isCapturingPhoto = false;
  File? lastPhoto;

  @override
  void initState() {
    super.initState();
    _initializeUDPService();
  }

  @override
  void dispose() {
    _udpService.dispose();
    super.dispose();
  }

  // <Future>s -----

  Future<void> _initializeUDPService() async {
    try {
      await _udpService.initialize();

      _udpService.onFrameReceived = (Uint8List frameData) {
        if (mounted) {
          setState(() {
            _currentFrame = frameData;
            _errorMessage = null;
          });
        }
      };

      _udpService.onConnectionStateChanged = (bool connected) {
        if (mounted) {
          setState(() {
            _isConnected = connected;
            if (!connected) {
              _currentFrame = null;
            }
          });
        }
      };

      _udpService.onError = (String error) {
        if (mounted) {
          setState(() {
            _errorMessage = error;
          });
        }
      };
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize camera stream: $e';
        });
      }
    }
  }

  Future<void> _retryConnection() async {
    if (mounted) {
      setState(() {
        _errorMessage = null;
      });
    }
    await _initializeUDPService();
  }

  Future<Uint8List> captureAndSavePhoto() async {
    while (_currentFrame == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    return _currentFrame!;
  }

  // Widgets -------

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _retryConnection,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoConnectionWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_off,
            size: 48,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          const Text('No connection to camera server'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _retryConnection,
            icon: const Icon(Icons.refresh),
            label: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  Widget get captureWidget => Row(
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

  Widget _buildCameraPreview() {
    if (_currentFrame == null) {
      return const Center(child: Text('Waiting for video stream...'));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(
          _currentFrame!,
          gaplessPlayback: true,
          fit: BoxFit.contain,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return child;
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  const Text('Error loading frame'),
                ],
              ),
            );
          },
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  _isConnected
                      ? Colors.green.withAlpha((0.7 * 255).toInt())
                      : Colors.red.withAlpha((0.7 * 255).toInt()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isConnected ? Colors.red : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        Positioned(bottom: 16, left: 0, right: 0, child: captureWidget),
      ],
    );
  }

  // ---------------

  @override
  Widget build(BuildContext context) {
    Widget? childWidget;

    if (_errorMessage != null) {
      childWidget = _buildErrorWidget();
    } else if (!_isConnected) {
      childWidget = _buildNoConnectionWidget();
    } else {
      childWidget = _buildCameraPreview();
    }

    Widget cameraView = Expanded(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(12),
        ),
        child: childWidget,
      ),
    );

    return cameraView;
  }
}

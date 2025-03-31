// ignore_for_file: avoid_print

import 'dart:io';

import 'package:digident/screens/photo_viewer.dart';
import 'package:digident/services/string_manipulators.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SmartGallery extends StatefulWidget {
  const SmartGallery({super.key});

  @override
  State<SmartGallery> createState() => _SmartGalleryState();
}

class _SmartGalleryState extends State<SmartGallery> {
  late Directory capturedPhotosDirectory;
  bool _isDirectoryInitialized = false;

  @override
  void initState() {
    super.initState();

    // Ensure the "captured_photos" directory exists
    _initializeCapturedPhotosDirectory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeCapturedPhotosDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    capturedPhotosDirectory = Directory('${appDirectory.path}/captured_photos');
    if (!await capturedPhotosDirectory.exists()) {
      await capturedPhotosDirectory.create(recursive: true);
      print("[INFO] ${appDirectory.path}/captured_photos -> Created directory");
    } else {
      print(
        "[INFO] ${appDirectory.path}/captured_photos -> Directory already exists",
      );
    }

    // `/data/user/0/com.example.digident/app_flutter/captured_photos`

    setState(() {
      _isDirectoryInitialized = true;
    });
  }

  // Widgets --------

  Widget get galleryView => FutureBuilder<List<FileSystemEntity>>(
    future: capturedPhotosDirectory.list().toList(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No photos found."));
      }

      print("Found ${snapshot.data!.length} photos");

      final photos =
          snapshot.data!
              .where(
                (entity) =>
                    entity is File &&
                    (entity.path.endsWith('.jpg') ||
                        entity.path.endsWith('.png')),
              )
              .map((entity) => entity as File)
              .toList();

      // Sort photos by last modified date (most recent first)
      photos.sort((a, b) {
        final aDate = a.lastModifiedSync();
        final bDate = b.lastModifiedSync();
        return bDate.compareTo(aDate);
      });

      print("Sorted ${photos.length} photos");

      // Group photos by date
      final groupedPhotos = <String, List<File>>{};
      for (var photo in photos) {
        final date =
            photo.lastModifiedSync().toLocal().toString().split(' ')[0];
        groupedPhotos.putIfAbsent(date, () => []).add(photo);
      }

      print(groupedPhotos);

      return ListView.builder(
        itemCount: groupedPhotos.keys.length,
        itemBuilder: (context, index) {
          final date = groupedPhotos.keys.elementAt(index);
          final datePhotos = groupedPhotos[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatDate(date),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: datePhotos.length,
                itemBuilder: (context, photoIndex) {
                  final photo = datePhotos[photoIndex];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PhotoViewer(
                                photo: photo,
                                onDelete: () => setState(() {}),
                              ),
                        ),
                      );
                    },
                    child: Image.file(photo, fit: BoxFit.cover),
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );

  // ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Gallery"),
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body:
          !_isDirectoryInitialized
              ? Center(child: CircularProgressIndicator())
              : galleryView,
    );
  }
}

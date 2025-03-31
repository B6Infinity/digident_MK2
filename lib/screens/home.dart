import 'package:digident/config/app_config.dart';
import 'package:digident/screens/camera_view_screen.dart';
import 'package:digident/screens/smart_gallery.dart';
import 'package:digident/services/input_field_controllers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // Widgets ----
    final Drawer homeDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'App configuration',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Host IP',
                    border: OutlineInputBorder(),
                  ),
                  controller: configHostIP_Controller,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Host Port',
                    border: OutlineInputBorder(),
                  ),
                  // keyboardType: TextInputType.number,
                  controller: configHostPORT_Controller,
                  readOnly: true,
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Buffer Size',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  controller: TextEditingController(
                    text: "${AppConfig.MAX_BUFFER_SIZE}",
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Save the updated values to app_config.dart
                    AppConfig.SERVER_IP = configHostIP_Controller.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Host IP updated to ${AppConfig.SERVER_IP}',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    FocusScope.of(context).unfocus(); // Close the keyboard
                    Navigator.of(context).pop(); // Close the drawer
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget screenSelector = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                // Navigate to the live camera feed screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraViewScreen()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.blue),
                    SizedBox(width: 16),
                    Text(
                      'Live Camera Feed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SmartGallery()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.photo_library, size: 40, color: Colors.green),
                    SizedBox(width: 16),
                    Text(
                      'Smart Gallery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // ------------

    return Scaffold(
      appBar: AppBar(
        title: Text("DigiDent MK2"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 4,
      ),
      drawer: homeDrawer,
      body: screenSelector,
    );
  }
}

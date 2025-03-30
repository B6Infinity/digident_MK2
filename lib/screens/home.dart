import 'package:digident/config/app_config.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Widgets ----
  final Drawer _homeDrawer = Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'App configuration',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
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
                onChanged: (value) {
                  // Update Host IP in app_config.dart
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Host Port',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Buffer Size',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller:
                    TextEditingController(text: "${AppConfig.MAX_BUFFER_SIZE}"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Save the updated values to app_config.dart
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DigiDent MK2"),
      ),
      drawer: _homeDrawer,
    );
  }
}

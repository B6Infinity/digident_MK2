# DigiDent

DigiDent is a Flutter-based mobile application designed to enhance dental diagnostics and patient care through innovative features and seamless user experience.

## Project Structure

The project is organized as follows:

```
lib/
├── main.dart
├── config/
│   └── app_config.dart
├── models/
│   └── frame_model.dart
├── screens/
│   ├── camera_view_screen.dart
│   └── home.dart
├── services/
│   ├── input_field_controllers.dart
│   └── udp_service.dart
└── widgets/
    └── camera_view_widget.dart
```

### Key Directories

- **`config/`**: Contains application configuration files.
- **`models/`**: Includes data models used across the app.
- **`screens/`**: Houses the UI screens of the application.
- **`services/`**: Contains service classes for handling business logic and external communication.
- **`widgets/`**: Reusable UI components.

## Features

- **Camera Integration**: Capture and analyze dental images using the `camera_view_screen.dart`.
- **Real-Time Data Processing**: Utilize `udp_service.dart` for efficient data communication.
- **Custom Widgets**: Modular and reusable UI components for a consistent design.

## Getting Started

To get started with DigiDent, follow these steps:

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd digident
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)

For further assistance, refer to the [online documentation](https://docs.flutter.dev/), which provides tutorials, samples, and API references.


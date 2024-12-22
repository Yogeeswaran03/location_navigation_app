# Location and Navigation App

This is a Flutter application that provides real-time location tracking and navigation functionality. Users can view their current location, set a destination, and plot a route using Google Maps. The app also supports navigation via external maps like Google Maps.

---

## Features

- Real-time location tracking using GPS.
- Destination search and route plotting.
- Integration with Google Maps for navigation.
- Polylines to display routes on the map.
- Interactive map interface with zoom and pan functionality.

---

## Prerequisites

Before setting up the project, ensure the following tools and dependencies are installed:

1. **Flutter SDK**: Install it from [Flutter's official website](https://flutter.dev/docs/get-started/install).
2. **Android Studio or VS Code**: IDE for running and debugging Flutter projects.
3. **Google Maps API Key**: Obtain an API key with required permissions (details below).

---

## Setup Instructions

### Step 1: Clone the Repository
Clone this repository to your local system:
```bash
git clone https://github.com/your-repo/location-navigation-app.git
cd location-navigation-app
```

### Step 2: Install Dependencies
Run the following command to install the required dependencies:
```bash
flutter pub get
```

### Step 3: Add a Google Maps API Key
#### How to Obtain a Google Maps API Key:
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one.
3. Navigate to **APIs & Services > Credentials**.
4. Click on **Create Credentials** and select **API Key**.
5. Enable the following APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Directions API**
6. Copy the generated API key.

#### Add the API Key to Your Project:
1. Open the Flutter project in your preferred IDE.
2. Locate the `_getRouteCoordinates` function in your code.
3. Replace `'Your_Google_Maps_API_Key'` with your API key:

4. For Android, update the `android/app/src/main/AndroidManifest.xml` file:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="Your_Google_Maps_API_Key" />
   ```
5. For iOS, update the `ios/Runner/AppDelegate.swift` file:
   ```swift
   GMSServices.provideAPIKey("Your_Google_Maps_API_Key")
   ```

### Step 4: Run the Application
Run the following command to start the app:
```bash
flutter run
```

---

## Usage

1. Open the app to view your current location on the map.
2. Enter a destination in the search bar and press the search icon.
3. View the plotted route from your location to the destination.
4. Use the navigation button to launch Google Maps for turn-by-turn navigation.

---

## Troubleshooting

- **Permission Denied**: Ensure location permissions are granted on your device.
- **API Key Issues**: Verify that the API key is active and linked to the correct project in the Google Cloud Console.
- **Dependencies Not Found**: Run `flutter pub get` to resolve missing dependencies.

---

## Dependencies

This project uses the following Flutter packages:
- `google_maps_flutter`
- `geolocator`
- `permission_handler`
- `flutter_polyline_points`
- `url_launcher`
- `geocoding`

Refer to the `pubspec.yaml` file for version details.

---

## Contribution

Contributions are welcome! Please open an issue or submit a pull request for any feature suggestions or bug fixes.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Contact

For further inquiries or support, reach out to:
- **Developer**: Yogeeswaran M
- **Email**: yogees97@gmail.com
```


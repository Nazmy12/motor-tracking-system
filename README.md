# GoCheck - Scooter Rental App

A Flutter application for managing scooter rentals, including borrowing, returning, and status tracking. Built with Firebase for authentication and data persistence.

## Features

- **User Authentication**: Sign up and login with Firebase Auth
- **Scooter Management**: Browse available scooters by location (Malang, Batu, Jember)
- **Borrowing System**: Reserve scooters with user details
- **Return Process**: Scan license plates with OCR for returns
- **Status Tracking**: View borrowing history and scooter statuses
- **Profile Management**: Update user information

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Firestore, Auth)
- **OCR**: Tesseract for license plate recognition
- **State Management**: Provider
- **Camera**: Camera plugin for image capture

## Setup Instructions

1. **Prerequisites**:
   - Flutter SDK installed
   - Firebase project created
   - Android Studio or VS Code

2. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd my_test_app
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Firebase Configuration**:
   - Add `google-services.json` to `android/app/`
   - Enable Authentication and Firestore in Firebase Console
   - Update Firebase project ID in code if needed

5. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   ├── user.dart
│   ├── scooter.dart
│   └── booking.dart
├── providers/             # State management
│   └── auth_provider.dart
├── services/              # Firebase services
│   └── firestore_service.dart
└── pages/                 # UI screens
    ├── login.dart
    ├── signup.dart
    ├── home.dart
    ├── borrow.dart
    ├── form_borrow.dart
    ├── scan.dart
    ├── form.dart
    ├── status.dart
    └── profile.dart
```

## Key Dependencies

- `firebase_core`, `firebase_auth`, `cloud_firestore`: Firebase integration
- `camera`: Camera access
- `flutter_tesseract_ocr`: OCR for license plates
- `provider`: State management
- `image_picker`: Image selection

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License

This project is licensed under the MIT License.

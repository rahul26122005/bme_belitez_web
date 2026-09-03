# B'Elitez 2K26 – Flutter + Firebase

A responsive Flutter Web symposium website for Mahendra College of Engineering, Biomedical Engineering.

## Stack
- Flutter Web
- Firebase Hosting
- Cloud Firestore (only database)
- Firebase Authentication for admin login
- No Firebase Storage
- Payment screenshots are compressed and stored as Base64 in Firestore. Keep them small because Firestore documents have a size limit.

## 1. Create the project
```bash
flutter create .
flutter pub get
```
Copy the `lib/`, `web/`, `firebase.json`, `.firebaserc`, `firestore.rules`, and `pubspec.yaml` from this package into the project.

## 2. Configure Firebase
Install the Firebase CLI and FlutterFire CLI, then:
```bash
firebase login
firebase init
dart pub global activate flutterfire_cli
flutterfire configure
```
Choose your Firebase project and enable Web. This generates `lib/firebase_options.dart`.

## 3. Enable Firebase services
In Firebase Console:
- Authentication → Sign-in method → enable Email/Password.
- Firestore Database → create a database.
- Hosting → configure Firebase Hosting.

Create an admin Auth user. Then create:
`admins/{ADMIN_UID}`
with:
```json
{
  "email": "admin@example.com",
  "role": "admin",
  "active": true
}
```

## 4. Firestore rules
Deploy:
```bash
firebase deploy --only firestore:rules
```

## 5. Run
```bash
flutter run -d chrome
```

## 6. Build and host
```bash
flutter build web --release
firebase deploy --only hosting
```

The generated website is a single Flutter Web app with routes:
- `/`
- `/events`
- `/event/paper-presentation`
- `/event/poster-presentation`
- `/event/spot-to-solve`
- `/event/medico-mind`
- `/event/workshop`
- `/event/cinephoria-short-film`
- `/event/minutes-to-win`
- `/event/squad-wars`
- `/event/team-building-activity`
- `/register`
- `/admin/login`
- `/admin`

## Important
This implementation intentionally does not use Firebase Storage. A payment screenshot is resized/compressed before being saved to Firestore. The app rejects an encoded image that is still too large.

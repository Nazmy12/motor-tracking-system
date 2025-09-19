import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:gocheck/firebase_options.dart';
import 'package:gocheck/providers/auth_provider.dart';
import 'package:gocheck/services/firestore_service.dart';
import 'package:gocheck/pages/login.dart';
import 'package:gocheck/pages/signup.dart';
import 'package:gocheck/pages/home.dart';
import 'package:gocheck/pages/borrow.dart';
import 'package:gocheck/pages/form_borrow.dart';
import 'package:gocheck/pages/status.dart';
import 'package:gocheck/pages/profile.dart';
import 'package:gocheck/pages/scan.dart';
import 'package:gocheck/pages/form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Populate sample data if needed
  await FirestoreService().populateSampleData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "GoCheck",
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Roboto',
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/borrow': (context) => const BorrowPage(),
          '/form_borrow': (context) => const FormBorrowPage(),
          '/status': (context) => const StatusPage(),
          '/profile': (context) => const ProfilePage(),
          '/scan': (context) => ScanPage(),
          '/form': (context) => FormPage(),
        },
      ),
    );
  }
}

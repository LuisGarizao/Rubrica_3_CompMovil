import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // Asegúrate de importar tu HomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB-xb0vr-VSSyqj2_W9IZKs3MNg9SQG8RY",
        authDomain: "huertix-c0be1.firebaseapp.com",
        projectId: "huertix-c0be1",
        storageBucket: "huertix-c0be1.appspot.com",
        messagingSenderId: "422806119632",
        appId: "1:422806119632:web:3174c0ca3dc73eedc8aad5",
      ),
    );
    print('✅ Firebase inicializado para Web');
  } else {
    await Firebase.initializeApp();
    print('✅ Firebase inicializado para móvil');
  }

  runApp(const UrbanGardenApp());
}

class UrbanGardenApp extends StatelessWidget {
  const UrbanGardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huertos Urbanos',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      initialRoute: '/login', // Ruta inicial
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

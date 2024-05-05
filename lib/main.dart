import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      if (Platform.isAndroid) {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: "AIzaSyAFBXEbsxh4viUvjV07C7DAt9q8L80IjZ8",
            appId: "1:688022961489:android:3a06aa09bdaf2f3f94a770",
            messagingSenderId: "688022961489",
            projectId: "test-cli-d58f3",
            storageBucket: 'test-cli-d58f3.appspot.com',
          ),
        );
      } else if (Platform.isIOS) {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            appId: "YOUR_IOS_APP_ID",
            messagingSenderId: "YOUR_IOS_MESSAGING_SENDER_ID",
            projectId: "YOUR_IOS_PROJECT_ID",
            apiKey: 'AIzaSyAFBXEbsxh4viUvjV07C7DAt9q8L80IjZ8',
          ),
        );
      }
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  // Initialize authMethods
  AuthMethods authMethods = AuthMethods();

  runApp(MyApp(authMethods: authMethods));
}

class MyApp extends StatelessWidget {
  final AuthMethods authMethods;

  const MyApp({required this.authMethods});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: HP(authMethods: authMethods),
    );
  }
}





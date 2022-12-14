import 'package:flutter/material.dart';
import 'package:flashchat_returns/screens/welcome_screen.dart';
import 'package:flashchat_returns/screens/login_screen.dart';
import 'package:flashchat_returns/screens/registration_screen.dart';
import 'package:flashchat_returns/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  //
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
    routes: {
      WelcomeScreen.id:(context) => WelcomeScreen(),
      LoginScreen.id : (context) => LoginScreen(),
      RegistrationScreen.id : (context) => RegistrationScreen(),
      ChatScreen.id : (context) => ChatScreen(),
    }
      ,);
  }
}

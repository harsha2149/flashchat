import 'package:flashchat_returns/screens/login_screen.dart';
import 'package:flashchat_returns/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat_returns/components.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcomescreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller.forward();
    animation =
        ColorTween(begin: Colors.blue.shade900, end: Colors.blue).animate(controller);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 15.0,
                          color: Colors.yellowAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        FlickerAnimatedText('FLASHCHAT'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          elevation: 5.0,
          color:Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, LoginScreen.id );
            },
            minWidth: 200.0,
            height: 42.0,
            child:  Text('Log In'),
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          elevation: 5.0,
          color:Colors.blueAccent,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: ()
            {
              Navigator.pushNamed(context, RegistrationScreen.id );
            },
            minWidth: 200.0,
            height: 42.0,
            child:  Text('Register'),
          ),
        ),
      ),

          ],
        ),
      ),
    );
  }
}


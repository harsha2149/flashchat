import 'package:flashchat_returns/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flashchat_returns/components.dart';
import 'package:flashchat_returns/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginscreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                    email = value;
                },
                decoration: kInputDecoration.copyWith(
                  hintText: 'enter your email id',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;

                },
                decoration:kInputDecoration.copyWith(
                  hintText: 'enter your password'
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color:Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () async{
                      setState(() {
                        showspinner = true;
                      });
                      try{
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);

                        if(user!= null)
                        {
                          Navigator.pushNamed(context, ChatScreen.id );
                        }
                        setState(() {
                          showspinner= false;
                        });

                      }catch(e)
                      {
                        print(e);
                      }


                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child:  Text('Log In'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

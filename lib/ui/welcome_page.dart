import 'package:chatty_app/common/config.dart';
import 'package:chatty_app/common/size_config.dart';
import 'package:chatty_app/services/connectivity_check.dart';
import 'package:chatty_app/ui/chat_page.dart';
import 'package:chatty_app/widgets/notification_widget.dart';
import 'package:chatty_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomePage extends StatefulWidget {
  static String routeName = 'welcome';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: ConnectivityCheck(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (SizeConfig.safeBlockHorizontal * 6.67).roundToDouble(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Lottie.asset(
                        'assets/lottie/chat-animation.zip',
                        height: (SizeConfig.safeBlockVertical * 19.5)
                            .roundToDouble(),
                      ),
                      TypewriterAnimatedTextKit(
                        speed: Duration(milliseconds: 250),
                        text: ["Chatty \nApp"],
                        textStyle: TextStyle(
                            fontSize: (SizeConfig.safeBlockHorizontal * 9.72)
                                .roundToDouble(),
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height:
                        (SizeConfig.safeBlockVertical * 7.8).roundToDouble()),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  decoration: textFieldDecoration(
                    hintText: 'Enter your gmail',
                    color: blueColor,
                  ),
                ),
                SizedBox(
                    height:
                        (SizeConfig.safeBlockVertical * 1.3).roundToDouble()),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: textFieldDecoration(
                    hintText: 'Enter your password',
                    color: blueColor,
                  ),
                ),
                SizedBox(
                    height:
                        (SizeConfig.safeBlockVertical * 3.9).roundToDouble()),
                RoundedButton(
                    color: blueColor,
                    text: 'Enter Chat Room',
                    onPressed: () async {
                      var user;
                      if (!_emailController.text.contains('@gmail.com')) {
                        showNotification('Your gmail is invalid.');
                      } else if (_passwordController.text.length < 6) {
                        showNotification(
                            'Your password must be at least 6 characters.');
                      } else {
                        try {
                          user = await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                        } catch (e) {
                          if (e.message !=
                              'The password is invalid or the user does not have a password.') {
                            user = await _auth.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                          } else {
                            showNotification(e.message);
                          }
                        } finally {
                          if (user != null) {
                            _emailController.clear();
                            _passwordController.clear();
                            Navigator.of(context)
                                .pushReplacementNamed(ChatPage.routeName);
                          }
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

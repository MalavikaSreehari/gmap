
import 'package:farespy/login.dart';
import 'package:farespy/signup.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  static const  String idScreen = "initial";
  const InitialPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.jpeg',
              width: 300,
              height: 350,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 300,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: const Color(0xff93C561),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: const Color(0xff258EAB),
              ),
              child: Center(
                child: TextButton(onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );},
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

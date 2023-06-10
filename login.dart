import 'package:farespy/home_page.dart';
import 'package:farespy/main.dart';
import 'package:farespy/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';



class Login extends StatelessWidget {
  static const String idScreen = "login";
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  Login({Key? key}) : super(key: key);
  
  get usersRef => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Image.asset(
            'assets/images/logo.jpeg',
            width: 80,
            height: 80,
                ),
                Padding(
            padding: const EdgeInsets.only(left: 50, top: 60),
            child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Color(0xff258EAB),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        width: 250,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: TextFormField(
                              controller: emailTextEditingController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                              return "Email is required";
                                            } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                                              return "Please enter a valid email address";
                                            }
                                            return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: InputBorder.none,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        width: 250,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: TextFormField(
                              controller: passwordTextEditingController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                              return "Password is required";
                                            } else if (value.length < 8) {
                                              return "Password must be at least 8 characters";
                                              }
                                              else if (value != passwordTextEditingController.text){
                          return "Incorrect Password";
                                          
                                              }
                                            
                                            return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: InputBorder.none,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                      ),
                      Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: TextButton(
                          onPressed: () async {
                
                            // if (!emailTextEditingController.text.contains("@")) {
                            //   displayToastMessage(
                            //       "Email address is not valid.", context);
                            // } else if (passwordTextEditingController.text.isEmpty) {
                            //   displayToastMessage("Password is required.", context);
                            // } else {
                            // if (_formKey.currentState!.validate())  
                            //   loginAndAuthenticateUser(context);
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => HomePage()),
                            //   );
                            // // }
                            if (_formKey.currentState!.validate()) {
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text,
              );
              
              Navigator.pushNamed(context, HomePage.idScreen);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found' || e.code == 'wrong-password') {
                ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid email or password.'),
              backgroundColor: Colors.red,
            ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to sign in.'),
              backgroundColor: Colors.red,
            ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
            content: Text('Failed to sign in.'),
            backgroundColor: Colors.red,
                ),
              );
            }
                  }
                  
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xff258EAB),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Text(
                        'Do not have an account?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, SignUp.idScreen, (route) => false);
                        },
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                            color: Color(0xff93C561),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                ),
              ]),
          ),
        ));
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    final User? user = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (user != null) {
      // user registration successful, do something
      usersRef.child(user.uid).once().then((DatabaseEvent event) {
        DataSnapshot snap = event.snapshot;
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.idScreen, (route) => false);
          displayToastMessage("You are logged in.", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "No records exist for this account. Try logging in from a valid account or sign up.",
              context);
        }
      });
    } else {
      displayToastMessage("Error signing in", context);
    }
  }
}
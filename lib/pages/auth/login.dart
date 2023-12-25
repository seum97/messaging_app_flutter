import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:new_messaging_app/notification/localNotification.dart';
// import 'package:new_messaging_app/notification/notificationDestinationPage.dart';
// import 'package:messaging_app/service/notificationService.dart';

import '../../service/databaseService.dart';

class LogIn extends StatefulWidget {

  final togglePage;
  LogIn({required this.togglePage});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();
  bool loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is Login page'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKeyLogin,
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
              ),
              // for email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please Enter Email !';
                  } else
                    return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(
                height: 30.0,
              ),

              // for password
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
                obscuringCharacter: '#',
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please Enter Password !';
                  } else
                    return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(
                height: 30.0,
              ),

              // Login Button
              ElevatedButton(
                  onPressed: () async {
                    if (_formKeyLogin.currentState!.validate()) {
                      setState(() {
                        loadingVisible = true;
                      });
                      dynamic result = await DatabaseService().loginUser(emailController.text, passwordController.text);

                      // if (result == null){
                      if (result is! UserCredential){

                        setState(() {
                          loadingVisible = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                behavior: SnackBarBehavior.floating,
                                // content: Text("Login failed, try again !")
                                content: Text("$result")
                            )
                        );
                      }
                    }
                  },
                  child: Text("Login")),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Account?"),
                  SizedBox(width: 10,),
                  GestureDetector(
                      onTap: () {
                        widget.togglePage();
                      },
                      child: Text("Register",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue
                        ),)
                  ),
                ],
              ),

              SizedBox(height: 20,),
              Visibility(
                visible: loadingVisible,
                child: SpinKitRing(
                  color: Colors.blue,
                ),
              ),

              // Visibility(
              //   visible: loadingVisible,
              //   child: CircularProgressIndicator(
              //     // value: controller.value,
              //     semanticsLabel: 'Circular progress indicator',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

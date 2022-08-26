import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_exam/pages/sign_in_page.dart';
import 'package:my_exam/services/auth_service.dart';
import 'package:my_exam/services/db_service.dart';
import 'package:my_exam/services/util_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../services/remote_service.dart';

class SignUpPage extends StatefulWidget {
  static const id = "/sign_up_page";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _signUp() async {
    String firstName = firstnameController.text.trim();
    String lastname = lastnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = "$firstName $lastname";

    if(firstName.isEmpty || lastname.isEmpty || email.isEmpty || password.isEmpty) {
      Utils.fireSnackBar("Please fill all gaps", context);
      return;
    }

    isLoading = true;
    setState(() {});

    AuthService.signUpUser(context, name, email, password).then((user) => _checkNewUser(user));
  }

  void _checkNewUser(User? user) async {
    if(user != null) {
      await DBService.saveUserId(user.uid);
      if(mounted) Navigator.pushReplacementNamed(context, SignInPage.id);
    } else {
      Utils.fireSnackBar("Please check your entered data, Please try again!", context);
    }

    isLoading = false;
    setState(() {});
  }

  void _catchError() {
    Utils.fireSnackBar("Something error in Service, Please try again later", context);
    isLoading = false;
    setState(() {});
  }

  void _goSignIn() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RemoteService.availableBackgroundColors[RemoteService.backgroundColor],
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 80,),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text("Create Your Account",style: TextStyle(color: Colors.black,fontSize: 32,fontWeight: FontWeight.w500),),
                  ),
                  const SizedBox(height: 20,),
                  // #firstname
                  TextField(
                    controller: firstnameController,
                    decoration: const InputDecoration(
                      hintText: "Firstname",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20,),

                  // #lastname
                  TextField(
                    controller: lastnameController,
                    decoration: const InputDecoration(
                      hintText: "Lastname",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20,),

                  // #email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20,),

                  // #password
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20,),

                  // #sign_up
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)
                    ),
                    child: const Text("Sign Up", style: TextStyle(fontSize: 16),),
                  ),
                  const SizedBox(height: 20,),

                  // #sign_in
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          const TextSpan(
                            text: "Already have an account?  ",
                          ),
                          TextSpan(
                            style: const TextStyle(color: Colors.blue),
                            text: "Sign In",
                            recognizer: TapGestureRecognizer()..onTap = _goSignIn,
                          ),
                        ]
                    ),
                  )
                ],
              ),
            ),
          ),

          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

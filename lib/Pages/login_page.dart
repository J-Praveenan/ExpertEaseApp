import 'package:expert_ease/components/my_button.dart';
import 'package:expert_ease/components/my_text_field.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in user
  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    //logo
                    Icon(
                      Icons.thumbs_up_down_sharp,
                      size: 50,
                      color: Color.fromARGB(255, 5, 115, 134),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // ExpertEase(Ee)
                    const Text(
                      "ExpertEase",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 115, 134),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //welcome back message
                    const Text(
                      "Welcome to Our ExpertEase App!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 5, 115, 134),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // Login
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 5, 115, 134),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    //email textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    //sign in button
                    MyButton(onTap: signIn, text: "Sign In"),

                    const SizedBox(
                      height: 10,
                    ),
                    //not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Do not have an Account?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 7, 141, 165),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 141, 165),
                            ),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
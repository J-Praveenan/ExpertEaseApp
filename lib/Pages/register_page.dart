import 'package:expert_ease/components/my_button.dart';
import 'package:expert_ease/components/my_text_field.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //sign up user
  void signUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password do not match!"),
        ),
      );
      return;
    }

    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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

              //Create account message
              const Text(
                "Let's create an account for you!",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 5, 115, 134),
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

              //confirm password textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),

              //sign un button
              MyButton(onTap: signUp, text: "Sign Up"),

              const SizedBox(
                height: 10,
              ),

              //Already have an Account? Login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an Account?',
                    style: TextStyle(
                      color: Color.fromARGB(255, 5, 115, 134),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 5, 115, 134),
                      ),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      )),
    );
  }
}

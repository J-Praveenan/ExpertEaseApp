import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/components/my_button.dart';
import 'package:expert_ease/components/my_text_field.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final roleController = TextEditingController();
  String selectedRole = "0";

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

    // Check if a role is selected
   if (selectedRole == "0") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select your role!"),
        ),
      );
      return;
    }

    print("Selected Role: $selectedRole"); // Add this print statement

    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
String roleName = await getRoleName(selectedRole);
        try {
      await authService.signUpWithEmailAndPassword(
        roleName,
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

  }
// Function to retrieve the role name from Firestore using the role id
Future<String> getRoleName(String roleId) async {
  DocumentSnapshot roleSnapshot = await FirebaseFirestore.instance
      .collection('roles')
      .doc(roleId)
      .get();

  if (roleSnapshot.exists) {
    return roleSnapshot.get('name');
  } else {
    throw Exception("Role not found in Firestore");
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

              // MyTextField(
              //   controller: roleController,
              //   hintText: 'role',
              //   obscureText: false,
              // ),

              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('roles')
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<DropdownMenuItem> rolesItems = [];
                    if (!snapshot.hasData) {
                      const CircularProgressIndicator();
                    } else {
                      final roles = snapshot.data?.docs.reversed.toList();
                      rolesItems.add(
                        DropdownMenuItem(
                          value: "0",
                          child: Text('Select your Role'),
                        ),
                      );

                      for (var role in roles!) {
                        rolesItems.add(
                          DropdownMenuItem(
                            value: role.id,
                            child: Text(
                              role['name'],
                            ),
                          ),
                        );
                      }
                    }
                    return DropdownButton(
                      items: rolesItems,
                      onChanged: (rolesValue) {
                        
                        setState(() {
                          selectedRole = rolesValue;
                         
                        });

                        print(rolesValue);
                        
                      },
                      value: selectedRole,
                      isExpanded: false,
                    );
                  }),

              const SizedBox(
                height: 10,
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/components/my_button.dart';
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
  late Color myColor;
  late Size mediaSize;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final roleController = TextEditingController();
  String selectedRole = "0";
  bool rememberUser = false;

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
    DocumentSnapshot roleSnapshot =
        await FirebaseFirestore.instance.collection('roles').doc(roleId).get();

    if (roleSnapshot.exists) {
      return roleSnapshot.get('name');
    } else {
      throw Exception("Role not found in Firestore");
    }
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF7165D6),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 70, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 0),
          Image.asset(
            "images/eea.png",
            height: 140,
            width: 340,
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SignUp",
          style: TextStyle(
              color: Color(0xFF7165D6),
              fontSize: 32,
              fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Please register with your information"),
        const SizedBox(height: 40),
        _buildGreyText("Email"),
        _buildInputFieldEmail(emailController),
        const SizedBox(height: 20),
        _buildGreyText("Password"),
        _buildInputFieldPassword(passwordController),
        const SizedBox(height: 20),
        _buildGreyText("Confirm Password"),
        _buildInputFieldPassword(confirmPasswordController),
        const SizedBox(height: 20),
        // _buildGreyText("Select your role"),
        // _buildInputFieldRole(roleController),

        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('roles').snapshots(),
            builder: (context, snapshot) {
              List<DropdownMenuItem<String>> rolesItems = [];
              if (!snapshot.hasData) {
                const CircularProgressIndicator();
              } else {
                final roles = snapshot.data?.docs.reversed.toList();
                rolesItems.add(
                  DropdownMenuItem<String>(
                    value: "0",
                    child: Text(
                      'Select your Role',
                      style: TextStyle(
                        color: Color.fromARGB(255, 107, 106, 106), // Replace with your desired color
                        // Optional: italicize the text
                      ),
                    ),
                  ),
                );

                for (var role in roles!) {
                  rolesItems.add(
                    DropdownMenuItem<String>(
                      value: role.id,
                      child: Text(
                        role['name'],
                      ),
                    ),
                  );
                }
              }
              return Container(
                child: DropdownButton<String>(
                  items: rolesItems,
                  onChanged: (rolesValue) {
                    setState(() {
                      selectedRole = rolesValue!;
                    });
                    print(rolesValue);
                  },
                  value: selectedRole,
                  isExpanded: false,
                  underline: Container(), // Remove the default underline
                  icon: Padding(
                    padding: EdgeInsets.only(
                        left: 188), // Adjust the padding as needed
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Color(0xFF7165D6),
                    ),
                  ),
                  style: TextStyle(
                   color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              );
            }),
        const SizedBox(height: 20),
        MyButton(onTap: signUp, text: "Register"),
        const SizedBox(height: 20),
        _buildLoginText(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Color.fromARGB(255, 107, 106, 106), fontSize: 15),
    );
  }

  Widget _buildInputFieldEmail(TextEditingController controller,) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.email,
          color: Color(0xFF7165D6),
        ),
      ),
      obscureText: false,
    );
  }

  Widget _buildInputFieldPassword(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.lock,
          color: Color(0xFF7165D6),
        ),
      ),
      obscureText: true,
    );
  }

  // Widget _buildInputFieldRole() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildGreyText("Select your role"),
  //       Container(
  //         padding: EdgeInsets.symmetric(horizontal: 10),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(color: Color(0xFF7165D6)),
  //         ),
  //         child: StreamBuilder<QuerySnapshot>(
  //           stream: FirebaseFirestore.instance.collection('roles').snapshots(),
  //           builder: (context, snapshot) {
  //             List<DropdownMenuItem<String>> rolesItems = [];
  //             if (!snapshot.hasData) {
  //               return CircularProgressIndicator();
  //             } else {
  //               final roles = snapshot.data?.docs.reversed.toList();
  //               rolesItems.add(
  //                 DropdownMenuItem(
  //                   value: "0",
  //                   child: Text('Select your Role'),
  //                 ),
  //               );

  //               for (var role in roles!) {
  //                 rolesItems.add(
  //                   DropdownMenuItem(
  //                     value: role.id,
  //                     child: Text(
  //                       role['name'],
  //                     ),
  //                   ),
  //                 );
  //               }
  //             }
  //             return DropdownButton<String>(
  //               items: rolesItems,
  //               onChanged: (rolesValue) {
  //                 setState(() {
  //                   selectedRole = rolesValue!;
  //                 });
  //                 print(rolesValue);
  //               },
  //               value: selectedRole,
  //               isExpanded: false,
  //               underline: Container(), // Remove the default underline
  //               icon: Icon(
  //                 Icons.arrow_drop_down_circle,
  //                 color: Color(0xFF7165D6),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLoginText() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an Account?',
                style: TextStyle(
                  color: Color(0xFF7165D6),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7165D6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

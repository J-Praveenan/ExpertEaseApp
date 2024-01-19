import 'package:expert_ease/components/my_button.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberUser = false;

  //sign in user
  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        context,
        (context, widget) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => widget),
          );
        },
      );
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
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF7165D6),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(children: [
          Positioned(top: 80, child: _buildTop()),
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
        const Text(
          "Login",
          style: TextStyle(
              color: Color(0xFF7165D6), fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGreyText("Please login with your information"),
        const SizedBox(height: 60),
        _buildGreyText("Email"),
        _buildInputEmail(emailController),
        const SizedBox(height: 40),
        _buildGreyText("Password"),
        _buildInputPassword(passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        MyButton(onTap: signIn, text: "Sign In"),
        const SizedBox(height: 10),
        _buildOtherLogin(),
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


  Widget _buildForRemText(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Color.fromARGB(255, 107, 106, 106), fontSize: 13),
    );
  }

  Widget _buildInputEmail(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.email,
          color: Color(0xFF7165D6),
        ),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildInputPassword(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        suffixIcon: Icon(
          Icons.lock,
          color: Color(0xFF7165D6),
        ),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildForRemText("Remember me"),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 0),
          child: TextButton(
              onPressed: () {}, child: _buildForRemText("forgot password")),
        )
      ],
    );
  }

  

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Do not have an Account?',
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
              'Register now',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF7165D6),
              ),
            ),
          ),
            ],
          ),
          
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tab(icon: Image.asset("images/facebook.png")),
              Tab(icon: Image.asset("images/twitter.png")),
              Tab(icon: Image.asset("images/github.png")),
            ],
          )
        ],
      ),
    );
  }
}
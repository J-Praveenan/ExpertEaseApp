import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/Pages/learner_home.dart';
import 'package:expert_ease/components/my_button.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:expert_ease/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateLearnerProfile extends StatefulWidget {
  final void Function()? onTap;
  const UpdateLearnerProfile({super.key, required this.onTap});

  @override
  State<UpdateLearnerProfile> createState() => _UpdateLearnerProfileState();
}

class _UpdateLearnerProfileState extends State<UpdateLearnerProfile> {
  late Color myColor;
  late Size mediaSize;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileController = TextEditingController();

  Uint8List? _image;
  bool rememberUser = false;

  // select Image
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  //sign up user
  void createNewLearnerProfile() async {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    // String roleName = await getRoleName(selectedRole);
    try {
      await authService.createNewLearnerProfile(
        nameController.text,
        addressController.text,
        mobileController.text,
        _image, // Pass the image to the method
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    super.dispose();
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
        body: ListView(children: [
          const SizedBox(height: 30),
          Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LearnerHomeScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: 25,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          Positioned(top: 20, child: _buildTop()),
          Positioned(top: 100, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 30),
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://cdn.vectorstock.com/i/preview-1x/52/68/purple-user-icon-in-the-circle-thin-line-vector-23745268.webp'),
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(Icons.add_a_photo),
                  color: Color.fromARGB(255, 249, 250,
                      250), // Customize the add photo button color
                ),
              ),
            ],
          ),
        ]),
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
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
        _buildGreyText("Name"),
        _buildInputFieldEmail(nameController),
        const SizedBox(height: 20),
        _buildGreyText("Address"),
        _buildInputFieldEmail(addressController),
        const SizedBox(height: 20),
        _buildGreyText("Mobile Number"),
        _buildInputFieldEmail(mobileController),
       
        const SizedBox(height: 20),
        MyButton(onTap: createNewLearnerProfile, text: "Save"),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
            color: Color.fromARGB(255, 107, 106, 106), fontSize: 15),
      ),
    );
  }

  Widget _buildInputFieldEmail(
    TextEditingController controller,
  ) {
    return TextField(
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13),
      controller: controller,
      decoration: const InputDecoration(),
      obscureText: false,
    );
  }
}

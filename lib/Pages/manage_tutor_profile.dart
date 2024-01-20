import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expert_ease/components/my_button.dart';
import 'package:expert_ease/services/auth/auth_service.dart';
import 'package:expert_ease/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateUserProfile extends StatefulWidget {
  final void Function()? onTap;
  const UpdateUserProfile({super.key, required this.onTap});

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  late Color myColor;
  late Size mediaSize;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final subjectController = TextEditingController();
  final mediumController = TextEditingController();
  final bioController = TextEditingController();
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
  void createNewProfile() async {


    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    // String roleName = await getRoleName(selectedRole);
    try {
      await authService.createNewUserProfile(
       
        nameController.text,
        addressController.text,
        subjectController.text,
        mediumController.text,
        bioController.text,
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
    subjectController.dispose();
    mediumController.dispose();
    bioController.dispose();
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
          Positioned(top: 30, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Container(
          
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
                      color:
                          Color.fromARGB(255, 249, 250, 250), // Customize the add photo button color
                    ),
                  ),
                ],
              ),
            ]
          ),
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
        
        _buildGreyText("Name"),
        _buildInputFieldEmail(nameController),
        const SizedBox(height: 20),
        _buildGreyText("Address"),
         _buildInputFieldEmail(addressController),
        const SizedBox(height: 20),
        _buildGreyText("Subject"),
         _buildInputFieldEmail(subjectController),
        const SizedBox(height: 20),
         _buildGreyText("medium"),
         _buildInputFieldEmail(mediumController),
        const SizedBox(height: 20),
         _buildGreyText("Bio"),
         _buildInputFieldEmail(bioController),
        const SizedBox(height: 20),

        MyButton(onTap: createNewProfile, text: "Save"),
      
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

  Widget _buildInputFieldEmail(TextEditingController controller,) {
    return TextField(
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13),
      controller: controller,
      decoration: const InputDecoration(
        
        
      ),
      obscureText: false,
    );
  }

 



}
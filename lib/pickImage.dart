import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pickimage extends StatefulWidget {
  const Pickimage({super.key});

  @override
  State<Pickimage> createState() => _PickimageState();
}

class _PickimageState extends State<Pickimage> {
  String? imageUrl;

  Future<void> uploadProfileImage() async {
    try {
      // Pick an image from the user's gallery
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Get the current user UID
        String uid = FirebaseAuth.instance.currentUser!.uid;

        // Define the path for Firebase Storage
        String storagePath = 'user_images/$uid/profile_image.png';

        // Upload the image to Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child(storagePath);
        UploadTask uploadTask = storageRef.putFile(imageFile);

        // Wait until the file is uploaded
        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL of the uploaded image
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Store the download URL in Firestore under the user's document
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profileImageUrl': downloadUrl,
        });
        setState(() {
          imageUrl = downloadUrl;
        });
        print('Image uploaded and URL saved successfully.');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Profile Picture",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF040d38),
      ),
      backgroundColor: const Color(0xFF040d38),
      body: Center(
        child: Container(
          height: double.infinity,
          color: mainColor(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 250,
                ),
                GestureDetector(
                  onTap: () {
                    uploadProfileImage();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      imageUrl == null
                          ? CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(
                                  "https://static.vecteezy.com/system/resources/previews/036/280/650/original/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg"),
                            )
                          : CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(imageUrl!),
                            ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 60,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container customButton(String text, double margin, VoidCallback code,
      {double width = 330, double height = 50}) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: const Color.fromARGB(255, 160, 63, 12), width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(158, 37, 53, 82),
              blurRadius: 50,
              spreadRadius: 10,
            )
          ],
          gradient: LinearGradient(colors: [
            const Color.fromARGB(255, 199, 80, 16),
            const Color.fromARGB(255, 245, 114, 44)
          ])
          //color: const Color.fromARGB(255, 255, 127, 7),
          ),
      //padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          //padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () {
          code();
        },
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color.fromARGB(255, 255, 255, 255))),
      ),
    );
  }

  Color mainColor() => const Color(0xFF040d38);

  Color whiteColor() => const Color(0xFFffffff);

  Color darkOrangeColor() => const Color(0xFFe75d14);

  Color darkBlueColor() => const Color(0xFF3e4677);

  Color orangeColor() => const Color(0xFFfeab4f);

  Color purpleColor() => const Color(0xFF9b6c9b);

  Color brownColor() => const Color(0xFF3f1919);
}

class CustomTextFormField extends StatelessWidget {
  final String? Label_Text;
  final String? myHintText;
  final String? Validator_Text;
  final IconData? Icon_Data;
  final bool? isPassword;
  final bool? isConfirmPassword;
  final bool? isEmail;
  final bool? isAge;
  final TextEditingController? passwordController;
  final TextInputType? keyboardType;
  const CustomTextFormField({
    super.key,
    this.Label_Text,
    this.myHintText,
    this.Validator_Text,
    this.Icon_Data,
    this.isPassword,
    this.isEmail,
    this.isAge,
    this.isConfirmPassword,
    this.passwordController,
    required this.ControllerValue,
    this.keyboardType,
  });

  final TextEditingController ControllerValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
      controller: ControllerValue,
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty) {
          return Validator_Text;
        } else if (isPassword!) {
          if (value.length < 8) {
            return "Password has to be 8 characters or more";
          } else if (value.toLowerCase() == value) {
            return "Password has to include at least 1 Uppercase character";
          } else if (!value.contains('0') &&
              !value.contains('1') &&
              !value.contains('2') &&
              !value.contains('3') &&
              !value.contains('4') &&
              !value.contains('5') &&
              !value.contains('6') &&
              !value.contains('7') &&
              !value.contains('8') &&
              !value.contains('9')) {
            return "Password has to include at least one number";
          }
        } else if (isConfirmPassword!) {
          if (value != passwordController?.text) {
            return "Confirm Password must be equal to Password";
          }
        } else if (isEmail!) {
          if (!value.endsWith('@gmail.com')) {
            return "Email Must Be in the format (address@gmail.com) \n ex. myemailaddress@gmail.com";
          }
        } else if (isAge!) {
          if (value.contains(RegExp(r'[A-Z]')) ||
              value.contains(RegExp(r'[a-z]'))) {
            return "Age can't contain letters";
          } else if (int.parse(value) > 14 || int.parse(value) < 6) {
            return "Age isn't in the specified range [7-13]";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(255, 58, 69, 139),
        filled: true,
        icon: Icon(Icon_Data),
        iconColor: const Color.fromARGB(255, 255, 255, 255),
        hintText: myHintText,
        labelText: Label_Text,
        errorStyle: const TextStyle(color: Color.fromARGB(255, 255, 74, 74)),
        hintStyle: const TextStyle(color: Color.fromARGB(255, 198, 205, 255)),
        labelStyle: const TextStyle(color: Color.fromARGB(134, 198, 205, 255)),
        focusColor: const Color.fromARGB(255, 88, 97, 156),
        hoverColor: const Color.fromARGB(255, 74, 83, 139),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 74, 74), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 64, 94, 228), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4b6dff), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        errorBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 255, 74, 74), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4b6dff), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}

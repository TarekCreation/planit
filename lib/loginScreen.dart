import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:planit/homeScreen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginscreen extends StatefulWidget {
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var formKey = GlobalKey<FormState>();
  bool _isSwitched = false;

  TextEditingController firstnameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (_isSwitched) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setBool('switch', _isSwitched);
      }
      // Use signInWithEmailAndPassword to log in instead of createUserWithEmailAndPassword
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          // After successful login, navigate to the home screen
          Get.off(() => Homescreen());
        },
      );
      print(credential);
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error: ${e.message}",
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Colors.red,
        padding: EdgeInsets.all(8),
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    bool? savedSwitch = prefs.getBool('switch');

    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
    }
    if (savedSwitch != null) {
      _isSwitched = savedSwitch;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          color: mainColor(),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Stack(children: [
                Opacity(
                  opacity: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 350,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/Untitle12.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 180,
                      ),
                      Container(
                        height: 200,
                        child: Image.asset(
                          'assets/pic2.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 340,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: CustomTextFormField(
                        ControllerValue: emailController,
                        Validator_Text: "Please Enter A Valid Email Address",
                        myHintText:
                            "Enter Your Email Address (ex. name@gmail.com)",
                        Label_Text: "Email Address",
                        Icon_Data: Icons.email,
                        isPassword: false,
                        isConfirmPassword: false,
                        passwordController: passwordController,
                        isEmail: true,
                        isPhoneNumber: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: CustomTextFormField(
                        ControllerValue: passwordController,
                        Validator_Text: "Please Enter A Valid Password",
                        myHintText: "Enter Your Password",
                        Label_Text: "Password",
                        Icon_Data: Icons.lock,
                        isPassword: true,
                        isConfirmPassword: false,
                        passwordController: passwordController,
                        isEmail: false,
                        isPhoneNumber: false,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: _isSwitched,
                          onChanged: (value) {
                            setState(() {
                              _isSwitched = value;
                            });
                          },
                          activeColor: darkOrangeColor(),
                          inactiveThumbColor:
                              const Color.fromARGB(255, 150, 150, 150),
                        ),
                        Text(
                          "Remember Me",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 180),
                          // child: GestureDetector(
                          //   onTap: () {
                          //     print('Text clicked!');
                          //   },
                          //   child: MouseRegion(
                          //     onEnter: (_) {
                          //       setState(() {
                          //         _isHovering = true;
                          //       });
                          //     },
                          //     onExit: (_) {
                          //       setState(() {
                          //         _isHovering = false;
                          //       });
                          //     },
                          //     cursor: SystemMouseCursors.click,
                          //     child: Text(
                          //       'Forgot Password?',
                          //       style: TextStyle(
                          //         fontSize: 15,
                          //         color: _isHovering
                          //             ? const Color(0xFF3886b8)
                          //             : const Color(0xFF767676),
                          //         decoration: _isHovering
                          //             ? TextDecoration.underline
                          //             : TextDecoration.none,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                    customButton("LOG IN", 30, () {
                      if (formKey.currentState!.validate()) {
                        loginUser(
                            email: emailController.text,
                            password: passwordController.text);
                      }
                    }, width: 330, height: 50),
                  ],
                ),
              ]),
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
  final bool? isPhoneNumber;
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
    this.isPhoneNumber,
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
        } else if (isPhoneNumber!) {
          if (value.contains(RegExp(r'[A-Z]')) ||
              value.contains(RegExp(r'[a-z]'))) {
            return "Phone numbers can't contain letters";
          } else if (!value.startsWith('+20') || value.length != 13) {
            return "Phone numbers must be in the format +201xxxxxxxxx";
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

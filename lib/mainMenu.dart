import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planit/homeScreen.dart';
import 'package:planit/loginScreen.dart';
import 'package:planit/registerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Mainmenu extends StatefulWidget {
  const Mainmenu({super.key});

  @override
  State<Mainmenu> createState() => _MainmenuState();
}

class _MainmenuState extends State<Mainmenu> {
  bool _isHovering = false;
  final user = FirebaseAuth.instance.currentUser;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Future<User?> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       return null;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     return userCredential.user;
  //   } catch (e) {
  //     print("Error signing in with Google: $e");
  //     return null;
  //   }
  // }

  // Future<void> _signOut() async {
  //   await _googleSignIn.signOut();
  //   await _auth.signOut();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        print("The Email is : ${user!.email}");
        Get.off(() => Homescreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          color: mainColor(),
          child: SingleChildScrollView(
            child: Stack(children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 390,
                  width: 390,
                  child: Image.asset(
                    'assets/planit3.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 440,
                    ),
                    Text("Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: whiteColor())),
                    Text("Learn The Beauty of exoplantes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: const Color.fromARGB(255, 133, 133, 133))),

                    const SizedBox(
                      height: 20,
                    ),
                    // customOneColorButton("Continue With Google", 10, () {
                    //   _signInWithGoogle();
                    // }, Colors.white, Colors.black, "assets/Layer 2.png",
                    //     width: 370, height: 50),
                    // customOneColorButton(
                    //     "Continue With FaceBook",
                    //     10,
                    //     () {},
                    //     const Color(0xFF062cb8),
                    //     Colors.white,
                    //     "assets/Layer 1.png",
                    //     width: 400,
                    //     height: 50),
                    customButton("Use E-mail/password", 10, () {
                      Get.to(() => Registerscreen());
                    }, width: 380, height: 50),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already Have Acount? ",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => Loginscreen());
                            },
                            child: MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _isHovering = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _isHovering = false;
                                });
                              },
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _isHovering
                                      ? const Color.fromARGB(255, 255, 128, 60)
                                      : const Color.fromARGB(255, 199, 80, 16),
                                  decoration: _isHovering
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
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

  Container customOneColorButton(String text, double margin, VoidCallback code,
      Color color, Color textColor, String imageLink,
      {double width = 330, double height = 50}) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),

        color: color,

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
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 14),
              height: 34,
              width: 34,
              child: Image.asset(
                imageLink,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: textColor)),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:planit/ItemDetails.dart';
import 'package:planit/pickImage.dart';
import 'package:planit/question.dart';
import 'package:planit/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/video.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({
    super.key,
  });

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String? newName;
  String? level;
  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  // Example usage:
  void fetchUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await getUserDetails(uid);
    setState(() {
      newName = userDoc['name'];
      level = userDoc['unlockedLevel'].toString();
    });
  }

  // Future<void> fetchProducts() async {
  //   try {
  //     QuerySnapshot snapshot = await _firestore.collection('products').get();
  //     Map<String, dynamic> fetchedData = {};

  //     for (var doc in snapshot.docs) {
  //       fetchedData[doc.id] = doc.data();
  //     }

  //     setState(() {
  //       productData = fetchedData;
  //     });
  //   } catch (e) {
  //     //print('Error fetching products: $e');
  //   }
  //}

  final user = FirebaseAuth.instance.currentUser;
  late String? userName = "Guest";
  late String? userEmail = "Guest@gmail.com";

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchUserDetails();
  }

  @override
  void didUpdateWidget(covariant Homescreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF3e4677),
        drawer: Drawer(
          backgroundColor: const Color(0xFF040d38),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 32),
                  height: 220,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/planit3.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(Loginscreen());
                  },
                  child: const Text("Sign Out",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 16),
                  ),
                  onPressed: () {
                    if (user != null) {
                      user?.delete();
                    }
                    Get.offAll(() => Loginscreen());
                  },
                  child: const Text("Delete User",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ]),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Home Page",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF040d38),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      "https://static.vecteezy.com/system/resources/previews/036/280/650/original/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg"),
                ),
                onTap: () {
                  Get.to(() => Pickimage());
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            //height: double.infinity,
            color: darkBlueColor(),
            child: Column(
              children: [
                customButton(
                  "Video",
                  30,
                  () {
                    Get.to(() => Video());
                  },
                ),
                level == null
                    ? CircularProgressIndicator()
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          if (index < int.parse(level!)) {
                            return questionButton(
                                (index + 1).toString(), index + 1);
                          } else {
                            return lockedQuestionButton();
                          }
                        },
                      )
              ],
            ),
          )),
        ));
  }

  Container questionButton(String buttonText, int questionID) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20), // Border radius for the container
        color: Colors.white
            .withOpacity(0.7), // White background with reduced opacity
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Optional shadow for depth
            blurRadius: 8,
            offset: Offset(0, 4), // Position of the shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(20), // Apply the same radius to the image
            child: Image.asset(
              "assets/Level.jpeg",
              fit: BoxFit.cover, // Ensures the image covers the container
              opacity: AlwaysStoppedAnimation(0.7), // Set opacity on the image
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, double.infinity),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Get.to(() => Question(
                    questionID: questionID,
                  ));
            },
            child: Text(
              buttonText, // Use the buttonText variable
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.white, // Change text color to white
                shadows: [
                  Shadow(
                    color: Colors.black
                        .withOpacity(0.8), // Black shadow for glow effect
                    blurRadius: 6.0, // Adjust blur radius for glow effect
                    offset: Offset(0, 0), // Position of the shadow
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container lockedQuestionButton() {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 119, 119, 119)),
      child: Stack(children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, double.infinity),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              //padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: Icon(
              Icons.lock,
              size: 40,
              color: Colors.white,
            ))
      ]),
    );
  }
}

class GridItem extends StatelessWidget {
  final String keynum;
  final String imageUrl;
  final String title;
  final String price;
  final String category;

  const GridItem({
    super.key,
    required this.keynum,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(() => Itemdetails(
              title: title,
              category: category,
              price: price,
              imageUrl: imageUrl));
        },
        child: Container(
          width: 220,
          height: 300,
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          softWrap: true,
                        ),
                        Text(
                          "->$category",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromARGB(255, 99, 99, 99),
                          ),
                          softWrap: true,
                        ),
                        Text(
                          "$price EGP.",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 233, 132, 0),
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: const Size(65, 120),
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      shadowColor: const Color.fromARGB(255, 0, 0, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Icon(
                      Icons.add,
                      size: 50,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

Container customButton(String text, double margin, VoidCallback code,
    {double width = 330, double height = 50}) {
  return Container(
    height: height,
    width: width,
    margin: EdgeInsets.all(margin),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border:
            Border.all(color: const Color.fromARGB(255, 167, 84, 7), width: 3),
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
        maximumSize: const Size(double.infinity, double.infinity),
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

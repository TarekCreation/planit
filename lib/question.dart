import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planit/ItemDetails.dart';

class Question extends StatefulWidget {
  final int? questionID;

  const Question({
    super.key,
    @required this.questionID,
  });

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> questionData = {};
  Map<String, dynamic> data = {};
  String? correctAnswer;
  bool didRevealAnswer = false;
  String? level;
  // Map<String, dynamic> clothesProductData = {};
  // Map<String, dynamic> accessoriesProductData = {};
  // Map<String, dynamic> shoesProductData = {};
  // Map<String, dynamic> drinkwareProductData = {};
  Future<DocumentSnapshot> getUserDetails(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  // Example usage:
  void addToUserScore() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await getUserDetails(uid);
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'score': userDoc['score'] + 10, // Specify the field and the new value
    });
    print("added 10 points to score");
  }

  void unlockLevel() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await getUserDetails(uid);
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'unlockedLevel': userDoc['unlockedLevel'] + 1,
    });
    print("unlockedLevel ${userDoc['unlockedLevel']}");
  }

  void fetchUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await getUserDetails(uid);
    setState(() {
      level = userDoc['unlockedLevel'].toString();
    });
    if (int.parse(level!) > widget.questionID!) {
      setState(() {
        didRevealAnswer = true;
      });
    }
  }

  Future<void> fetchQuestion() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('questions').get();
      Map<String, dynamic> fetchedData = {};

      for (var doc in snapshot.docs) {
        fetchedData[doc.id] = doc.data();
      }

      setState(() {
        questionData = fetchedData;
        data = questionData[widget.questionID.toString()];
        correctAnswer = data['correctAnswer'];
      });
    } catch (e) {
      //print('Error fetching products: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF040d38),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.questionID.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF040d38),
          actions: const [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    "https://static.vecteezy.com/system/resources/previews/036/280/650/original/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg"),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: correctAnswer == null
                  ? CircularProgressIndicator()
                  : Container(
                      width: double.infinity,

                      //height: double.infinity,
                      color: const Color(0xFF040d38),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  width: double.infinity,
                                  height: 70,
                                  //height: double.i,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Text(
                                      "Question Number. ${widget.questionID}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                          color:
                                              Color.fromARGB(255, 0, 0, 0))))),
                          Text("The question is : ${data['question']}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 255, 255, 255))),

                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                List<String> letters = ["A", "B", "C", "D"];

                                return choice(
                                  letters[index],
                                  data['option${index + 1}'],
                                  20,
                                  correctAnswer!,
                                );
                              }),

                          // imageUrl: items[index]['imageUrl']!,
                          // title: items[index]['title']!,
                          // price: items[index]['price']!)),
                        ],
                      ),
                    )),
        ));
  }

  Container choice(
      String choiceLetter, String text, double margin, String theCorrectAnswer,
      {double width = 330, double height = 50}) {
    if (didRevealAnswer) {
      if (text == theCorrectAnswer) {
        return Container(
          height: height,
          width: width,
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: const Color.fromARGB(255, 40, 168, 14), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(158, 37, 53, 82),
                  blurRadius: 50,
                  spreadRadius: 10,
                )
              ],
              gradient: LinearGradient(colors: [
                const Color.fromARGB(255, 46, 199, 16),
                const Color.fromARGB(255, 118, 245, 44)
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
            onPressed: () {},
            child: Text("$choiceLetter :  $text",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 255, 255))),
          ),
        );
      } else {
        return Container(
          height: height,
          width: width,
          margin: EdgeInsets.all(margin),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: const Color.fromARGB(255, 168, 14, 14), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(158, 37, 53, 82),
                  blurRadius: 50,
                  spreadRadius: 10,
                )
              ],
              gradient: LinearGradient(colors: [
                const Color.fromARGB(255, 199, 16, 16),
                const Color.fromARGB(255, 245, 44, 44)
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
            onPressed: () {},
            child: Text("$choiceLetter :  $text",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 255, 255))),
          ),
        );
      }
    } else {
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
            if (text == correctAnswer) {
              addToUserScore();
              unlockLevel();
            }
            setState(() {
              didRevealAnswer = true;
            });
          },
          child: Text("$choiceLetter :  $text",
              textAlign: TextAlign.left,
              style: const TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color.fromARGB(255, 255, 255, 255))),
        ),
      );
    }
  }

  Color mainColor() => const Color(0xFF040d38);

  Color whiteColor() => const Color(0xFFffffff);

  Color darkOrangeColor() => const Color(0xFFe75d14);

  Color darkBlueColor() => const Color(0xFF3e4677);

  Color orangeColor() => const Color(0xFFfeab4f);

  Color purpleColor() => const Color(0xFF9b6c9b);

  Color brownColor() => const Color(0xFF3f1919);
}

class ListItem extends StatelessWidget {
  final String keynum;
  final String imageUrl;
  final String title;
  final String price;
  final String category;

  const ListItem({
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
        width: 300,
        height: 220,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            const SizedBox(width: 1.0),
            Expanded(
              // Use Expanded here
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "$price EGP.",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color.fromARGB(255, 233, 132, 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(65, 120),
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
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
            ),
          ],
        ),
      ),
    );
  }
}

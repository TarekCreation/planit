import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Itemdetails extends StatefulWidget {
  final String? title;
  final String? category;
  final String? price;
  final String? imageUrl;
  const Itemdetails(
      {super.key,
      @required this.title,
      @required this.category,
      @required this.price,
      @required this.imageUrl});

  @override
  State<Itemdetails> createState() => _ItemdetailsState();
}

class _ItemdetailsState extends State<Itemdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            widget.title!,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 56, 56, 56),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5.0),
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
              child: Container(
            //height: double.infinity,
            color: const Color.fromARGB(255, 56, 56, 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                      color: whiteColor(),
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.category!,
                    style: TextStyle(
                      color: altColor(),
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 218, 141, 0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${widget.price!} EGP.",
                      style: TextStyle(
                        color: whiteColor(),
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: customButton("Add to cart", 10, () {
                    //Get.off(() => Loginscreen());
                  }, width: 250, height: 50),
                ),

                // imageUrl: items[index]['imageUrl']!,
                // title: items[index]['title']!,
                // price: items[index]['price']!)),
              ],
            ),
          )),
        ));
  }

  Container customButton(String text, double margin, VoidCallback code,
      {double width = 330, double height = 50}) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFF30698b), width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(158, 37, 53, 82),
              blurRadius: 50,
              spreadRadius: 10,
            )
          ],
          gradient: LinearGradient(colors: [buttonColor1st(), buttonColor2nd()])
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

  Color mainColor() => const Color.fromARGB(255, 56, 56, 56);

  Color altColor() => const Color(0xFFa0a0a0);

  Color whiteColor() => const Color(0xFFf1f1f1);

  Color facebookColor() => const Color(0xFF062cb8);

  Color itemsGreyColor() => const Color(0xFF767676);

  Color buttonColor1st() => const Color(0xFF3886b8);

  Color buttonColor2nd() => const Color.fromARGB(255, 143, 182, 206);
}

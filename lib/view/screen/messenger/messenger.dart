import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import '../../common/style.dart';
import 'messenger_body.dart';

class Messenger extends StatefulWidget {
  const Messenger({super.key});
  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colorWhite,
              size: 20,
            )),
        // ignore: prefer_const_constructors
        title: Center(
          child: const Text(
            "Tin nhắn",
            style: appBarTitle,
          ),
        ),

        // actions: [

        // ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/store-image-a4f19.appspot.com/o/image%2Fbackground%2Fbackground1.png?alt=media"),
              fit: BoxFit.cover,
            ),
          ),
          child: const MessengerBody()),
    );
  }
}

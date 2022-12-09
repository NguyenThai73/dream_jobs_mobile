// ignore_for_file: file_names, unnecessary_string_interpolations, must_be_immutable, unused_element

import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider.dart';
import '../screen/login/login.dart';
import '../screen/messenger/messenger.dart';
import '../screen/profile/profile.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({
    super.key,
  });
  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  var urlAvatar = "https://scr.vn/wp-content/uploads/2020/07/Avatar-Facebook-tr%E1%BA%AFng.jpg";
  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Drawer(
        backgroundColor: const Color.fromARGB(255, 215, 236, 255),
        child: Consumer<User>(
          builder: (context, user, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: maincolor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (user.user.avatar == "" || user.user.avatar == null)
                            ? ClipOval(
                                child: Image.network(
                                urlAvatar,
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ))
                            : ClipOval(
                                child: Image.network(
                                user.user.avatar!,
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              )),
                        const SizedBox(height: 10),
                        Text(user.user.fullname!, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400, color: colorWhite)),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Profile(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Hồ sơ',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Messenger(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.message,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Tin nhắn',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                    );
                    // user.changeAuthorization("");
                    // user.changeUser(UserLogin());
                    // user.changeListRecruitment({});
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),
              ],
            );
          },
        ));
  }
}

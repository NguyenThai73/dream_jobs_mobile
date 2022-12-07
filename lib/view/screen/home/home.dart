// ignore_for_file: deprecated_member_use, must_be_immutable, unnecessary_const
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider.dart';
import '../../common/color.dart';
import '../../common/style.dart';
import '../../components/drawer.dart';
import '../employers/employer.dart';
import '../recruitments/recruitments_screen.dart';
import 'home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _index = 0;
  var urlAvatar = "https://scr.vn/wp-content/uploads/2020/07/Avatar-Facebook-tr%E1%BA%AFng.jpg";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('${user.user.fullname}', style: appBarTitle),
            backgroundColor: maincolor,
            leading: TextButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                child: ClipOval(
                    child: (user.user.avatar == "" || user.user.avatar == null)
                        ? Image.network(urlAvatar, fit: BoxFit.cover, width: 50, height: 50)
                        : Image.network(user.user.avatar!, fit: BoxFit.cover, width: 50, height: 50))),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: colorWhite,
                ),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Đây là phần thông báo'),
                    backgroundColor: Colors.blue,
                  ));
                },
              ),
            ],
          ),
          drawer: const DrawerApp(),
          bottomNavigationBar: Container(
            // ignore: prefer_const_constructors
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(20),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                const BoxShadow(
                  color: maincolor,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: BottomNavigationBar(
              // selectedItemColor: Colors.blue,
              // unselectedItemColor: const Color.fromARGB(255, 78, 78, 78),
              // backgroundColor:maincolor,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 14,
              unselectedFontSize: 12,
              currentIndex: _index,
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
              // ignore: prefer_const_literals_to_create_immutables
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.card_travel,
                  ),
                  label: 'Việc làm',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.apartment,
                  ),
                  label: 'Công ty',
                ),
                BottomNavigationBarItem(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(
                        Icons.work_history,
                      ),
                      (user.countJobs > 0)
                          ? Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text("${user.countJobs}", style: const TextStyle(color: colorWhite))),
                            )
                          : Container()
                    ],
                  ),
                  label: 'Ứng tuyển',
                )
              ],
            ),
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/store-image-a4f19.appspot.com/o/image%2Fbackground%2Fbackground5.png?alt=media&token=41bc8e7d-7770-4ff1-8060-3c71f52c7270"),
                fit: BoxFit.cover,
              ),
            ),
            child: (_index == 1)
                ? const EmployerScreen()
                : (_index == 0)
                    ? HomeBody()
                    : const RecruitmentScreen(),
          ));
    });
  }
}

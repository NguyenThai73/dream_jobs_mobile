// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:an_toan_bao_mat_trong_ptpmdd/controllers/api.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/model/user.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/style.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/screen/sign/sign-body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/provider.dart';
import '../../common/color.dart';
import '../home/home.dart';
import '../login/login.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerR = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Center(child: const CircularProgressIndicator());
        },
      );
    }

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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/store-image-a4f19.appspot.com/o/image%2Fbackground%2Fbackground.png?alt=media&token=41bc8e7d-7770-4ff1-8060-3c71f52c7270"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SignScreenBody(
              name: _nameController,
              controller: _emailController,
              passWordController: _passwordController,
              passWordControllerR: _passwordControllerR,
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                child: const Text('Đăng ký', style: textButtonStyle),
                onPressed: () async {
                  processing();
                  if (_nameController.text != "" &&
                      _emailController.text != "" &&
                      _passwordController.text != "" &&
                      _passwordControllerR.text != "") {
                    if (_passwordController.text == _passwordControllerR.text) {
                      var requestBody = {
                        "fullname": _nameController.text,
                        "email": _emailController.text,
                        "password": _passwordController.text,
                      };
                      var response1 = await httpPostRegister(requestBody, context);
                      if (response1.containsKey("body")) {
                        var body = jsonDecode(response1['body']);
                        if (body['success']) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Tạo tài khoản thành công"),
                            backgroundColor: Colors.blue,
                          ));
                          String email = body['data']['email'];
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => LoginScreen(
                                email: email,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(body['message']),
                            backgroundColor: Colors.blue,
                          ));
                          Navigator.pop(context);
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Mật khẩu không khớp"),
                        backgroundColor: Colors.blue,
                      ));
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Cần nhập đầy đủ thông tin"),
                      backgroundColor: Colors.blue,
                    ));
                  }
                  // var requestBody = {"email": _emailController.text, "password": _passwordController.text};
                  // var response = await httpPostLogin(requestBody, context);
                  // if (response.containsKey("body")) {
                  //   var body = jsonDecode(response['body']);
                  //   if (body['success']) {
                  //     UserLogin userLogin = UserLogin.fromJson(body);
                  //     user.changeAuthorization(body['accessToken']);
                  //     user.changeUser(userLogin);
                  //     Navigator.push<void>(
                  //       context,
                  //       MaterialPageRoute<void>(
                  //         builder: (BuildContext context) => HomePage(),
                  //       ),
                  //     );
                  //   } else {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text(body['message']),
                  //   backgroundColor: Colors.blue,
                  // ));
                  //     Navigator.pop(context);
                  //   }
                  // }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously, unused_local_variable

import 'dart:convert';

import 'package:an_toan_bao_mat_trong_ptpmdd/controllers/api.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/model/user.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/provider.dart';
import '../../../model/careers.dart';
import '../../../model/employers.dart';
import '../../../model/jobs.dart';
import '../../../model/recruitments.dart';
import '../home/home.dart';
import '../sign/sign.dart';
import 'login-body.dart';

class LoginScreen extends StatefulWidget {
  String? email;
  LoginScreen({Key? key, this.email}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<Map<int, Recruitment>> getListRecruitment(int userId) async {
    Map<int, Recruitment> listRecruitments = {};
    var response1 = await httpGet("/api/recruitment/$userId", context);
    if (response1.containsKey("body")) {
      var body = jsonDecode(response1['body']);
      for (var element in body) {
        Recruitment item = Recruitment(
          id: element['id'],
          userId: element['user_id'],
          jobId: element['jobs']['id'],
          job: Jobs(
            id: element['jobs']['id'],
            employer: Employer(id: element['jobs']['employer_id']),
            careers: Careers(id: element['jobs']['career_id']),
            qty: element['jobs']['qty'] ?? "",
            name: element['jobs']['name'] ?? "",
            salary: element['jobs']['salary'] ?? "",
            age: element['jobs']['age'] ?? "",
            englishLevel: element['jobs']['englishLevel'] ?? "",
            expirationDate: element['jobs']['expirationDate'] ?? "",
            otherRequirements: element['jobs']['otherRequirements'] ?? "",
            addRess: element['jobs']['addRess'] ?? "",
            provinceCode: element['jobs']['provinceCode'],
            status: element['jobs']['status'],
            exp: element['jobs']['exp'] ?? "",
          ),
          status: element['status'],
          apply: element['apply'],
          applyNote: element['applyNote'],
          applyDate: element['applyDate'],
        );
        listRecruitments[item.job?.id ?? 0] = item;
      }
    }
    return listRecruitments;
  }

  @override
  void initState() {
    super.initState();
    if (widget.email != null) _emailController.text = widget.email!;
  }

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

    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
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
              LoginScreenBody(
                controller: _emailController,
                passWordController: _passwordController,
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  child: const Text('Đăng nhập', style: textButtonStyle),
                  onPressed: () async {
                    processing();
                    var requestBody = {"email": _emailController.text, "password": _passwordController.text};
                    var response = await httpPostLogin(requestBody, context);
                    if (response.containsKey("body")) {
                      var body = jsonDecode(response['body']);
                      if (body['success']) {
                        UserLogin userLogin = UserLogin.fromJson(body);
                        user.changeAuthorization(body['accessToken']);
                        user.changeUser(userLogin);
                        Map<int, Recruitment> listRecruitmentsUser = await getListRecruitment(user.user.id!);
                        user.changeListRecruitment(listRecruitmentsUser);
                        int count = 0;
                        for (var element1 in listRecruitmentsUser.keys) {
                          if (listRecruitmentsUser[element1]?.status == 0) count += 1;
                        }
                        user.changeCountJobs(count);
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => HomePage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(body['message']),
                          backgroundColor: Colors.blue,
                        ));
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Chưa có tài khoản?",
                    style: textAppStyle,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const SignScreen(),
                          ),
                        );
                      },
                      child: Text("Đăng ký", style: textAppStyle)),
                  const SizedBox(width: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use, must_be_immutable, use_build_context_synchronously
import 'dart:convert';

import 'package:an_toan_bao_mat_trong_ptpmdd/model/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/api.dart';
import '../../../controllers/provider.dart';
import '../../common/color.dart';
import '../../common/style.dart';
import '../../components/toast.dart';
import 'profile_body.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool checkEdit = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
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
          child: const Text("Hồ sơ", style: appBarTitle),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              if (checkEdit) {
                setState(() {
                  checkEdit = false;
                });
              } else {
                setState(() {
                  checkEdit = true;
                });
                var user = Provider.of<User>(context, listen: false);
                String birthdayFormat = "";
                if (user.user.birthday != null)
                  birthdayFormat = user.user.birthday!.substring(6) + user.user.birthday!.substring(2, 6) + user.user.birthday!.substring(0, 2);
                var requestBody = {
                  "fullname": user.user.fullname,
                  "birthday": (birthdayFormat != "") ? birthdayFormat : null,
                  "sdt": user.user.sdt,
                  "gender": user.user.gender,
                  "idCardNo": user.user.idCardNo,
                  "addRess": user.user.addRess,
                  "cv": user.user.cv,
                  "avatar": user.user.avatar,
                  "career": user.user.career,
                  "height": user.user.height
                };
                var response = await httpPut("/api/user/put/${user.user.id}", requestBody, context);
                if (response.containsKey("body")) {
                  var body = jsonDecode(response['body']);
                  if (body) {
                    showToast(
                      context: context,
                      msg: "Cập nhật thành công",
                      color: colorWhite,
                      timeHint: 1,
                      bottom: 10,
                      left: 15,
                      right: 15,
                      icon: const Icon(
                        Icons.done,
                        color: colorBlack,
                      ),
                    );
                  } else {
                    showToast(
                      context: context,
                      msg: "Cập nhật thất bại",
                      color: const Color.fromARGB(255, 245, 132, 124),
                      timeHint: 1,
                      bottom: 10,
                      left: 15,
                      right: 15,
                      icon: const Icon(
                        Icons.warning,
                        color: Colors.white,
                      ),
                    );
                  }
                }
              }
            },
            icon: Icon(
              (checkEdit) ? Icons.edit_note : Icons.done,
              color: colorWhite,
            ),
          )
        ],
      ),
      body: ProfileBody(
        checkEdit: checkEdit,
      ),
    );
  }
}

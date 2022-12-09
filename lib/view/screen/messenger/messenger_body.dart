// ignore_for_file: unused_import, depend_on_referenced_packages, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:math';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../../controllers/api.dart';
import '../../../controllers/provider.dart';
import '../../common/style.dart';
import 'messenger_item.dart';

class MessengerBody extends StatefulWidget {
  const MessengerBody({super.key});
  @override
  State<MessengerBody> createState() => _MessengerBodyState();
}

class _MessengerBodyState extends State<MessengerBody> {
  var listMassengerAll = {};
  getMessenger(int id) async {
    var response = await httpGet("/api/messenger/get/$id", context);
    var body = jsonDecode(response['body']) ?? [];
    if (body.length > 0) {
      listMassengerAll = groupBy(body, (dynamic obj) {
        return obj['jobId'];
      });
    }
  }

  bool status = false;
  void callApi(int id) async {
    await getMessenger(id);
    setState(() {
      status = true;
    });
  }

  @override
  void initState() {
    super.initState();
    var user = Provider.of<User>(context, listen: false);

    callApi(user.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (listMassengerAll.isNotEmpty)
          ? Column(children: [
              const SizedBox(height: 10),
              for (var element in listMassengerAll.keys) MessengerBoxx(listMassenger: listMassengerAll[element]).build(context)
            ])
          : const Text(""),
    );
  }
}

class MessengerBoxx {
  var listMassenger;
  MessengerBoxx({this.listMassenger});
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      // padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 1,
      decoration: BoxDecoration(
        color: maincolor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () async {},
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: maincolor),
              width: 60,
              height: 60,
              child: ClipOval(
                  child: Image.network(
                listMassenger.first['employer']['logo'],
                fit: BoxFit.cover,
                height: 60,
                width: 60,
              )),
            ),
          ),
          TextButton(
            onPressed: () {
              //  MessengerItem
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => MessengerItem(
                    listMassenger: listMassenger,
                  ),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${listMassenger.first['jobsName']}",
                      style: AppStyles.appTextStyle(color: colorWhite, size: 22, weight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.apartment,
                        color: colorWhite,
                      ),
                      Flexible(
                          child: Text(" ${listMassenger.first['employer']['name']}",
                              style: AppStyles.appTextStyle(color: colorWhite, size: 19), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          (listMassenger.first['to'] == 0) ? "Bạn: ${listMassenger.first['content']}" : "${listMassenger.first['content']}",
                          style: AppStyles.appTextStyle(
                              color: colorWhite,
                              size: 17,
                              weight: (listMassenger.first['to'] == 1 && listMassenger.first['status'] == 0) ? FontWeight.w900 : FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      (listMassenger.first['to'] == 1 && listMassenger.first['status'] == 0)
                          ? const Icon(
                              Icons.fiber_manual_record,
                              color: colorWhite,
                            )
                          : const Text(""),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

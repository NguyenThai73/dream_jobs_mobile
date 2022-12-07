// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use

import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../controllers/api.dart';
import '../../../model/careers.dart';
import '../../../model/employers.dart';
import '../../../model/jobs.dart';
import '../../components/employer-item-list.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});
  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {
  List<Employer> listEmployers = [];
  Future<List<Employer>> getList() async {
    listEmployers = [];
    var response1 = await httpGet("/api/employer/get", context);

    if (response1.containsKey("body")) {
      var body = jsonDecode(response1['body']);
      for (var element in body) {
        Employer item = Employer(
            id: element['id'],
            name: element['name'],
            avatar: element['avatar'],
            logo: element['logo'],
            addRess: element['addRess'],
            status: element['status'],
            career: element['career'],
            sdt: element['sdt'],
            email: element['email'],
            introduce: element['introduce'],
            scale: element['scale'],
            listJobs: []);
        item.listJobs = await getJobs(element['id']);
        listEmployers.add(item);
      }
      setState(() {});
    }
    return listEmployers;
  }

  Future<List<Jobs>> getJobs(int idEmloyer) async {
    List<Jobs> listJobs = [];
    var response1 = await httpGet("/api/job/employerId/$idEmloyer", context);
    if (response1.containsKey("body")) {
      var body = jsonDecode(response1['body']);
      setState(() {
        for (var element in body) {
          Jobs item = Jobs(
            id: element['id'],
            employer: Employer.fromJson(element['employerName']),
            careers: Careers.fromJson(element['careerName']),
            name: element['name'],
            qty: element['qty'] ?? "",
            status: element['status'],
            salary: element['salary'] ?? "",
            age: element['age'] ?? "",
            englishLevel: element['englishLevel'],
            expirationDate: element['expirationDate'],
            otherRequirements: element['otherRequirements'],
            provinceCode: element['provinceCode'],
            exp: element['exp'] ?? "",
            addRess: element['addRess'] ?? "",
          );
          listJobs.add(item);
        }
      });
    }
    return listJobs;
  }

  Map<int, String> provinces = {};
  getProvinces() async {
    var response2 = await httpGetNo("https://provinces.open-api.vn/api/?depth=1", context);
    if (response2.containsKey("body")) {
      List<dynamic> body = response2['body'];
      for (var element in body) {
        provinces[element['code']] = element['name'];
      }
    }
  }

  bool statusData = false;
  void callAPI() async {
    await getList();
    await getProvinces();
    setState(() {
      statusData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return (statusData)
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  // decoration: BoxDecoration(
                  //   border: Border.all(width: 1)
                  // ),
                  child: DropdownSearch<Employer>(
                    hint: "Tên công ty",
                    mode: Mode.MENU,
                    maxHeight: 350,
                    showSearchBox: true,
                    onFind: (String? filter) => getListEmployer(context),
                    itemAsString: (Employer? u) => "${u!.name}",
                    // dropdownSearchDecoration: InputDecoration(
                    //   contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                    // ),
                    // selectedItem: selectedItem,
                    onChanged: (value) {},
                  ),
                ),
                for (var element in listEmployers)
                  EmployerItemList(
                    employer: element,
                    provinces: provinces,
                  )
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

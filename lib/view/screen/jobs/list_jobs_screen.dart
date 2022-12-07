// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../controllers/api.dart';
import '../../../model/careers.dart';
import '../../../model/jobs.dart';
import '../../common/color.dart';
import '../../common/style.dart';
import '../../components/job-item-list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class JobsScreen extends StatefulWidget {
  List<Jobs> listJobs;
  String titlePage;
  Map<int, String> province;
  bool? check;
  bool? statusCheck;
  JobsScreen({
    super.key,
    required this.listJobs,
    required this.titlePage,
    required this.province,
    this.check,
    this.statusCheck,
  });
  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<Jobs> listJobsView = [];
  void sortData() async {
    setState(() {
      listJobsView = [];
      listJobsView = widget.listJobs;
    });
  }

  Future<List<Province>> getProvinces() async {
    List<Province> listProvinces = [Province(code: 0, name: "Tất cảc ")];
    var response2 = await httpGetNo("https://provinces.open-api.vn/api/?depth=1", context);
    if (response2.containsKey("body")) {
      List<dynamic> body = response2['body'];
      for (var element in body) {
        listProvinces.add(Province(code: element['code'], name: element['name']));
      }
    }
    return listProvinces;
  }

  Future<List<Careers>> getNganhNghe() async {
    List<Careers> listCareer = [Careers(id: 0, name: "Tất cả", parentId: 0)];
    var response = await httpGet("/api/career/get", context);
    var body = jsonDecode(response['body']);
    for (var element in body) {
      Careers item = Careers(
        id: element['id'],
        name: element['name'],
        parentId: element['parentId'],
      );
      listCareer.add(item);
    }
    return listCareer;
  }

  Map<int, String> listSalary = {0: "Tất cả", 1: "<10 triệu", 2: "10-20 triệu", 3: "20-30 triệu", 4: "30-40 triệu", 5: "40-50 triệu", 6: ">50 triệu"};
  @override
  void initState() {
    super.initState();
    sortData();
  }

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
          child: Text(widget.titlePage, style: appBarTitle),
        ),
        // actions: [

        // ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (widget.statusCheck != null && widget.statusCheck == true)
                  ? Container(
                      height: 250,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: maincolor.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Khu vực",
                                  style: AppStyles.appTextStyle(
                                    color: colorBlack,
                                    size: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  decoration: const BoxDecoration(
                                    color: colorWhite,
                                  ),
                                  height: 40,
                                  child: DropdownSearch<Province>(
                                    hint: "Tất cả",
                                    mode: Mode.MENU,
                                    maxHeight: 350,
                                    showSearchBox: true,
                                    onFind: (String? filter) => getProvinces(),
                                    itemAsString: (Province? u) => u!.name,
                                    // selectedItem: selectedCareer,
                                    dropdownSearchDecoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 0.5),
                                      ),
                                      hintMaxLines: 1,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 148, 148, 148), width: 0.5),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      // selectedCareer = value!;
                                      // navigatePush(context,
                                      //     secondPage: JobsInfor(
                                      //       job: value,
                                      //     ));
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Ngành nghề",
                                  style: AppStyles.appTextStyle(
                                    color: colorBlack,
                                    size: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  decoration: const BoxDecoration(
                                    color: colorWhite,
                                  ),
                                  height: 40,
                                  child: DropdownSearch<Careers>(
                                    hint: "Tất cả",
                                    mode: Mode.MENU,
                                    maxHeight: 350,
                                    showSearchBox: true,
                                    onFind: (String? filter) => getNganhNghe(),
                                    itemAsString: (Careers? u) => "${u!.name}",
                                    // selectedItem: selectedCareers,
                                    dropdownSearchDecoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 14, bottom: 10),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 102, 102, 102), width: 0.5),
                                      ),
                                      hintMaxLines: 1,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 148, 148, 148), width: 0.5),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      // selectedCareer = value!;
                                      // navigatePush(context,
                                      //     secondPage: JobsInfor(
                                      //       job: value,
                                      //     ));
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Mức lương",
                                  style: AppStyles.appTextStyle(
                                    color: colorBlack,
                                    size: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: colorWhite,
                                  ),
                                  height: 40,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      dropdownMaxHeight: 250,
                                      items:
                                          listSalary.entries.map((item) => DropdownMenuItem<int>(value: item.key, child: Text(item.value))).toList(),
                                      // value: selectedSalary,
                                      onChanged: (value) {
                                        setState(() {
                                          // selectedSalary = value as int;
                                        });
                                      },
                                      buttonHeight: 40,
                                      itemHeight: 40,
                                      dropdownDecoration: BoxDecoration(
                                        border: Border.all(
                                          color: colorWhite,
                                        ),
                                      ),
                                      buttonDecoration: BoxDecoration(
                                        border: Border.all(width: 0.5, style: BorderStyle.solid, color: const Color.fromARGB(255, 102, 102, 102)),
                                        color: colorWhite,
                                      ),
                                      buttonElevation: 0,
                                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                                      dropdownElevation: 5,
                                      focusColor: colorWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 150,
                                margin: EdgeInsets.only(right: 15),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 5.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    backgroundColor: maincolor,
                                    primary: Theme.of(context).iconTheme.color,
                                    textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                  ),
                                  onPressed: () async {
                                    // await reLoad(addRess.text, selectedCareer.id, selectedSalary, exp.text);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Lọc",
                                        style: AppStyles.appTextStyle(size: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 5.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    backgroundColor: Colors.red,
                                    primary: Theme.of(context).iconTheme.color,
                                    textStyle: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10.0, letterSpacing: 2.0),
                                  ),
                                  onPressed: () async {
                                    // setState(() {
                                    //   listJobsFind = widget.listJobs;
                                    //   addRess.text = "";
                                    //   selectedCareer = Career(id: 0, name: "", parentId: 0);
                                    //   selectedSalary = 0;
                                    //   exp.text = "";
                                    // });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Hủy lọc",
                                        style: AppStyles.appTextStyle(size: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : Row(),
              for (var element in listJobsView)
                JobItemList(
                  job: element,
                  imageBackground: "assets/images/image-background-card-5.jpg",
                  province: widget.province[element.provinceCode],
                )
            ],
          ),
        ),
      ),
    );
  }
}

class Province {
  int code;
  String name;
  Province({required this.code, required this.name});
}

// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, prefer_const_constructors, use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/screen/jobs/job-info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/api.dart';
import '../../../controllers/provider.dart';
import '../../../model/careers.dart';
import '../../../model/employers.dart';
import '../../../model/jobs.dart';
import '../../common/style.dart';
import '../../components/Job_box.dart';
import '../jobs/list_jobs_screen.dart';

class HomeBody extends StatefulWidget {
  HomeBody({super.key});
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<Jobs> listJobs = [];
  List<Jobs> listJobsFit = [];
  List<Jobs> listJobsHot = [];
  List<Jobs> listJobsIT = [];
  List<Jobs> listJobsNew = [];
  List<Jobs> listJobsSalary = [];

  Future<List<Jobs>> getJobs() async {
    listJobs = [];
    var response1 = await httpGet("/api/job/get", context);
    if (response1.containsKey("body")) {
      var body = jsonDecode(response1['body']);
      var user = Provider.of<User>(context, listen: false);
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
          if (user.user.height == item.careers.id) listJobsFit.add(item);
          if (9 == item.careers.id || 10 == item.careers.id) listJobsIT.add(item);
          if (item.id! < 10) listJobsNew.add(item);
          var salary = int.tryParse(item.salary!);
          if (salary! > 15000000) listJobsSalary.add(item);
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

  bool light = false;
  bool checkStt = false;
  void callApi() async {
    await getJobs();
    await getProvinces();
    setState(() {
      checkStt = true;
    });
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return (checkStt)
        ? SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Switch(
                          // This bool value toggles the switch.
                          value: light,
                          activeColor: maincolor,
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              light = value;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        (light)
                            ? Text(
                                "Trạng thái tìm việc đang bật",
                                style: AppStyles.appTextStyle(color: maincolor, size: 16),
                              )
                            : Text(
                                "Trạng thái tìm việc đang tắt",
                                style: AppStyles.appTextStyle(color: colorBlack, size: 16),
                              ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => JobsScreen(
                                listJobs: listJobs,
                                titlePage: "Việc làm",
                                province: provinces,
                                statusCheck: true,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.filter_alt,
                          size: 35,
                          color: maincolor,
                        ))
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Icons.eco, color: maincolor, size: 25),
                        const SizedBox(width: 5),
                        Text(
                          "Việc làm phù hợp",
                          style: AppStyles.medium(),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => JobsScreen(
                              listJobs: listJobsFit,
                              titlePage: "Việc làm phù hợp",
                              province: provinces,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Xem tất cả",
                        style: AppStyles.links(),
                      ),
                    )
                  ],
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 220.0,
                    viewportFraction: 0.83,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: listJobsFit.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => JobInfo(
                                    job: item,
                                    province: provinces[item.provinceCode],
                                  ),
                                ),
                              );
                            },
                            child: JobBox(
                              job: item,
                              province: provinces[item.provinceCode],
                              imageBackground: "assets/images/image-background-card-2.jpg",
                            ));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Icons.local_fire_department, color: maincolor, size: 25),
                        const SizedBox(width: 5),
                        Text(
                          "Việc làm hot",
                          style: AppStyles.medium(),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => JobsScreen(
                              listJobs: listJobs,
                              titlePage: "Việc làm hot",
                              province: provinces,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Xem tất cả",
                        style: AppStyles.links(),
                      ),
                    )
                  ],
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: listJobs.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => JobInfo(
                                    job: item,
                                    province: provinces[item.provinceCode],
                                  ),
                                ),
                              );
                            },
                            child: JobBox(
                              job: item,
                              province: provinces[item.provinceCode],
                              imageBackground: "assets/images/image-background-card-1.png",
                            ));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Icons.new_releases, color: maincolor, size: 25),
                        const SizedBox(width: 5),
                        Text(
                          "Việc làm mới",
                          style: AppStyles.medium(),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => JobsScreen(
                              listJobs: listJobsNew,
                              titlePage: "Việc làm mới",
                              province: provinces,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Xem tất cả",
                        style: AppStyles.links(),
                      ),
                    )
                  ],
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: listJobsNew.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => JobInfo(
                                    job: item,
                                    province: provinces[item.provinceCode],
                                  ),
                                ),
                              );
                            },
                            child: JobBox(
                              job: item,
                              province: provinces[item.provinceCode],
                              imageBackground: "assets/images/image-background-card-1.png",
                            ));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Icons.code, color: maincolor, size: 25),
                        const SizedBox(width: 5),
                        Text(
                          "Việc làm IT",
                          style: AppStyles.medium(),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => JobsScreen(
                              listJobs: listJobsIT,
                              titlePage: "Việc làm IT",
                              province: provinces,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Xem tất cả",
                        style: AppStyles.links(),
                      ),
                    )
                  ],
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: listJobsIT.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => JobInfo(
                                    job: item,
                                    province: provinces[item.provinceCode],
                                  ),
                                ),
                              );
                            },
                            child: JobBox(
                              job: item,
                              province: provinces[item.provinceCode],
                              imageBackground: "assets/images/image-background-card-1.png",
                            ));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Icons.request_quote, color: maincolor, size: 25),
                        const SizedBox(width: 5),
                        Text(
                          "Việc làm lương cao",
                          style: AppStyles.medium(),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => JobsScreen(
                              listJobs: listJobsSalary,
                              titlePage: "Việc làm lương cao",
                              province: provinces,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Xem tất cả",
                        style: AppStyles.links(),
                      ),
                    )
                  ],
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: listJobsSalary.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                            onPressed: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => JobInfo(
                                    job: item,
                                    province: provinces[item.provinceCode],
                                  ),
                                ),
                              );
                            },
                            child: JobBox(
                              job: item,
                              province: provinces[item.provinceCode],
                              imageBackground: "assets/images/image-background-card-1.png",
                            ));
                      },
                    );
                  }).toList(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 15),
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.green;
                        }
                        return maincolor;
                      }),
                    ),
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => JobsScreen(
                            listJobs: listJobs,
                            titlePage: "Việc làm",
                            province: provinces,
                            statusCheck: true,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Xem tất cả",
                      style: AppStyles.appTextStyle(size: 20, color: colorWhite),
                    ),
                  ),
                )
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

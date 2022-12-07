// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use
import 'dart:convert';

import 'package:an_toan_bao_mat_trong_ptpmdd/model/jobs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controllers/api.dart';
import '../../../controllers/provider.dart';
import '../../../model/careers.dart';
import '../../../model/employers.dart';
import '../../../model/recruitments.dart';
import '../../common/color.dart';
import '../../common/style.dart';
import '../../components/job-item-list.dart';
import '../jobs/job-info.dart';

class RecruitmentScreen extends StatefulWidget {
  const RecruitmentScreen({super.key});
  @override
  State<RecruitmentScreen> createState() => _RecruitmentScreenState();
}

class _RecruitmentScreenState extends State<RecruitmentScreen> {
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

  List<Recruitment> listRecruitmentChoPhanHoi = []; //Chờ phản hồi:0
  List<Recruitment> listRecruitmentSave = []; //Save:1
  List<Recruitment> listRecruitmentChoPV = []; //Chờ phỏng vấn:2
  List<Recruitment> listRecruitmentPass = []; //Đã trúng tuyển:3
  List<Recruitment> listRecruitmentTuChoi = []; //Đã từ chối:4
  setupData() async {
    var user = Provider.of<User>(context, listen: false);
    Map<int, Recruitment> mapRecruitments = await getListRecruitment(user.user.id!);
    user.changeListRecruitment(mapRecruitments);
    for (var element in user.listRecruitment.keys) {
      user.listRecruitment[element]?.job?.employer = await getEmployer(user.listRecruitment[element]?.job?.employer.id ?? 0);
      user.listRecruitment[element]?.job?.careers = await getCareer(user.listRecruitment[element]?.job?.careers.id ?? 0);
      if (user.listRecruitment[element]?.status == 0) {
        listRecruitmentChoPhanHoi.add(user.listRecruitment[element]!);
      } else if (user.listRecruitment[element]?.status == 1) {
        listRecruitmentSave.add(user.listRecruitment[element]!);
      } else if (user.listRecruitment[element]?.status == 2) {
        listRecruitmentChoPV.add(user.listRecruitment[element]!);
      } else if (user.listRecruitment[element]?.status == 3) {
        listRecruitmentPass.add(user.listRecruitment[element]!);
      } else if (user.listRecruitment[element]?.status == 4) {
        listRecruitmentTuChoi.add(user.listRecruitment[element]!);
      }
    }
    user.changeCountJobs(listRecruitmentChoPhanHoi.length);
  }

  Future<Employer> getEmployer(int idEmloyer) async {
    Employer employer = Employer();
    var response1 = await httpGet("/api/employer/$idEmloyer", context);
    if (response1.containsKey("body")) {
      var body = jsonDecode(response1['body']);
      employer = Employer(
          id: body['id'],
          name: body['name'],
          avatar: body['avatar'],
          logo: body['logo'],
          addRess: body['addRess'],
          status: body['status'],
          career: body['career'],
          sdt: body['sdt'],
          email: body['email'],
          introduce: body['introduce'],
          scale: body['scale'],
          listJobs: []);
      setState(() {});
    }
    return employer;
  }

  Future<Careers> getCareer(int idCareer) async {
    Careers career = Careers();
    var response1 = await httpGet("/api/career/$idCareer", context);
    if (response1.containsKey("body")) {
      var body = jsonDecode(response1['body']);
      career = Careers(id: body['id'], name: body['name'], parentId: body['parentId']);
      setState(() {});
    }
    return career;
  }

  bool statusData = false;
  void callAPI() async {
    await setupData();
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
        ? Consumer<User>(
            builder: (context, user, child) => DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: TabBar(
                      indicatorWeight: 3,
                      isScrollable: true,
                      indicatorColor: maincolor,
                      tabs: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorWhite,
                            border: Border.all(width: 1, color: maincolor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 180,
                          height: 40,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.receipt_long,
                                color: maincolor,
                              ),
                              const SizedBox(width: 10),
                              Text("Đã ứng tuyển", style: AppStyles.medium()),
                            ],
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: colorWhite,
                        //     border: Border.all(width: 1, color: maincolor),
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   width: 180,
                        //   height: 40,
                        //   child: Row(
                        //     children: [
                        //       const SizedBox(width: 10),
                        //       const Icon(
                        //         Icons.bookmark,
                        //         color: maincolor,
                        //       ),
                        //       const SizedBox(width: 10),
                        //       Text("Đã lưu", style: AppStyles.medium()),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            color: colorWhite,
                            border: Border.all(width: 1, color: maincolor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 200,
                          height: 40,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.phone_in_talk,
                                color: maincolor,
                              ),
                              const SizedBox(width: 10),
                              Text("Chờ phỏng vấn", style: AppStyles.medium()),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colorWhite,
                            border: Border.all(width: 1, color: maincolor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 180,
                          height: 40,
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.history,
                                color: maincolor,
                              ),
                              const SizedBox(width: 10),
                              Text("Lịch sử", style: AppStyles.medium()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.9,
                        decoration: BoxDecoration(
                          color: maincolor.withOpacity(0.1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var element in listRecruitmentChoPhanHoi)
                              JobItemList(
                                job: element.job ?? Jobs(name: '', employer: Employer(), careers: Careers()),
                                imageBackground: "assets/images/image-background-card-5.jpg",
                                province: provinces[element.job?.provinceCode],
                              )
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.all(10),
                      //   padding: const EdgeInsets.all(10),
                      //   width: MediaQuery.of(context).size.width * 1,
                      //   height: MediaQuery.of(context).size.height * 0.9,
                      //   decoration: BoxDecoration(
                      //     color: maincolor.withOpacity(0.1),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       for (var element in listRecruitmentSave)
                      //         JobItemList(
                      //           job: element.job ?? Jobs(name: '', employer: Employer(), careers: Careers()),
                      //           imageBackground: "assets/images/image-background-card-5.jpg",
                      //           province: provinces[element.job?.provinceCode],
                      //         )
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.9,
                        decoration: BoxDecoration(
                          color: maincolor.withOpacity(0.1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var element in listRecruitmentChoPV)
                              JobItemList(
                                job: element.job ?? Jobs(name: '', employer: Employer(), careers: Careers()),
                                imageBackground: "assets/images/image-background-card-5.jpg",
                                province: provinces[element.job?.provinceCode],
                              )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.9,
                        decoration: BoxDecoration(
                          color: maincolor.withOpacity(0.1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var element in listRecruitmentPass)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 102, 97, 97).withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 20,
                                      offset: const Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        // ignore: prefer_const_literals_to_create_immutables
                                        boxShadow: [
                                          BoxShadow(color: colorBlack.withOpacity(0.1), spreadRadius: 1, blurRadius: 1, blurStyle: BlurStyle.solid),
                                        ],
                                        image: const DecorationImage(
                                          image: AssetImage("assets/images/image-background-card-5.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Row(
                                            // FadeInImage.assetNetwork(placeholder: placeholder, image: image),
                                            children: [
                                              const SizedBox(width: 10),
                                              Image.network(
                                                element.job?.employer.logo! ?? "",
                                                fit: BoxFit.fill,
                                                width: 50,
                                                height: 50,
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  element.job?.name ?? "",
                                                  style: AppStyles.appTextStyle(size: 20, color: colorBlack, weight: FontWeight.w600),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.verified,
                                                size: 30,
                                                color: Colors.green,
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            element.job?.employer.name! ?? "",
                                            style: AppStyles.appTextStyle(color: colorBlack, size: 14),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const SizedBox(width: 15),
                                              Row(
                                                children: [
                                                  const Icon(Icons.paid, size: 25, color: maincolor),
                                                  Text(" ${element.job?.salary}",
                                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                                                ],
                                              ),
                                              const SizedBox(width: 15),
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on, size: 25, color: maincolor),
                                                  Text(" ${provinces[element.job?.provinceCode]}",
                                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                                            child: const Divider(
                                              thickness: 1,
                                              color: colorBlack,
                                            ),
                                          ),
                                          Flexible(
                                            child: (element.applyDate != null && element.applyDate != "")
                                                ? Text("Trúng tuyển ngày ${DateFormat('dd-MM-yyyy').format(DateTime.parse(element.applyDate!))}",
                                                    style: AppStyles.appTextStyle(color: colorBlack, overFlow: TextOverflow.ellipsis))
                                                : const Text(""),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            for (var element in listRecruitmentTuChoi)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 102, 97, 97).withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 20,
                                      offset: const Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: TextButton(
                                    onPressed: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        // ignore: prefer_const_literals_to_create_immutables
                                        boxShadow: [
                                          BoxShadow(color: colorBlack.withOpacity(0.1), spreadRadius: 1, blurRadius: 1, blurStyle: BlurStyle.solid),
                                        ],
                                        image: const DecorationImage(
                                          image: AssetImage("assets/images/image-background-card-5.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Row(
                                            // FadeInImage.assetNetwork(placeholder: placeholder, image: image),
                                            children: [
                                              const SizedBox(width: 10),
                                              Image.network(
                                                element.job?.employer.logo! ?? "",
                                                fit: BoxFit.fill,
                                                width: 50,
                                                height: 50,
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  element.job?.name ?? "",
                                                  style: AppStyles.appTextStyle(size: 20, color: colorBlack, weight: FontWeight.w600),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.cancel,
                                                size: 30,
                                                color: Colors.red,
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            element.job?.employer.name! ?? "",
                                            style: AppStyles.appTextStyle(color: colorBlack, size: 14),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const SizedBox(width: 15),
                                              Row(
                                                children: [
                                                  const Icon(Icons.paid, size: 25, color: maincolor),
                                                  Text(" ${element.job?.salary}",
                                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                                                ],
                                              ),
                                              const SizedBox(width: 15),
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on, size: 25, color: maincolor),
                                                  Text(" ${provinces[element.job?.provinceCode]}",
                                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                                            child: const Divider(
                                              thickness: 1,
                                              color: colorBlack,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text("Mong sẽ có cơ hội hợp tác trong tương lai",
                                                style: AppStyles.appTextStyle(color: colorBlack, overFlow: TextOverflow.ellipsis)),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                          ],
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

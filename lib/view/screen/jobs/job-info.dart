// ignore_for_file: must_be_immutable, unnecessary_string_interpolations, unused_element, use_build_context_synchronously

import 'dart:convert';

import 'package:an_toan_bao_mat_trong_ptpmdd/controllers/api.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider.dart';
import '../../../model/jobs.dart';
import '../../../model/recruitments.dart';
import '../../common/style.dart';
import '../home/home.dart';

class JobInfo extends StatefulWidget {
  Jobs job;
  String? province;
  JobInfo({super.key, required this.job, this.province});
  @override
  State<JobInfo> createState() => _JobInfoState();
}

class _JobInfoState extends State<JobInfo> {
  int selectedTap = 0;
  final formatCurrency = NumberFormat("#,##0", "en_US");
  @override
  void initState() {
    super.initState();
    selectedTap = 0;
  }

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

    return Consumer<User>(
      builder: (context, user, child) => Scaffold(
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
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.home, size: 25))
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/store-image-a4f19.appspot.com/o/image%2Fbackground%2Fbackground2.png?alt=media"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Image.network(
                        widget.job.employer.logo!,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 5),
                            height: 50,
                            child: Text(
                              widget.job.name,
                              style: AppStyles.appTextStyle(size: 25, weight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            widget.job.employer.name!,
                            style: AppStyles.appTextStyle(size: 15),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.73,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 20, right: 40),
                          child: TabBar(
                            indicatorWeight: 3,
                            isScrollable: true,
                            indicatorColor: Color(0xf7fbfc),
                            onTap: (value) {
                              setState(() {
                                selectedTap = value;
                              });
                            },
                            tabs: [
                              Container(
                                decoration: BoxDecoration(
                                  color: (selectedTap == 0) ? maincolor : colorWhite,
                                  border: Border.all(width: 1, color: maincolor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 150,
                                height: 40,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.info,
                                      color: (selectedTap == 1) ? maincolor : colorWhite,
                                    ),
                                    const SizedBox(width: 10),
                                    Text("Thông tin", style: AppStyles.medium()),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: (selectedTap == 1) ? maincolor : colorWhite,
                                  border: Border.all(width: 1, color: maincolor),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: 150,
                                height: 40,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.apartment,
                                      color: (selectedTap == 0) ? maincolor : colorWhite,
                                    ),
                                    const SizedBox(width: 10),
                                    Text("Công ty", style: AppStyles.medium()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.73,
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: ListView(
                                controller: ScrollController(),
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    "Thông tin chung:",
                                    style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.paid, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Mức lương:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                              "${(int.tryParse(widget.job.salary!) != null) ? formatCurrency.format(int.parse(widget.job.salary ?? "0")) : widget.job.salary!}",
                                              style: AppStyles.appTextStyle(size: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.person_add, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Số lượng:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(widget.job.qty!, style: AppStyles.appTextStyle(size: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.face_retouching_natural, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Độ tuổi:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(widget.job.age!, style: AppStyles.appTextStyle(size: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.language, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Trình độ tiếng anh:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(widget.job.englishLevel!, style: AppStyles.appTextStyle(size: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.workspace_premium, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Kinh nghiệm:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(widget.job.exp!, style: AppStyles.appTextStyle(size: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.location_on, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Địa chỉ:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(widget.job.addRess ?? "", style: AppStyles.appTextStyle(size: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Yêu cầu khác:",
                                    style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 40),
                                      Text(widget.job.otherRequirements ?? "", style: AppStyles.appTextStyle(size: 15)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                              height: MediaQuery.of(context).size.height * 0.73,
                              child: ListView(
                                controller: ScrollController(),
                                children: [
                                  Text(
                                    widget.job.employer.name ?? "",
                                    style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.location_on, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Địa chỉ:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.8,
                                              child: Text(
                                                widget.job.employer.addRess ?? "",
                                                style: AppStyles.appTextStyle(size: 15),
                                                maxLines: 3,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      const Icon(Icons.language, size: 20, color: maincolor),
                                      const SizedBox(width: 20),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Website:",
                                            style: AppStyles.appTextStyle(size: 18, weight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(widget.job.employer.career!, style: AppStyles.appTextStyle(size: 15)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Giới thiệu về công ty",
                                    style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const SizedBox(width: 40),
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          child: Text(widget.job.employer.introduce ?? "", style: AppStyles.appTextStyle(size: 15))),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Text(
                                    "Việc làm cùng công ty",
                                    style: AppStyles.appTextStyle(size: 22, weight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: 200,
                        decoration: BoxDecoration(
                          color: (user.listRecruitment.containsKey(widget.job.id)) ? const Color.fromARGB(255, 244, 146, 54) : maincolor,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: TextButton(
                          onPressed: (!user.listRecruitment.containsKey(widget.job.id))
                              ? () async {
                                  processing();
                                  var requestBody = {"user_id": user.user.id, "job_id": widget.job.id, "status": 0, "apply": 0};
                                  await httpPost("/api/recruitment/post", requestBody, context);
                                  var mapJobs = user.listRecruitment;
                                  int count = user.countJobs;
                                  mapJobs[widget.job.id!] = Recruitment();
                                  count += 1;
                                  user.changeListRecruitment(mapJobs);
                                  user.changeCountJobs(count);
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text(
                            // "${widget.job.id}==${user.listRecruitment.containsKey(widget.job.id)}",
                            (user.listRecruitment.containsKey(widget.job.id)) ? "Ứng tuyển lại" : "Ứng tuyển ngay",
                            style: AppStyles.appTextStyle(size: 20, color: colorWhite),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: 200,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), border: Border.all(width: 1, color: maincolor)),
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.message,
                                size: 25,
                                color: maincolor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Nhắn tin",
                                style: AppStyles.appTextStyle(size: 20, color: maincolor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

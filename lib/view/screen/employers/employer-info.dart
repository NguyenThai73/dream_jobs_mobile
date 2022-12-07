import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';

import '../../../model/employers.dart';
import '../../common/style.dart';
import '../../components/job-item-list.dart';
import '../home/home.dart';

class EmployerInfo extends StatefulWidget {
  Employer employer;
  Map<int, String>? provinces;
  EmployerInfo({super.key, required this.employer, this.provinces});
  @override
  State<EmployerInfo> createState() => _EmployerInfoState();
}

class _EmployerInfoState extends State<EmployerInfo> {
  int selectedTap = 0;
  @override
  void initState() {
    super.initState();
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
        title: Text(widget.employer.name!),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 200,
              decoration: BoxDecoration(
                color: maincolor.withOpacity(0.5),
                image: DecorationImage(
                  image: NetworkImage(widget.employer.avatar!),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              height: 680,
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
                        // indicatorPadding: EdgeInsets.only(bottom: 10),
                        indicatorColor: colorWhite,
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
                            width: 180,
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
                            width: 180,
                            height: 40,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.supervised_user_circle,
                                  color: (selectedTap == 0) ? maincolor : colorWhite,
                                ),
                                const SizedBox(width: 10),
                                Text("Tuyển dụng", style: AppStyles.medium()),
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
                          decoration: BoxDecoration(
                            color: maincolor.withOpacity(0.3),
                          ),
                          child: ListView(
                            controller: ScrollController(),
                            children: [
                              const SizedBox(height: 15),
                              Text("Quy mô: ${widget.employer.scale}",
                                  style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400)),
                              const SizedBox(height: 15),
                              Text("${widget.employer.introduce}",
                                  style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400)),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Text(
                                    "Liên hệ",
                                    style: AppStyles.appTextStyle(color: colorBlack, size: 20, weight: FontWeight.w500),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Icon(Icons.call, size: 25, color: colorBlack),
                                  Text("  ${widget.employer.sdt}",
                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Icon(Icons.mail, size: 25, color: colorBlack),
                                  Text("  ${widget.employer.email}",
                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Icon(Icons.web_asset, size: 25, color: colorBlack),
                                  Text("  ${widget.employer.career}",
                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 25, color: colorBlack),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Text(
                                      "${widget.employer.addRess}",
                                      style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            color: maincolor.withOpacity(0.3),
                          ),
                          child: ListView(
                            controller: ScrollController(),
                            children: [
                              for (var element in widget.employer.listJobs!)
                                JobItemList(
                                  job: element,
                                  imageBackground: "assets/images/image-background-card-5.jpg",
                                  province: widget.provinces![element.provinceCode],
                                )
                            ],
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

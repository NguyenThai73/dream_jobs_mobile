// ignore_for_file: must_be_immutable

import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import '../../model/jobs.dart';
import '../common/style.dart';
import '../screen/jobs/job-info.dart';

class JobItemList extends StatefulWidget {
  Jobs job;
  String? imageBackground;
  String? province;
  JobItemList({super.key, required this.job, this.imageBackground, this.province});
  @override
  State<JobItemList> createState() => _JobItemListState();
}

class _JobItemListState extends State<JobItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          onPressed: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => JobInfo(
                  job: widget.job,
                  province: widget.province,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                BoxShadow(color: colorBlack.withOpacity(0.1), spreadRadius: 1, blurRadius: 1, blurStyle: BlurStyle.solid),
              ],
              image: DecorationImage(
                image: AssetImage("${widget.imageBackground}"),
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
                      widget.job.employer.logo!,
                      fit: BoxFit.fill,
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        widget.job.name,
                        style: AppStyles.appTextStyle(size: 20, color: colorBlack, weight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.job.employer.name!,
                  style: AppStyles.appTextStyle(color: colorBlack, size: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        const Icon(Icons.paid, size: 25, color: maincolor),
                        Text(" ${widget.job.salary}", style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
                      ],
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 25, color: maincolor),
                        Text(" ${widget.province}", style: AppStyles.appTextStyle(color: colorBlack, size: 15, weight: FontWeight.w400))
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
                  child: (widget.job.expirationDate != null && widget.job.expirationDate != "")
                      ? Text("Còn ${DateTime.parse(widget.job.expirationDate!).difference(DateTime.now()).inDays} ngày để ứng tuyển",
                          style: AppStyles.appTextStyle(color: colorBlack, overFlow: TextOverflow.ellipsis))
                      : const Text(""),
                ),
              ],
            ),
          )),
    );
  }
}

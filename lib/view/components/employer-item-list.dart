// ignore_for_file: must_be_immutable

import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import '../../model/employers.dart';
import '../common/style.dart';
import '../screen/employers/employer-info.dart';

class EmployerItemList extends StatefulWidget {
  Employer employer;
  Map<int, String>? provinces;
  EmployerItemList({super.key, required this.employer, this.provinces});
  @override
  State<EmployerItemList> createState() => _EmployerItemListState();
}

class _EmployerItemListState extends State<EmployerItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
      // color: maincolor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5)),
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
              builder: (BuildContext context) => EmployerInfo(
                employer: widget.employer,
                provinces: widget.provinces,
              ),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
                  ),
                  child: Image.network(
                    widget.employer.logo!,
                    fit: BoxFit.fill,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    widget.employer.name!,
                    style: AppStyles.appTextStyle(
                      size: 18,
                      color: colorBlack,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      widget.employer.introduce!,
                      style: AppStyles.appTextStyle(size: 14, color: colorBlack, weight: FontWeight.w400, overFlow: TextOverflow.ellipsis),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(widget.employer.sdt!),
                  const SizedBox(height: 15),
                  Text(widget.employer.email!),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

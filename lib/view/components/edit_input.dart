// ignore_for_file: must_be_immutable

import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';

class EditInput extends StatefulWidget {
  Widget widget;
  double? height;
  EditInput({Key? key, required this.widget, this.height}) : super(key: key);
  @override
  State<EditInput> createState() => EditInputState();
}

class EditInputState extends State<EditInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      height: widget.height ?? 50,
      decoration: BoxDecoration(
        // border: Border.all(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.circular(15),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          const BoxShadow(
            color: maincolor,
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: widget.widget,
    );
  }
}

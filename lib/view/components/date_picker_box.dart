// ignore_for_file: prefer_const_constructors

import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/style.dart';

class DatePickerBox extends StatefulWidget {
  final Widget? label;
  final List<Widget>? widgetBox;
  final int? flexLabel;
  final int? flexDatePiker;
  final dynamic marginWidget;
  final dynamic heightWidget;
  final dynamic borderWidget;
  final Function? callbackValue;
  final String? realTime;
  final Widget? option;

  DatePickerBox(
      {Key? key,
      this.label,
      this.widgetBox,
      this.marginWidget,
      this.heightWidget,
      this.borderWidget,
      this.flexLabel,
      this.callbackValue,
      this.flexDatePiker,
      this.realTime,
      this.option})
      : super(key: key);
  @override
  State<DatePickerBox> createState() => _DatePickerBoxState();
}

class _DatePickerBoxState extends State<DatePickerBox> {
  DateTime selectedDate = DateTime.now();
  String? realTime;
  // String formattedDate = DateFormat("dd-MM-yyyy").format(now);
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.day,
      // locale: Locale("es"),
      // fieldLabelText: 'Booking date',
      // fieldHintText: 'Month/Date/Year',
    );
    if (picked != null && picked != selectedDate)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectedDate = picked;
        realTime = DateFormat("dd-MM-yyyy").format(selectedDate.toLocal());
        widget.callbackValue!(realTime);
      });
  }

  @override
  void initState() {
    setState(() {
      if (widget.realTime != null) {
        realTime = widget.realTime;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.label != null)
          Expanded(
            flex: widget.flexLabel ?? 2,
            child: Row(
              children: [
                Flexible(
                  child: widget.label!,
                ),
              ],
            ),
          ),
        Expanded(
          flex: widget.flexDatePiker ?? 5,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: widget.heightWidget,
            // padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              border: widget.borderWidget,
              // border: Border.all(width: 0.5, style: BorderStyle.solid),
              boxShadow: [
                BoxShadow(
                  color: maincolor.withOpacity(0),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(realTime != null ? "$realTime" : 'Chọn ngày', style: AppStyles.appTextStyle()),
                const SizedBox(height: 20.0),
                realTime == null
                    ? IconButton(onPressed: () => _selectDate(context), icon: Icon(Icons.date_range), color: colorBlack)
                    : IconButton(
                        onPressed: () {
                          realTime = null;
                          widget.callbackValue!(realTime);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.close,
                          color: colorBlack,
                        )),
                // IconButton(onPressed: () => _selectDate(context), icon: Icon(Icons.date_range), color: Colors.blue[400]),
              ],
              //     [
              //   Text((widget.realTime != null) ? DateFormat("dd-MM-yyyy").format(selectedDate.toLocal()) : 'Chọn ngày',
              //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              //   SizedBox(height: 20.0),
              //   IconButton(onPressed: () => _selectDate(context), icon: Icon(Icons.date_range), color: Colors.blue[400]),
              // ],
            ),
          ),
        ),
      ],
    );
  }
}

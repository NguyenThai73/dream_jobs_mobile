// ignore_for_file: sort_child_properties_last

import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastWidget extends StatelessWidget {
  final Color color;
  Icon? icon;
  final String msg;
  ToastWidget({Key? key, required this.msg, required this.color, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color.fromRGBO(255, 129, 130, 0.4)),
        color: color,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const Text(""),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            msg,
            style: TextStyle(color:colorBlack),
          ),
        ],
      ),
    );
  }
}

void onLoading(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator()),
          Container(
            child: const Center(
                child: Text(
              "Processing",
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
            margin: const EdgeInsets.only(top: 10),
          )
        ],
      );
    },
  );
}

void showToast({
  required BuildContext context,
  required String msg,
  required Color color,
  Icon? icon,
  int? timeHint,
  double? top,
  double? bottom,
  double? right,
  double? left,
}) {
  FToast fToast = FToast();
  fToast.init(context);
  return fToast.showToast(
      //Đang m ắc
      child: ToastWidget(msg: msg, color: color, icon: icon),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: timeHint ?? 3),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          top: top,
          bottom:  bottom,
          right: right,
          left:  left,
        );
      });
}

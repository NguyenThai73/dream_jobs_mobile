import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:flutter/material.dart';

import '../common/style.dart';

class AppTextFields extends StatefulWidget {
  AppTextFields({
    super.key,
    this.controller,
    this.keyboardType,
    this.obscure = false,
    this.validator,
    required this.hint,
    this.fillColor,
    this.filled,
    this.suffixIcon,
    this.onChanged,
    this.readOnly = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.enabled,
  });
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final String? Function(String?)? validator;
  final String hint;
  final Color? fillColor;
  final Function(String)? onChanged;
  final bool? filled;
  final int maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  bool? enabled;
  @override
  State<AppTextFields> createState() => _AppTextFieldsState();
}

class _AppTextFieldsState extends State<AppTextFields> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      style: AppStyles.appTextStyle(),
      obscureText: widget.obscure,
      readOnly: widget.readOnly,
      validator: widget.validator,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      cursorColor: maincolor,
      enabled: widget.enabled ?? true,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppStyles.appTextStyle(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        filled: widget.filled,
        fillColor: widget.fillColor,
        border: underlineInputBorder(color: maincolor), //grey
        errorBorder: underlineInputBorder(color: Colors.red), //red
        focusedBorder: underlineInputBorder(color: maincolor), //primary
      ),
    );
  }
}

UnderlineInputBorder underlineInputBorder({Color color = maincolor}) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color: color,
      width: 1,
    ),
  );
}

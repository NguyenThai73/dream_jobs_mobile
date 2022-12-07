import 'package:flutter/material.dart';

class SignScreenBody extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController controller;
  final TextEditingController passWordController;
  TextEditingController? passWordControllerR;

  SignScreenBody({
    Key? key,
    required this.name,
    required this.controller,
    required this.passWordController,
    this.passWordControllerR,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LoginTextField(
          controller: name,
          type: TextInputType.emailAddress,
          hint: "Tên đầy đủ",
        ),
        LoginTextField(
          controller: controller,
          type: TextInputType.emailAddress,
          hint: "Email",
        ),
        LoginTextField(
          controller: passWordController,
          type: TextInputType.visiblePassword,
          hint: "Mật khẩu",
        ),
        LoginTextField(
          controller: passWordControllerR!,
          type: TextInputType.visiblePassword,
          hint: "Nhập lại mật khẩu",
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String hint;

  const LoginTextField({Key? key, required this.controller, required this.type, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      height: 50.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        decoration: InputDecoration.collapsed(hintText: hint),
        keyboardType: type,
        obscureText: type == TextInputType.visiblePassword ? true : false,
        controller: controller,
      ),
    );
  }
}

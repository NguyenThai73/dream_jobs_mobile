// Future<List<Depart>> getPhongBan() async {
//   List<Depart> resultPhongBan = [];
//   var response1 = await httpGet("/api/phongban/get/page?sort=id,asc&filter=parentId:0 and id>2 and status:1", context);
// if (response1.containsKey("body")) {
//   var body = jsonDecode(response1['body']);
//   var content = [];
//   setState(() {
//     content = body['content'];
//     resultPhongBan = content.map((e) {
//       return Depart.fromJson(e);
//     }).toList();
//     Depart all = new Depart(id: -1, departName: "Tất cả");
//     resultPhongBan.insert(0, all);
//   });
// }
//   return resultPhongBan;
// }

import 'package:intl/intl.dart';

class UserLogin {
  int? id;
  String? accessToken;
  String? email;
  String? fullname;
  String? birthday;
  String? sdt;
  int? gender;
  String? idCardNo;
  String? addRess;
  String? cv;
  String? avatar;
  String? career;
  int? status;
  int? height;

  UserLogin({
    this.id,
    this.accessToken,
    this.email,
    this.fullname,
    this.birthday,
    this.sdt,
    this.gender,
    this.idCardNo,
    this.addRess,
    this.cv,
    this.avatar,
    this.career,
    this.status,
    this.height,
  });

  factory UserLogin.fromJson(Map<dynamic, dynamic> json) {
    return UserLogin(
      id: json['infor']['id'],
      accessToken: json['accessToken'],
      email: json['infor']['email'],
      fullname: json['infor']['fullname'],
      birthday: (json['infor']['birthday'] != null && json['infor']['birthday'] != "")
          ? DateFormat('dd-MM-yyyy').format(DateTime.parse(json['infor']['birthday']).toLocal())
          : null,
      sdt: json['infor']['sdt'],
      gender: json['infor']['gender'],
      idCardNo: json['infor']['idCardNo'],
      addRess: json['infor']['addRess'],
      cv: json['infor']['cv'],
      avatar: json['infor']['avatar'],
      career: json['infor']['career'],
      status: json['infor']['status'],
      height: json['infor']['height'],
    );
  }
  Map<String, dynamic> toMap(birthdayFormat) {
    return {
      "fullname": fullname,
      "birthday": (birthdayFormat != "") ? birthdayFormat : null,
      "sdt": sdt,
      "gender": gender,
      "idCardNo": idCardNo,
      "addRess": addRess,
      "cv": cv,
      "avatar": avatar,
      "career": career,
      "height": height
    };
  }
}

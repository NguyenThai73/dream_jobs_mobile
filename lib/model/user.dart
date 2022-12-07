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
  String? hobby;
  String? personality;
  String? educational;
  String? career;
  String? wish;
  String? salary;
  String? exp;
  String? recruitments;
  String? jobNow;
  String? currentWorkingAddress;
  String? currentEmploymentCompany;
  int? status;
  int? height;
  int? weight;

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
    this.hobby,
    this.personality,
    this.educational,
    this.career,
    this.wish,
    this.salary,
    this.exp,
    this.recruitments,
    this.jobNow,
    this.currentWorkingAddress,
    this.currentEmploymentCompany,
    this.status,
    this.height,
    this.weight,
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
      hobby: json['infor']['hobby'],
      personality: json['infor']['personality'],
      educational: json['infor']['educational'],
      career: json['infor']['career'],
      wish: json['infor']['wish'],
      salary: json['infor']['salary'],
      exp: json['infor']['exp'],
      recruitments: json['infor']['recruitments'],
      jobNow: json['infor']['jobNow'],
      currentWorkingAddress: json['infor']['currentWorkingAddress'],
      currentEmploymentCompany: json['infor']['currentEmploymentCompany'],
      status: json['infor']['status'],
      height: json['infor']['height'],
      weight: json['infor']['weight'],
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

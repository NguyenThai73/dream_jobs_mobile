import 'dart:convert';

import 'package:an_toan_bao_mat_trong_ptpmdd/controllers/api.dart';

import 'jobs.dart';

class Employer {
  int? id;
  String? name;
  String? avatar;
  String? logo;
  String? addRess;
  String? sdt;
  String? email;
  String? career;
  String? scale;
  String? introduce;
  int? status;
  List<Jobs>? listJobs;
  Employer(
      {this.id,
      this.name,
      this.status,
      this.avatar,
      this.logo,
      this.addRess,
      this.career,
      this.sdt,
      this.email,
      this.introduce,
      this.scale,
      this.listJobs});
  factory Employer.fromJson(Map<dynamic, dynamic> json) {
    return Employer(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      logo: json['logo'],
      addRess: json['addRess'],
      status: json['status'],
      career: json['career'],
      sdt: json['sdt'],
      email: json['email'],
      introduce: json['introduce'],
      scale: json['scale'],
    );
  }
}

Future<List<Employer>> getListEmployer(context) async {
  List<Employer> listEmployer = [];
  var response = await httpGet("/api/employer/get", context);
  if (response.containsKey("body")) {
    var body = jsonDecode(response['body']);
    for (var element in body) {
      Employer item = Employer(
        id: element['id'],
        name: element['name'],
        avatar: element['avatar'],
        logo: element['logo'],
        addRess: element['addRess'],
        status: element['status'],
        career: element['career'],
        sdt: element['sdt'],
        email: element['email'],
        introduce: element['introduce'],
        scale: element['scale'],
      );
      listEmployer.add(item);
    }
    listEmployer.insert(0, Employer(id: 0, name: ""));
  }
  return listEmployer;
}

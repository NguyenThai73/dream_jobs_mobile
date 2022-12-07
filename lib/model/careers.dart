import 'dart:convert';

import 'package:an_toan_bao_mat_trong_ptpmdd/controllers/api.dart';

class Careers {
  int? id;
  String? name;
  int? parentId;
  Careers({this.id, this.name, this.parentId});
  factory Careers.fromJson(Map<dynamic, dynamic> json) {
    return Careers(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
    );
  }
}

Future<List<Careers>> getListCareers(context) async {
  List<Careers> listCareers = [];
  var response = await httpGet("/api/career/get", context);
  if (response.containsKey("body")) {
    var body = jsonDecode(response['body']);
    for (var element in body) {
      Careers item = Careers(
        id: element['id'],
        name: element['name'],
        parentId: element['parentId'],
      );
      listCareers.add(item);
    }
  }
  return listCareers;
}

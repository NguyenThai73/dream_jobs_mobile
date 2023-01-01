import 'careers.dart';
import 'employers.dart';
import 'jobs.dart';

class Recruitment {
  int? id;
  int? userId;
  int? jobId;
  Jobs? job;
  int? status;
  int? apply;
  String? applyNote;
  String? applyDate;
  String? des;
  Recruitment({
    this.id,
    this.userId,
    this.jobId,
    this.job,
    this.status,
    this.apply,
    this.applyNote,
    this.applyDate,
    this.des,
  });
  factory Recruitment.fromJson(Map<dynamic, dynamic> json) {
    return Recruitment(
      id: json['id'],
      userId: json['user_id'],
      jobId: json['jobs']['id'],
      job: Jobs(
        id: json['jobs']['id'],
        employer: Employer(id: json['jobs']['employer_id']),
        careers: Careers(id: json['jobs']['career_id']),
        qty: json['jobs']['qty'] ?? "",
        name: json['jobs']['name'] ?? "",
        salary: json['jobs']['salary'] ?? "",
        age: json['jobs']['age'] ?? "",
        englishLevel: json['jobs']['englishLevel'] ?? "",
        expirationDate: json['jobs']['expirationDatety'] ?? "",
        otherRequirements: json['jobs']['otherRequirements'] ?? "",
        addRess: json['jobs']['addRess'] ?? "",
        provinceCode: json['jobs']['provinceCode'],
        status: json['jobs']['status'],
        exp: json['jobs']['exp'] ?? "",
      ),
      status: json['status'],
      apply: json['apply'],
      applyNote: json['applyNote'],
      applyDate: json['applyDate'],
    );
  }
}

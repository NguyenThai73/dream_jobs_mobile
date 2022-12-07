import 'careers.dart';
import 'employers.dart';

class Jobs {
  int? id;
  Employer employer;
  Careers careers;
  String name;
  String? qty;
  String? salary;
  String? age;
  String? englishLevel;
  String? exp;
  String? expirationDate;
  String? otherRequirements;
  String? addRess;
  int? provinceCode;
  int? status;
  Jobs({
    this.id,
    required this.employer,
    required this.careers,
    required this.name,
    this.qty,
    this.salary,
    this.age,
    this.englishLevel,
    this.expirationDate,
    this.otherRequirements,
    this.provinceCode,
    this.status,
    this.exp,
    this.addRess,
  });
  factory Jobs.fromJson(Map<dynamic, dynamic> json) {
    return Jobs(
      id: json['id'],
      employer: Employer.fromJson(json['employerName']),
      careers: Careers.fromJson(json['careerName']),
      qty: json['qty'] ?? "",
      name: json['name'] ?? "",
      salary: json['salary'] ?? "",
      age: json['age'] ?? "",
      englishLevel: json['englishLevel'] ?? "",
      expirationDate: json['expirationDatety'] ?? "",
      otherRequirements: json['otherRequirements'] ?? "",
      addRess: json['addRess'] ?? "",
      provinceCode: json['provinceCode'],
      status: json['status'],
      exp: json['exp'] ?? "",
    );
  }
}

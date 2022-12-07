import 'package:an_toan_bao_mat_trong_ptpmdd/model/user.dart';
import 'package:flutter/cupertino.dart';

import '../model/recruitments.dart';

class User with ChangeNotifier {
  String authorization = "";
  changeAuthorization(String authorizationNew) {
    authorization = authorizationNew;
    notifyListeners();
  }

  UserLogin user = UserLogin();
  changeUser(UserLogin newUser) {
    user = newUser;
    notifyListeners();
  }

  Map<int, Recruitment> listRecruitment = {};
  changeListRecruitment(Map<int, Recruitment> listRecruitmentNew) {
    listRecruitment = listRecruitmentNew;
    notifyListeners();
  }

  int countJobs = 0;
  changeCountJobs(int newCount) {
    countJobs = newCount;
    notifyListeners();
  }
}

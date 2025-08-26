import 'package:flutter/material.dart';

class VaccineScheduleProvider extends ChangeNotifier {
  List<Map<String, dynamic>> vacSchedule = [];

  // Add your vaccine schedule logic here
  void updateVaccineSchedule(List<Map<String, dynamic>> schedule) {
    vacSchedule = schedule;
    notifyListeners();
  }
}

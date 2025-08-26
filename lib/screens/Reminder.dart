import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> upcomingVaccines = [];
  final userId = FirebaseAuth.instance.currentUser?.uid;
  DateTime? childDob;

  @override
  void initState() {
    super.initState();
    if (userId != null) {
      fetchChildData();
    } else {
      showAlert('Error', 'User is not logged in.');
    }
  }

  Future<void> fetchChildData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('children')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        setState(() {
          childDob = (data['dob'] as Timestamp).toDate();
          isLoading = false;
        });

        fetchUpcomingVaccines();
      } else {
        setState(() {
          isLoading = false;
        });
        showAlert('No Records', 'No child records found for this user.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showAlert('Error', 'Error fetching child data: $e');
    }
  }

  void fetchUpcomingVaccines() {
    if (childDob != null) {
      final today = DateTime.now();
      final vaccines = getVaccineSchedule(childDob!);

      List<Map<String, dynamic>> upcoming = [];
      for (var vaccine in vaccines) {
        final vaccineDate = vaccine['dueDate'];
        if (vaccineDate.isAfter(today) && vaccineDate.isBefore(today.add(Duration(days: 50)))) {
          final daysRemaining = vaccineDate.difference(today).inDays;
          vaccine['daysRemaining'] = daysRemaining;
          upcoming.add(vaccine);
        }
      }

      setState(() {
        upcomingVaccines = upcoming;
      });
    }
  }

  List<Map<String, dynamic>> getVaccineSchedule(DateTime dob) {
    // Define the vaccine schedule based on the child's DOB
    return [
       {
        'name': 'OPV-Zero',
        'dueDate': dob.add(Duration(days: 0)), // Due at birth
      },
      {
        'name': 'BCG',
        'dueDate': dob.add(Duration(days: 0)), // Due at birth
      },
      {
        'name': 'Hep B (Birth dose)',
        'dueDate': dob.add(Duration(days: 0)), // Due at birth
      },
      {
        'name': 'OPV-1',
        'dueDate': dob.add(Duration(days: 42)), // Due at 6 weeks
      },
      {
        'name': 'RVV-1',
        'dueDate': dob.add(Duration(days: 42)), // Due at 6 weeks
      },
      {
        'name': 'fIPV-1',
        'dueDate': dob.add(Duration(days: 42)), // Due at 6 weeks
      },
      {
        'name': 'Pentavalent-1',
        'dueDate': dob.add(Duration(days: 42)), // Due at 6 weeks
      },
      {
        'name': 'PCV-1',
        'dueDate': dob.add(Duration(days: 42)), // Due at 6 weeks
      },
      {
        'name': 'OPV-2',
        'dueDate': dob.add(Duration(days: 70)), // Due at 10 weeks
      },
      {
        'name': 'RVV-2',
        'dueDate': dob.add(Duration(days: 70)), // Due at 10 weeks
      },
      {
        'name': 'Pentavalent-2',
        'dueDate': dob.add(Duration(days: 70)), // Due at 10 weeks
      },
      {
        'name': 'PCV-2',
        'dueDate': dob.add(Duration(days: 70)), // Due at 10 weeks
      },
      {
        'name': 'OPV-3',
        'dueDate': dob.add(Duration(days: 98)), // Due at 14 weeks
      },
      {
        'name': 'RVV-3',
        'dueDate': dob.add(Duration(days: 98)), // Due at 14 weeks
      },
      {
        'name': 'fIPV-2',
        'dueDate': dob.add(Duration(days: 98)), // Due at 14 weeks
      },
      {
        'name': 'Pentavalent-3',
        'dueDate': dob.add(Duration(days: 98)), // Due at 14 weeks
      },
      {
        'name': 'PCV-3',
        'dueDate': dob.add(Duration(days: 98)), // Due at 14 weeks
      },
      {
        'name': 'MR-1',
        'dueDate': dob.add(Duration(days: 365)), // Due at 9-12 months
      },
      {
        'name': 'fIPV-3',
        'dueDate': dob.add(Duration(days: 365)), // Due at 9-12 months
      },
      {
        'name': 'PCV-Booster',
        'dueDate': dob.add(Duration(days: 365)), // Due at 9-12 months
      },
      {
        'name': 'JE-1',
        'dueDate': dob.add(Duration(days: 365)), // Due at 9-12 months
      },
      {
        'name': 'OPV-Booster',
        'dueDate': dob.add(Duration(days: 730)), // Due at 16-24 months
      },
      {
        'name': 'MR-2',
        'dueDate': dob.add(Duration(days: 730)), // Due at 16-24 months
      },
      {
        'name': 'DPT-Booster-1',
        'dueDate': dob.add(Duration(days: 730)), // Due at 16-24 months
      },
      {
        'name': 'JE-2',
        'dueDate': dob.add(Duration(days: 730)), // Due at 16-24 months
      },
      {
        'name': 'DPT-Booster-2',
        'dueDate': dob.add(Duration(days: 1825)), // Due at 5-6 years
      },
      {
        'name': 'Td',
        'dueDate': dob.add(Duration(days: 3650)), // Due at 10 years
      },
      {
        'name': 'Td',
        'dueDate': dob.add(Duration(days: 5840)), // Due at 16 years
      },
    ];
  }
   String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(date);
  }

  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Vaccines'),
        backgroundColor: Color(0xFF00CCCC),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : upcomingVaccines.isEmpty
              ? Center(child: Text('No upcoming vaccines within the next 50 days.'))
              : ListView.builder(
                  itemCount: upcomingVaccines.length,
                  itemBuilder: (context, index) {
                    final vaccine = upcomingVaccines[index];
                    return ListTile(
                      title: Text(vaccine['name']),
                      subtitle: Text('Due on: ${formatDate(vaccine['dueDate'])} (in ${vaccine['daysRemaining']} days)'),
                    );
                  },
                ),
    );
  }
}


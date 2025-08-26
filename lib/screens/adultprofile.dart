import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdultProfile extends StatefulWidget {
  @override
  _AdultProfileState createState() => _AdultProfileState();
}

class _AdultProfileState extends State<AdultProfile> {
  Map<String, dynamic>? adultData;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchAdultData();
  }

  Future<void> fetchAdultData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('adults')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          adultData = querySnapshot.docs.first.data();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Records'),
            content: Text('No adult records found for this user.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Error fetching adult data: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7F9),
      appBar: AppBar(
        title: Text('Adult\'s Profile'),
        backgroundColor: Color(0xFF00CCCC),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'Adult\'s Profile',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    adultData?['fullName'] ?? 'Nil',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/addAdult');
                    },
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Color(0xFF0099CC),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                'assets/addadult.png',
                fit: BoxFit.cover,
                width: 120,
                height: 150,
              ),
                ],
              ),
            ),
            // Information Section
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  infoRow('Full Name', adultData?['fullName'] ?? 'Nil'),
                  infoRow('Date of Birth', adultData?['dob'] ?? 'Nil'),
                  infoRow('Blood Group', adultData?['bloodGroup'] ?? 'Nil'),
                  infoRow('Gender', adultData?['gender'] ?? 'Nil'),
                  infoRow('Medical Condition', adultData?['primaryDiagnosis'] ?? 'Nil'),
                  infoRow('Address', adultData?['homeAddress'] ?? 'Nil'),
                ],
              ),
            ),
            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionButton(Icons.medical_services_outlined, 'Medical History', '/medicalHistory'),
                  actionButton(Icons.assignment_outlined, 'Care Plan', '/carePlan'),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF00CCCC),
        child: Icon(Icons.add),
      ),
      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFB2EDEE),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home_outlined, 'Home', '/homeScreen'),
            navItem(Icons.alarm_outlined, 'Reminder', '/reminder'),
            navItem(Icons.person_outline, 'Profile', '/adultProfileScreen'),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }

  Widget actionButton(IconData icon, String text, String route) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00CCCC),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget navItem(IconData icon, String text, String route) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon, size: 24, color: Colors.black),
    );
  }
}

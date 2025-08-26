import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SeniorProfile extends StatefulWidget {
  @override
  _SeniorProfileState createState() => _SeniorProfileState();
}

class _SeniorProfileState extends State<SeniorProfile> {
  Map<String, dynamic>? seniorData;

  @override
  void initState() {
    super.initState();
    fetchSeniorData();
  }

  Future<void> fetchSeniorData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Fluttertoast.showToast(msg: 'User not logged in.');
        return;
      }
      
      final querySnapshot = await FirebaseFirestore.instance
          .collection('senior')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          seniorData = querySnapshot.docs.first.data();
        });
      } else {
        Fluttertoast.showToast(msg: 'No senior records found.');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error fetching senior data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7F9),
      appBar: AppBar(
        backgroundColor: Color(0xFF0099CC),
        title: Text("Senior's Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    seniorData != null ? seniorData!['fullName'] ?? 'Nil' : 'Nil',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/addsenior'),
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                   Image.asset(
                'assets/seniorprofile.png',
                fit: BoxFit.cover,
                width: 120,
                height: 150,
              ),
                ],
              ),
            ),

            // Information Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  infoRow('Full Name', seniorData?['fullName'] ?? 'Nil'),
                  infoRow('Date of Birth', seniorData?['dob'] ?? 'Nil'),
                  infoRow('Blood Group', seniorData?['bloodGroup'] ?? 'Nil'),
                  infoRow('Gender', seniorData?['gender'] ?? 'Nil'),
                  infoRow("Phone Number", seniorData?['PhoneNumber']?.toString() ??'Nil'),
                  infoRow('Medical Condition', seniorData?['primaryDiagnosis'] ?? 'Nil'),
                  infoRow('Address', seniorData?['homeAddress'] ?? 'Nil'),
                ],
              ),
            ),

            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionButton(context, 'Medical History', Icons.medical_services),
                  actionButton(context, 'Care Plan', Icons.assignment),
                ],
              ),
            ),

            // Floating Add Button
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Color(0xFF00CCCC),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_outlined),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Add navigation logic
        },
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget actionButton(BuildContext context, String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
         Navigator.pushNamed(context, '/med'); 
      }, // Add navigation logic
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00CCCC),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAdultScreen extends StatefulWidget {
  @override
  _AddAdultScreenState createState() => _AddAdultScreenState();
}

class _AddAdultScreenState extends State<AddAdultScreen> {
  // Form state
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _primaryDiagnosisController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();

  bool imageError = false; // Track image load error

  // Form submission logic
  Future<void> handleAddAdult() async {
    String fullName = _fullNameController.text;
    String dob = _dobController.text;
    String gender = _genderController.text;
    String bloodGroup = _bloodGroupController.text;
    String primaryDiagnosis = _primaryDiagnosisController.text;
    String homeAddress = _homeAddressController.text;

    if (fullName.isEmpty ||
        dob.isEmpty ||
        gender.isEmpty ||
        bloodGroup.isEmpty ||
        primaryDiagnosis.isEmpty ||
        homeAddress.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill all fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('adults').add({
        'fullName': fullName,
        'dob': dob,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'primaryDiagnosis': primaryDiagnosis,
        'homeAddress': homeAddress,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': Timestamp.now(),
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Adult record added successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Error adding adult record: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Adult Record'),
        backgroundColor: Color(0xFF8E9BEF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add Adult Record',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF343A40),
              ),
            ),
            SizedBox(height: 20),

            // Profile Image with error handling
             Image.asset(
                'assets/addadult.png',
                fit: BoxFit.cover,
                width: 120,
                height: 150,
              ),
            SizedBox(height: 20),

            // Form inputs
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth (DD/MM/YYYY)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _bloodGroupController,
              decoration: InputDecoration(
                labelText: 'Blood Group',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _primaryDiagnosisController,
              decoration: InputDecoration(
                labelText: 'Primary Diagnosis',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _homeAddressController,
              decoration: InputDecoration(
                labelText: 'Home Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            // Submit button
            ElevatedButton(
              onPressed: handleAddAdult,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8E9BEF),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add Adult',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

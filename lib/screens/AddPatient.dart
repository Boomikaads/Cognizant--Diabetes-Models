import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _primaryDiagnosisController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Submit patient record
  Future<void> handleAddPatient() async {
    String name = _nameController.text.trim();
    String dob = _dobController.text.trim();
    String gender = _genderController.text.trim();
    String bloodGroup = _bloodGroupController.text.trim();
    String primaryDiagnosis = _primaryDiagnosisController.text.trim();
    String homeAddress = _homeAddressController.text.trim();
    String phone = _phoneController.text.trim();
    String height = _heightController.text.trim();
    String weight = _weightController.text.trim();

    if (name.isEmpty ||
        dob.isEmpty ||
        gender.isEmpty ||
        bloodGroup.isEmpty ||
        primaryDiagnosis.isEmpty ||
        homeAddress.isEmpty ||
        phone.isEmpty ||
        height.isEmpty ||
        weight.isEmpty) {
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
      await FirebaseFirestore.instance.collection('patients').add({
        'name': name,
        'dob': dob,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'primaryDiagnosis': primaryDiagnosis,
        'homeAddress': homeAddress,
        'phone': phone,
        'height': height,
        'weight': weight,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': Timestamp.now(),
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Patient record added successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back after success
              },
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
          content: Text('Error adding patient record: ${e.toString()}'),
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
        title: Text('Add Patient Record'),
        backgroundColor: Color(0xFF8E9BEF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add Patient Record',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF343A40),
              ),
            ),
            SizedBox(height: 20),

            // Profile Icon
            Image.asset(
              'assets/addadult.png',
              fit: BoxFit.cover,
              width: 120,
              height: 150,
            ),
            SizedBox(height: 20),

            // Form inputs
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _dobController,
              decoration: InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)', border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _bloodGroupController,
              decoration: InputDecoration(labelText: 'Blood Group', border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _primaryDiagnosisController,
              decoration: InputDecoration(labelText: 'Primary Diagnosis', border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _homeAddressController,
              decoration: InputDecoration(labelText: 'Home Address', border: OutlineInputBorder()),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Submit button
            ElevatedButton(
              onPressed: handleAddPatient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8E9BEF),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Add Patient',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

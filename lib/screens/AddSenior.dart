import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSeniorScreen extends StatefulWidget {
  @override
  _AddSeniorScreenState createState() => _AddSeniorScreenState();
}

class _AddSeniorScreenState extends State<AddSeniorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String fullName = '';
  String dob = '';
  String gender = '';
  String bloodGroup = '';
  String primaryDiagnosis = '';
  String homeAddress = '';
  String PhoneNumber='';

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle form submission
  void handleAddSenior() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('senior').add({
          'fullName': fullName,
          'dob': dob,
          'gender': gender,
          'bloodGroup': bloodGroup,
          'Phone number': PhoneNumber,
          'primaryDiagnosis': primaryDiagnosis,
          'homeAddress': homeAddress,
          'userId': _auth.currentUser!.uid,
          'createdAt': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Senior record added successfully!')),
        );

        Navigator.pop(context); // Navigate back after successful submission
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding senior record: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Senior Record'),
        backgroundColor: Color(0xFF8E9BEF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Add Senior Record',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF343A40),
                  ),
                ),
                SizedBox(height: 20),
                 Image.asset(
                'assets/seniorprofile.png',
                fit: BoxFit.cover,
                width: 120,
                height: 150,
              ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => fullName = value,
                  validator: (value) =>
                      value!.isEmpty ? 'This field is required' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth (DD/MM/YYYY)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => dob = value,
                  validator: (value) =>
                      value!.isEmpty ? 'This field is required' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => gender = value,
                  validator: (value) =>
                      value!.isEmpty ? 'This field is required' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Blood Group',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => bloodGroup = value,
                  validator: (value) =>
                      value!.isEmpty ? 'This field is required' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => PhoneNumber = value,
                  validator: (value) =>
                      value!.isEmpty ? 'This field is required' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Primary Diagnosis',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => primaryDiagnosis = value,
                  validator: (value) =>
                      value!.isEmpty ? 'This field is required' : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Home Address',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => homeAddress = value,
                  validator: (value) =>
                      value!.isEmpty ? 'This field is required' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleAddSenior,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8E9BEF),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  child: Text(
                    'Add Senior',
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
        ),
      ),
    );
  }
}

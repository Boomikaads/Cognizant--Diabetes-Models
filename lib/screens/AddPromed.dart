import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProScreen extends StatefulWidget {
  @override
  _AddProScreenState createState() => _AddProScreenState();
}

class _AddProScreenState extends State<AddProScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String fullName = '';
  String dob = '';
  String gender = '';
  String phone = '';
  String email = '';
  String address = '';
  String city = '';
  String state = '';
  String zip = '';
  String country = '';
  String title = '';
  String specialization = '';
  String licenseNumber = '';
  String licenseExpiry = '';
  String degree = '';
  String skills = '';
  String languages = '';
  String availability = '';
  String workingHours = '';

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> handleAddPro() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('promed').add({
          'fullName': fullName,
          'dob': dob,
          'gender': gender,
          'phone': phone,
          'email': email,
          'address': address,
          'city': city,
          'state': state,
          'zip': zip,
          'country': country,
          'title': title,
          'specialization': specialization,
          'licenseNumber': licenseNumber,
          'licenseExpiry': licenseExpiry,
          'degree': degree,
          'skills': skills,
          'languages': languages,
          'availability': availability,
          'workingHours': workingHours,
          'userId': _auth.currentUser?.uid,
          'createdAt': Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Professional record added successfully!')),
        );
        // Navigate to the profile screen
        Navigator.pushNamed(context, '/promProfile');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding professional record: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Professional Record')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
               Image.asset(
                'assets/addpro.png',
                fit: BoxFit.cover,
                width: 120,
                height: 150,
              ),
              SizedBox(height: 20),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Personal Information
                    Text('Personal Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Full Name'),
                      onChanged: (value) => fullName = value,
                      validator: (value) => value!.isEmpty ? 'Please enter full name' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Date of Birth'),
                      onChanged: (value) => dob = value,
                      validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Gender'),
                      onChanged: (value) => gender = value,
                      validator: (value) => value!.isEmpty ? 'Please enter gender' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      onChanged: (value) => phone = value,
                      validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onChanged: (value) => email = value,
                      validator: (value) => value!.isEmpty ? 'Please enter email address' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address'),
                      onChanged: (value) => address = value,
                      validator: (value) => value!.isEmpty ? 'Please enter address' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'City'),
                      onChanged: (value) => city = value,
                      validator: (value) => value!.isEmpty ? 'Please enter city' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'State/Province'),
                      onChanged: (value) => state = value,
                      validator: (value) => value!.isEmpty ? 'Please enter state' : null,
                    ),

                    // Professional Information
                    SizedBox(height: 20),
                    Text('Professional Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Professional Title'),
                      onChanged: (value) => title = value,
                      validator: (value) => value!.isEmpty ? 'Please enter title' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Specialization'),
                      onChanged: (value) => specialization = value,
                      validator: (value) => value!.isEmpty ? 'Please enter specialization' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Medical License Number'),
                      onChanged: (value) => licenseNumber = value,
                      validator: (value) => value!.isEmpty ? 'Please enter license number' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'License Expiry Date'),
                      onChanged: (value) => licenseExpiry = value,
                      validator: (value) => value!.isEmpty ? 'Please enter expiry date' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Degree(s)'),
                      onChanged: (value) => degree = value,
                      validator: (value) => value!.isEmpty ? 'Please enter degree(s)' : null,
                    ),
                    
                    // Skills and Expertise
                    SizedBox(height: 20),
                    Text('Skills and Expertise', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Skills'),
                      onChanged: (value) => skills = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Languages Known'),
                      onChanged: (value) => languages = value,
                    ),

                    // Availability
                    SizedBox(height: 20),
                    Text('Availability', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Availability'),
                      onChanged: (value) => availability = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Working Hours'),
                      onChanged: (value) => workingHours = value,
                    ),

                    // Submit Button
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleAddPro,
                      child: Text('Add Professional'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8E9BEF),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

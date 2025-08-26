import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddChildScreen extends StatefulWidget {
  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthWeightController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _addChildRecord() async {
    if (_childNameController.text.isEmpty ||
        _parentNameController.text.isEmpty ||
        _relationshipController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _birthWeightController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      final dob = DateTime.tryParse(_dobController.text);
      if (dob == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid date format. Use YYYY-MM-DD.')),
        );
        return;
      }

      final birthWeight = double.tryParse(_birthWeightController.text);
      if (birthWeight == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Birth weight must be a number.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('children').add({
        'childName': _childNameController.text,
        'parentName': _parentNameController.text,
        'relationship': _relationshipController.text,
        'dob': Timestamp.fromDate(dob),
        'gender': _genderController.text,
        'birthWeight': birthWeight,
        'address': _addressController.text,
        'userId': user.uid,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Child record added successfully!')),
      );
      Navigator.pushNamed(context, '/childprofile'); // Navigate to ProfileScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding child record: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Record'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ADD CHILD RECORD',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/addchild.png',
                fit: BoxFit.cover,
                width: 160,
                height: 120,
              ),
              SizedBox(height: 20),
              _buildTextField(_childNameController, 'Child Name'),
              _buildTextField(_parentNameController, 'Parent Name'),
              _buildTextField(_relationshipController, 'Relationship'),
              _buildTextField(_dobController, 'Date of Birth (YYYY-MM-DD)'),
              _buildTextField(_genderController, 'Gender'),
              _buildTextField(_birthWeightController, 'Birth Weight (kg)', isNumeric: true),
              _buildTextField(_addressController, 'Address'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addChildRecord,
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  backgroundColor: const Color.fromARGB(255, 245, 112, 112),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

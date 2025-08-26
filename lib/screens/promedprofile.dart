import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PromProfile extends StatefulWidget {
  @override
  _PromProfileState createState() => _PromProfileState();
}

class _PromProfileState extends State<PromProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      String userId = _auth.currentUser!.uid;
      var profileSnapshot = await _firestore
          .collection('promed')
          .where('userId', isEqualTo: userId)
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        setState(() {
          profile = profileSnapshot.docs[0].data();
          isLoading = false;
        });
      } else {
        _showAlert('No profile found', 'Please add your professional record first.');
      }
    } catch (e) {
      _showAlert('Error fetching profile', e.toString());
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Profile'),
        backgroundColor: Color(0xFF00CCCC),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                         Image.asset(
                'assets/addpro.png',
                fit: BoxFit.cover,
                width: 120,
                height: 150,
              ),
                        SizedBox(height: 10),
                        Text(
                          'Professional Profile',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        profile != null
                            ? _buildProfileInfo()
                            : Text('No profile information available.')
                      ],
                    ),
                  ),
                  _buildButtons(),
                  _buildBottomNav(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Full Name', profile!['fullName']),
        _buildInfoRow('Date of Birth', profile!['dob']),
        _buildInfoRow('Gender', profile!['gender']),
        _buildInfoRow('Phone', profile!['phone']),
        _buildInfoRow('Email', profile!['email']),
        _buildInfoRow('Address', profile!['address']),
        _buildInfoRow('City', profile!['city']),
        _buildInfoRow('State', profile!['state']),
        SizedBox(height: 20),
        Text(
          'Professional Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _buildInfoRow('Title', profile!['title']),
        _buildInfoRow('Specialization', profile!['specialization']),
        _buildInfoRow('License Number', profile!['licenseNumber']),
        _buildInfoRow('License Expiry', profile!['licenseExpiry']),
        _buildInfoRow('Degree', profile!['degree']),
        SizedBox(height: 20),
        Text(
          'Skills and Expertise',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _buildInfoRow('Skills', profile!['skills']),
        _buildInfoRow('Languages', profile!['languages']),
        SizedBox(height: 20),
        Text(
          'Availability',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        _buildInfoRow('Availability', profile!['availability']),
        _buildInfoRow('Working Hours', profile!['workingHours']),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildButton('Medical History', 'medkit-outline', () {
            Navigator.pushNamed(context, '/medicalHistory');
          }),
          _buildButton('Care Plan', 'clipboard-outline', () {
            Navigator.pushNamed(context, '/carePlan');
          }),
        ],
      ),
    );
  }

  Widget _buildButton(String label, String icon, Function() onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.medical_services), // Use appropriate icon
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00CCCC),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.alarm),
          label: 'Reminder',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/reminder');
            break;
          case 2:
            Navigator.pushNamed(context, '/promProfile');
            break;
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PatientProfileScreen extends StatefulWidget {
  @override
  _PatientProfileScreenState createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> familyMembers = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchFamilyMembers();
  }

  Future<void> fetchFamilyMembers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          familyMembers = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        setState(() {
          familyMembers = [];
        });
      }
    } catch (e) {
      print("Error fetching members: $e");
    }
  }

  /// ✅ Helper: Calculate age from dob
  int _calculateAge(String dob) {
    try {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(dob);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  /// ✅ Helper: Format name (capitalize first letter)
  String _formatName(String? name) {
    if (name == null || name.isEmpty) return "Unknown";
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }
   Widget actionButton(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF00A8E8).withOpacity(0.2),
            child: Icon(icon, color: const Color(0xFF00A8E8), size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Color(0xFF00A8E8),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addPatient');
            },
            child: Text("Add Member", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: familyMembers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off, size: 80, color: Colors.grey),
                  SizedBox(height: 15),
                  Text(
                    "No Family Records Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addPatient');
                    },
                    child: Text("Add Patient Record"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00A8E8),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Member Tabs
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: familyMembers.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Color(0xFF00A8E8)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _formatName(familyMembers[index]['name']),
                              style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Selected Profile View
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: _buildProfileCard(familyMembers[selectedIndex]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> data) {
    final name = _formatName(data['name']);
    final gender = data['gender'] ?? "N/A";
    final dob = data['dob'] ?? "";
    final age = dob.isNotEmpty ? _calculateAge(dob) : 0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.person, size: 40, color: Colors.blue[900]),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${data['gender'] ?? 'N/A'} | DOB: ${data['dob'] ?? 'N/A'}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              )
            ],
          ),
          Divider(height: 30),

          // Summary Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoTile(Icons.water_drop, "Blood Group",
                  data['bloodGroup'] ?? "N/A"),
              _buildInfoTile(
                  Icons.height, "Height", "${data['height'] ?? '-'} cm"),
              _buildInfoTile(Icons.monitor_weight, "Weight",
                  "${data['weight'] ?? '-'} kg"),
            ],
          ),
          SizedBox(height: 20),

          _infoRow("Phone", data['phone'] ?? "N/A"),
          _infoRow("Home Address", data['homeAddress'] ?? "N/A"),
          _infoRow("Primary Diagnosis", data['primaryDiagnosis'] ?? "N/A"),

          const Divider(height: 30),

          Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      actionButton(context, Icons.medical_services_outlined, 'Medical History', '/medicalHistory'),
                      actionButton(context, Icons.assignment_outlined, 'Care Plan', '/carePlan'),
                    ],
                  )
          )
         
        ],
        
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(height: 5),
        Text(value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

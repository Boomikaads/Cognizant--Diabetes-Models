import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


class ViewPromProfile extends StatefulWidget {
  const ViewPromProfile({Key? key}) : super(key: key);

  @override
  _ViewPromProfileState createState() => _ViewPromProfileState();
}

class _ViewPromProfileState extends State<ViewPromProfile> {
  Map<String, dynamic>? profile;
  bool loading = true;
  String? error;
  String? professionalId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Fetch the ID after the widget is fully initialized
    final id = ModalRoute.of(context)?.settings.arguments as String?;
    if (id != null && id.isNotEmpty) {
      professionalId = id;
      fetchProfile();
    } else {
      setState(() {
        error = 'Invalid ID';
        loading = false;
      });
    }
  }

  Future<void> fetchProfile() async {
    try {
      DocumentSnapshot docSnap = await FirebaseFirestore.instance
          .collection('promed')
          .doc(professionalId) // Use the fetched ID
          .get();
      if (docSnap.exists) {
        setState(() {
          profile = docSnap.data() as Map<String, dynamic>;
        });
      } else {
        setState(() {
          error = 'Profile not found';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching profile: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: SpinKitFadingCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Text(
          error!,
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Profile'),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.cyan.shade100,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(profile?['profileImage'] ??
                        'assets/promed.png'),
                    onBackgroundImageError: (_, __) => Icon(Icons.error),
                  ),
                  SizedBox(height: 10),
                  Text(
                    profile?['fullName'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade800,
                    ),
                  ),
                ],
              ),
            ),
            buildInfoSection('Personal Information', [
              buildInfoRow('Date of Birth', profile!['dob']),
              buildInfoRow('Gender', profile?['gender'] ?? 'N/A'),
              buildInfoRow('Phone', profile?['phone'] ?? 'N/A'),
              buildInfoRow('Email', profile?['email'] ?? 'N/A'),
              buildInfoRow('Address', profile?['address'] ?? 'N/A'),
              buildInfoRow('City', profile?['city'] ?? 'N/A'),
              buildInfoRow('State', profile?['state'] ?? 'N/A'),
            ]),
            buildInfoSection('Professional Information', [
              buildInfoRow('Title', profile?['title'] ?? 'N/A'),
              buildInfoRow('Specialization', profile?['specialization'] ?? 'N/A'),
              buildInfoRow('License Number', profile?['licenseNumber'] ?? 'N/A'),
              buildInfoRow('License Expiry', profile!['licenseExpiry']),
              buildInfoRow('Degree', profile?['degree'] ?? 'N/A'),
            ]),
            buildInfoSection('Skills and Expertise', [
              buildInfoRow('Skills', profile?['skills'] ?? 'N/A'),
              buildInfoRow('Languages', profile?['languages'] ?? 'N/A'),
            ]),
            buildInfoSection('Availability', [
              buildInfoRow('Availability', profile?['availability'] ?? 'N/A'),
              buildInfoRow('Working Hours', profile?['workingHours'] ?? 'N/A'),
            ]),
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
            icon: Icon(Icons.person_outline),
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
              Navigator.pushNamed(context, '/promprofile');
              break;
          }
        },
      ),
    );
  }

  Widget buildInfoSection(String title, List<Widget> rows) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan.shade700,
                ),
              ),
              Divider(color: Colors.grey.shade300),
              ...rows,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

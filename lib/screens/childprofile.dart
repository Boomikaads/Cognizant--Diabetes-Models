import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Childprofile extends StatefulWidget {
  @override
  _ChildprofileState createState() => _ChildprofileState();
}

class _ChildprofileState extends State<Childprofile> {
  Map<String, dynamic>? childData;
  Map<String, int>? childAge;
  bool isLoading = true;

  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    if (userId != null) {
      fetchChildData();
    } else {
      showAlert('Error', 'User is not logged in.');
    }
  }

  Future<void> fetchChildData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('children')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        setState(() {
          childData = data;
          if (data['dob'] != null) {
            childAge = calculateAge((data['dob'] as Timestamp).toDate());
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showAlert('No Records', 'No child records found for this user.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showAlert('Error', 'Error fetching child data: $e');
    }
  }

  Map<String, int> calculateAge(DateTime dob) {
    final today = DateTime.now();
    int years = today.year - dob.year;
    int months = today.month - dob.month;
    int days = today.day - dob.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(today.year, today.month, 0).day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    return {'years': years, 'months': months, 'days': days};
  }

  void showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7F9),
      appBar: AppBar(
        title: Text('Child Profile'),
        backgroundColor: Color(0xFF00CCCC),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header
                    Column(
                      children: [
                        Text(
                          'Your Profile',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          childData?['childName'] ?? 'Nil',
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/addchild'),
                          child: Text(
                            'Update your profile',
                            style: TextStyle(
                              color: Color(0xFF0099CC),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Image.asset(
                          'assets/addchild.png',
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Information Section
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          buildInfoRow('Child\'s Name', childData?['childName'] ?? 'Nil'),
                          buildInfoRow('Parent\'s Name', childData?['parentName'] ?? 'Nil'),
                          buildInfoRow('Relationship', childData?['relationship'] ?? 'Nil'),
                          buildInfoRow('Date of Birth', childData?['dob'] != null
                              ? (childData!['dob'] as Timestamp).toDate().toLocal().toString().split(' ')[0]
                              : 'Nil'),
                          buildInfoRow(
                            'Age',
                            childAge != null
                                ? "${childAge!['years']} years, ${childAge!['months']} months, ${childAge!['days']} days"
                                : 'Nil',
                          ),
                          buildInfoRow('Gender', childData?['gender'] ?? 'Nil'),
                          buildInfoRow('Birth Weight', childData?['birthWeight']?.toString() ?? 'Nil'),
                          buildInfoRow('Address', childData?['address'] ?? 'Nil'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Buttons Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
  onPressed: () {
    if (childData?['dob'] != null) {
      Navigator.pushNamed(
        context,
        '/schedule',
        arguments: (childData!['dob'] as Timestamp).toDate(),
      );
    } else {
      showAlert('Error', 'Date of Birth is not available.');
    }
  },
  icon: Icon(Icons.calendar_today_outlined),
  label: Text('Vaccination Chart'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF00CCCC),
  ),
),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/addchild'),
                          icon: Icon(Icons.person_add_outlined),
                          label: Text('Add Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00CCCC),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF00CCCC),
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
          if (index == 0) Navigator.pushNamed(context, '/people');
          if (index == 1) Navigator.pushNamed(context, '/reminder');
          if (index == 2) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

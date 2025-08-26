import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ParaSearch extends StatefulWidget {
  @override
  _ParaSearchState createState() => _ParaSearchState();
}

class _ParaSearchState extends State<ParaSearch> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  String? _error;

  Future<void> handleSearch() async {
    final city = _cityController.text.trim();
    final specialization = _specializationController.text.trim();

    if (city.isEmpty || specialization.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter both city and specialization.');
      return;
    }

    setState(() {
      _isLoading = true;
      _results.clear();
      _error = null;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('promed')
          .where('city', isEqualTo: city)
          .where('specialization', isEqualTo: specialization)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Fluttertoast.showToast(msg: 'No paramedical professionals found.');
      } else {
        setState(() {
          _results = querySnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching results: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getProfileImage(String? gender) {
    if (gender?.toLowerCase() == 'male') {
      return 'assets/malepara.png';
    } else if (gender?.toLowerCase() == 'female') {
      return 'assets/femalepara.png';
    }
    return 'assets/defaultpara.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect with Skilled Paramedical Experts'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Find Trusted Paramedical Professionals Near You',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontFamily: 'Lato',
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/splash.png',
              fit: BoxFit.cover,
              width: 150,
              height: 170,
            ),
            SizedBox(height: 20),

            // ✅ Asking if paramedical staff
            Card(
              elevation: 4,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      "Are you a Paramedical Staff?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/addPromed');
                      },
                      icon: Icon(Icons.add_circle_outline),
                      label: Text("Yes, Register Me"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔍 Search fields
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _specializationController,
              decoration: InputDecoration(
                labelText: 'Enter Specialization (e.g., Orthopedic)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_hospital),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8E9BEF),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final prof = _results[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(getProfileImage(prof['gender'])),
                      backgroundColor: Colors.grey[200],
                    ),
                    title: Text(
                      prof['fullName'] ?? 'N/A',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prof['specialization'] ?? 'N/A'),
                        Text(prof['city'] ?? 'N/A'),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/viewpromed',
                        arguments: prof['id'],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

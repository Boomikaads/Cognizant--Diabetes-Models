import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExploreServicesScreen extends StatefulWidget {
  @override
  _ExploreServicesScreenState createState() => _ExploreServicesScreenState();
}

class _ExploreServicesScreenState extends State<ExploreServicesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool hasChildren = false;
  bool hasSeniors = false;
  bool hasAdults = false;
  bool hasProMed = false;

  @override
  void initState() {
    super.initState();
    _checkRecords();
  }

  Future<void> _checkRecords() async {
    final userId = _auth.currentUser?.uid;

    if (userId != null) {
      try {
        final List<Future<QuerySnapshot>> queries = [
          _db.collection('children').where('userId', isEqualTo: userId).get(),
          _db.collection('senior').where('userId', isEqualTo: userId).get(),
          _db.collection('adults').where('userId', isEqualTo: userId).get(),
          _db.collection('promed').where('userId', isEqualTo: userId).get(),
        ];

        final results = await Future.wait(queries);

        setState(() {
          hasChildren = results[0].docs.isNotEmpty;
          hasSeniors = results[1].docs.isNotEmpty;
          hasAdults = results[2].docs.isNotEmpty;
          hasProMed = results[3].docs.isNotEmpty;
        });
      } catch (error) {
        _showErrorSnackbar('Error fetching records: $error');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToScreen(bool hasRecord, String profileScreen, String addScreen) {
    try {
      if (hasRecord) {
        Navigator.pushNamed(context, profileScreen);
      } else {
        Navigator.pushNamed(context, addScreen);
      }
    } catch (e) {
      _showErrorSnackbar('Navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Choose a Service by Age Group"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _serviceTile(
                  title: "Lil' Health",
                  imageAsset: 'assets/lil.png',
                  onTap: () {
                    print('Tapped on Lil\' Health');
                    _navigateToScreen(hasChildren, '/childProfile', '/addchild');
                  },
                ),
                _serviceTile(
                  title: "Golden Care",
                  imageAsset: 'assets/golden.png',
                  onTap: () {
                    print('Tapped on Golden Care');
                    _navigateToScreen(hasSeniors, '/seniorProfile', '/addsenior');
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _serviceTile(
                  title: "Adult Care",
                  imageAsset: 'assets/adult.png',
                  onTap: () {
                    print('Tapped on Adult Care');
                    _navigateToScreen(hasAdults, '/adultprofile', '/addAdult');
                  },
                ),
                _serviceTile(
                  title: "Pro Med",
                  imageAsset: 'assets/promed.png',
                  onTap: () {
                    print('Tapped on Pro Med');
                    _navigateToScreen(hasProMed, '/promedprofile', '/addPromed');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  Widget _serviceTile({required String title, required String imageAsset, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Container(
            width: 160,
            height: 200,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageAsset,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/menu'),
          ),
        ],
      ),
    );
  }
}

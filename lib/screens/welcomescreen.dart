import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cards = [
    {
  'title': 'Patient Profile',
  'subtitle': 'View patient details, diagnosis, medications, and reports.',
  'image': 'assets/exploreservices.png',
  'navigateTo': '/patientprofile',
},
{
  'title': 'Risk Prediction',
  'subtitle': 'Predict diabetes and hypertension risk with AI-powered insights.',
  'image': 'assets/vaccinechart.png',
  'navigateTo': '/risk',
},
{
  'title': 'Patient Care',
  'subtitle': 'Access paramedical support for diabetes, hypertension, and chronic care needs.',
  'image': 'assets/getservice.png',
  'navigateTo': '/parasearch',
},

//     {
//   'title': 'Manage Health',
//   'subtitle': 'Stay on top of diabetes, hypertension, and more with personalized care.',
//   'image': 'assets/getreminders.png',
//   'navigateTo': '/managehealth',
// },
    {
      'title': 'Nearby Hospitals',
      'subtitle': 'Stay informed and access healthcare facilities easily.',
      'image': 'assets/nearby.png',
      'navigateTo': '/maps',
    },
   {
  'title': 'Health Insights',
  'subtitle': 'Explore tips, exercises, and expert advice for managing chronic conditions.',
  'image': 'assets/knowvaccine.png',
  'navigateTo': '/know',
},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to VacMed'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            final isImageLeft = index % 2 == 0; // Alternate image position

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, card['navigateTo']);
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 30),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 140, // Adjusted height for better spacing
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: isImageLeft
                        ? [
                            // Image on the left
                            Image.asset(
                              card['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 20),
                            // Content on the right
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    card['subtitle'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF666666),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ]
                        : [
                            // Content on the left
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    card['subtitle'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF666666),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            // Image on the right
                            Image.asset(
                              card['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

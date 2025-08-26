// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class HealthHomePage extends StatelessWidget {
//   final TextEditingController searchController = TextEditingController();

//   void navigateToWebView(BuildContext context, String url) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => InAppBrowserPage(url: url),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Health Topics',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Bar
//             TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 hintText: 'Search for health topics...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onSubmitted: (query) {
//                 final googleSearchUrl = 'https://www.google.com/search?q=$query';
//                 navigateToWebView(context, googleSearchUrl);
//               },
//             ),
//             SizedBox(height: 20),

//             // Welcome Text
//             Text(
//               'Welcome to CareSYnc+',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Explore health information and advice.',
//               style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             ),
//             SizedBox(height: 20),

//             // Grid of Features
//             GridView.count(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               children: [
//                 FeatureTile(
//                   title: 'Check your symptoms',
//                   image: 'assets/checksym.png',
//                   onTap: () {
//                     navigateToWebView(
//                       context,
//                       'https://www.google.com/search?q=check+your+symptoms',
//                     );
//                   },
//                 ),
//                 FeatureTile(
//                   title: 'Find a health service',
//                   image: 'assets/healthser.png',
//                   onTap: () {
//                     navigateToWebView(
//                       context,
//                       'https://www.google.com/search?q=find+health+services',
//                     );
//                   },
//                 ),
//                 FeatureTile(
//                   title: 'Explore health topics',
//                   image: 'assets/explorehealth.png',
//                   onTap: () {
//                     navigateToWebView(
//                       context,
//                       'https://www.google.com/search?q=health+topics',
//                     );
//                   },
//                 ),
//                 FeatureTile(
//                   title: 'Know Medicines Library',
//                   image: 'assets/knowvaccine.png',
//                   onTap: () {
//                     navigateToWebView(
//                       context,
//                       'https://www.google.com/search?q=Medicines+List+Uses+Sideeffects',
//                     );
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),

//             // Open YouTube Button
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   navigateToWebView(
//                     context,
//                     'https://www.youtube.com/',
//                   );
//                 },
//                 icon: Icon(
//                   Icons.youtube_searched_for, // YouTube-styled icon
//                   color: Colors.white,
//                 ),
//                 label: Text(
//                   'Open YouTube',
//                   style: TextStyle(fontSize: 18,color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red, // YouTube red color
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FeatureTile extends StatelessWidget {
//   final String title;
//   final String image;
//   final VoidCallback onTap;

//   FeatureTile({required this.title, required this.image, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 5,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               image,
//               height: 100, // Increased height for larger images
//               width: 100,  // Increased width for larger images
//             ),
//             SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class InAppBrowserPage extends StatefulWidget {
//   final String url;

//   InAppBrowserPage({required this.url});

//   @override
//   _InAppBrowserPageState createState() => _InAppBrowserPageState();
// }

// class _InAppBrowserPageState extends State<InAppBrowserPage> {
//   late InAppWebViewController webViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Browser'),
//         backgroundColor: Colors.teal,
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//           url: WebUri.uri(Uri.parse(widget.url)),
//         ),
//         onWebViewCreated: (controller) {
//           webViewController = controller;
//         },
//         onLoadStart: (controller, url) {
//           print("Started loading: $url");
//         },
//         onLoadStop: (controller, url) {
//           print("Finished loading: $url");
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ChronicDiseasePage extends StatelessWidget {
  final List<Map<String, String>> topics = [
    {
      "title": "Lower Blood Pressure by Exercises",
      "image": "assets/splash.png",
      "description":
          "Regular physical activity helps lower high blood pressure by strengthening the heart, reducing stress, and maintaining a healthy weight."
    },
    {
      "title": "How to Control Blood Pressure",
      "image": "assets/healthser.png",
      "description":
          "Blood pressure can be controlled by a balanced diet, limiting salt intake, regular exercise, reducing stress, and following prescribed medicines."
    },
    {
      "title": "First-Line Drugs for Hypertension",
      "image": "assets/knowvaccine.png",
      "description":
          "Common first-line drugs for hypertension include diuretics, ACE inhibitors, ARBs, calcium channel blockers, and beta-blockers."
    },
    {
      "title": "First Aid Tips for Hypertensive Crisis",
      "image": "assets/getservice.png",
      "description":
          "During a hypertensive crisis, call emergency services immediately. Have the patient sit calmly, avoid caffeine, and follow prescribed emergency medicine if available."
    },
    {
      "title": "How Does BP Affect Your Body?",
      "image": "assets/searchmedi.png",
      "description":
          "Uncontrolled high blood pressure damages arteries, heart, brain, kidneys, and eyes, increasing the risk of stroke, heart attack, and organ failure."
    },
    {
      "title": "Hypertension Control During Diet",
      "image": "assets/exploreservices.png",
      "description":
          "A hypertension-friendly diet includes more fruits, vegetables, whole grains, low-fat dairy, lean proteins, and reduced sodium intake."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chronic Disease Management"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: topics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final topic = topics[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArticleDetailPage(
                      title: topic["title"]!,
                      image: topic["image"]!,
                      description: topic["description"]!,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        topic["image"]!,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 9),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        topic["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final String title;
  final String image;
  final String description;

  ArticleDetailPage({
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Article"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image, height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.teal, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Note: Always consult your healthcare provider before making major health decisions.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


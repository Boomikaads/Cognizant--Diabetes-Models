import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MedPage extends StatefulWidget {
  @override
  _MedPageState createState() => _MedPageState();
}

class _MedPageState extends State<MedPage> {
  String? reportSummary = "No summary available yet.";
  TextEditingController conditionController = TextEditingController();
  String? carePlanUrl;

  void fetchCarePlan(String condition) async {
    try {
      // Simulate a Google search URL for the care plan
      String query = Uri.encodeComponent("care plan for $condition");
      String googleSearchUrl = "https://www.google.com/search?q=$query";

      // Update the report summary and care plan URL
      setState(() {
        reportSummary = "Care plan for $condition fetched successfully. Tap below to view.";
        carePlanUrl = googleSearchUrl;
      });

      // Show a toast notification
      Fluttertoast.showToast(
        msg: "Care plan fetched successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching care plan: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void openWebView(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0099CC),
        title: Text('Medical Care Plans'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Section
              Text(
                'Enter a Medical Condition:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: conditionController,
                decoration: InputDecoration(
                  hintText: 'e.g., Hypertension, Diabetes Type 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  String condition = conditionController.text.trim();
                  if (condition.isNotEmpty) {
                    fetchCarePlan(condition);
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please enter a medical condition.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: Text("Get Care Plan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00CCCC),
                ),
              ),

              SizedBox(height: 20),

              // Summarized Report Section
              Text(
                'Care Plan Summary:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              if (carePlanUrl != null)
                GestureDetector(
                  onTap: () => openWebView(carePlanUrl!),
                  child: Text(
                    reportSummary!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else
                Text(
                  reportSummary!,
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0099CC),
        title: Text('Care Plan Viewer'),
        centerTitle: true,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url), // Convert to WebUri
        ),
        onLoadError: (controller, url, code, message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error loading page: $message"),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class MedPage extends StatefulWidget {
//   @override
//   _MedPageState createState() => _MedPageState();
// }

// class _MedPageState extends State<MedPage> {
//   List<String> medicalHistory = [
//     "Hypertension - 2015",
//     "Diabetes Type 2 - 2017",
//     "Heart Surgery - 2020",
//   ];
//   String? reportSummary = "No summary available yet.";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF0099CC),
//         title: Text('Medical History'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Medical History List
//             Container(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Previous Medical Conditions:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   ...medicalHistory.map((condition) => ListTile(
//                         title: Text(condition),
//                         leading: Icon(Icons.medical_services),
//                       )),
//                 ],
//               ),
//             ),

//             // File Upload Section
//             Container(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Upload Medical Report:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () async {
//                       try {
//                         // Open file picker dialog
//                         FilePickerResult? result = await FilePicker.platform.pickFiles(
//                           type: FileType.custom,
//                           allowedExtensions: ['pdf', 'jpg', 'png'],
//                         );

//                         if (result != null && result.files.isNotEmpty) {
//                           // Handle file selection (e.g., upload or show toast)
//                           String fileName = result.files.single.name;

//                           // Using the latest fluttertoast API version 8.2.10
//                           Fluttertoast.showToast(
//                             msg: "File uploaded: $fileName",
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             timeInSecForIosWeb: 1,
//                             backgroundColor: Colors.black,
//                             textColor: Colors.white,
//                             fontSize: 16.0,
//                           );
//                         } else {
//                           // Show toast for no file selected
//                           Fluttertoast.showToast(
//                             msg: "No file selected.",
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.BOTTOM,
//                             timeInSecForIosWeb: 1,
//                             backgroundColor: Colors.black,
//                             textColor: Colors.white,
//                             fontSize: 16.0,
//                           );
//                         }
//                       } catch (e) {
//                         // Catch any initialization or runtime errors
//                         Fluttertoast.showToast(
//                           msg: "Error selecting file: $e",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           timeInSecForIosWeb: 1,
//                           backgroundColor: Colors.red,
//                           textColor: Colors.white,
//                           fontSize: 16.0,
//                         );
//                       }
//                     },
//                     child: Text("Upload Report"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF00CCCC),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Summarized Report Section
//             Container(
//               padding: EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Summarized Report:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     reportSummary!,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

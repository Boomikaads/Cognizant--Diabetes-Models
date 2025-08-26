import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/Aboutus.dart';
import 'screens/Loginscreen.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcomescreen.dart';
import 'screens/register.dart';
import 'screens/ExploreServicesScreen.dart';
import 'screens/AddChild.dart';
import 'screens/childprofile.dart';
import 'screens/AddSenior.dart';
import 'screens/seniorprofile.dart';
import 'screens/AddAdult.dart';
import 'screens/adultprofile.dart';
import 'screens/AddPromed.dart';
import 'screens/promedprofile.dart';
import 'screens/ParaSearch.dart';
import 'screens/Viewpromed.dart';
import 'screens/VaccineChart.dart';
import 'screens/Reminder.dart';
import 'screens/VaccineSchedule.dart';
import 'screens/vaccine_schedule_provider.dart';
import 'screens/maps.dart';
import 'screens/Know.dart';
import 'screens/med.dart';
import 'screens/PatientProfileScreen.dart';
import 'screens/AddPatient.dart';
import 'screens/risk.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VaccineScheduleProvider(), // Provide the provider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Set the initial route
        routes: {
          '/': (context) => SplashScreen(),
          '/about': (context) => AboutUsScreen(),
          '/login': (context) => LoginScreen(),
          '/welcomescreen': (context) => WelcomeScreen(),
          '/register': (context) => RegisterScreen(),
          '/exploreservices': (context) => ExploreServicesScreen(),
          '/addchild': (context) => AddChildScreen(),
          '/childProfile': (context) => Childprofile(),
          '/addsenior': (context) => AddSeniorScreen(),
          '/seniorProfile': (context) => SeniorProfile(),
          '/addAdult': (context) => AddAdultScreen(),
          '/adultprofile': (context) => AdultProfile(),
          '/addPromed': (context) => AddProScreen(),
          '/promedprofile': (context) => PromProfile(),
          '/parasearch': (context) => ParaSearch(),
          '/viewpromed': (context) => ViewPromProfile(),
          '/vaccinechart': (context) => VaccineChart(),
          '/reminder': (context) => ReminderScreen(),
          '/schedule': (context) => VaccinationSchedule(),
          '/maps': (context)=> NearbyHospitalsPage(),
          '/know': (context)=> ChronicDiseasePage(),
          '/med': (context)=> MedPage(),
          '/patientprofile': (context) => PatientProfileScreen(),
          '/addPatient': (context) => AddPatientScreen(),
          '/risk': (context) => RiskPredictionScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AboutUsScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink[100],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/splash.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.blue[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Your health is our vibe.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

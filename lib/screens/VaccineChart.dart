import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vaccine Schedule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VaccineChart(),
    );
  }
}

class VaccineChart extends StatefulWidget {
  @override
  _VaccineChartState createState() => _VaccineChartState();
}

class _VaccineChartState extends State<VaccineChart> {
  bool _modalVisible = false;
  String? _selectedVaccine;

  // Sample images (URLs used from the React code)
  final Map<String, String> images = {
    'birth': 'assets/birt.png',
    'sixWeeks': 'assets/6w.png',
    'tenWeeks': 'assets/10w.png',
    'fourteenWeeks': 'assets/14w.png',
    'nineToTwelveMonths': 'assets/9m.png',
    'sixteenToTwentyFourMonths': 'assets/24m.png',
    'fiveToSixYears': 'assets/5y.png',
    'tenYears': 'assets/10y.png',
    'sixteenYears': 'assets/16y.png',
    'pregnant': 'assets/preg.png',
  };

  final List<Map<String, dynamic>> nationalSchedule = [
    {
      'age': 'At Birth',
      'vaccines': ['OPV-Zero', 'BCG', 'Hep B (Birth dose)'],
      'image': 'birth',
      'color': Color(0xFFCDB4DB), // cdb4db
    },
    {
      'age': '6 weeks',
      'vaccines': ['OPV-1', 'RVV-1', 'fIPV-1', 'Pentavalent-1', 'PCV-1'],
      'image': 'sixWeeks',
      'color': Color(0xFFFFC8DD), // ffc8dd
    },
    {
      'age': '10 weeks',
      'vaccines': ['OPV-2', 'RVV-2', 'Pentavalent-2', 'PCV-2'],
      'image': 'tenWeeks',
      'color': Color(0xFFBDE0FE), // bde0fe
    },
    {
      'age': '14 weeks',
      'vaccines': ['OPV-3', 'RVV-3', 'fIPV-2', 'Pentavalent-3', 'PCV-3'],
      'image': 'fourteenWeeks',
      'color': Color(0xFFFFA5AB), // ffa5ab
    },
    {
      'age': '9-12 months',
      'vaccines': ['MR-1', 'fIPV-3', 'PCV-Booster', 'JE-1'],
      'image': 'nineToTwelveMonths',
      'color': Color(0xFFF5CAC3), // f5cac3
    },
    {
      'age': '16-24 months',
      'vaccines': ['OPV-Booster', 'MR-2', 'DPT-Booster-1', 'JE-2'],
      'image': 'sixteenToTwentyFourMonths',
      'color': Color(0xFFCBEFF3), // cbeef3
    },
    {
      'age': '5-6 years',
      'vaccines': ['DPT-Booster-2'],
      'image': 'fiveToSixYears',
      'color': Color(0xFFA6D8D4), // a6d8d4
    },
    {
      'age': '10 years',
      'vaccines': ['Td'],
      'image': 'tenYears',
      'color': Color(0xFFF2D7EE), // f2d7ee
    },
    {
      'age': '16 years',
      'vaccines': ['Td'],
      'image': 'sixteenYears',
      'color': Color(0xFFefefd0), // cbeef3
    },
    {
      'age': 'Pregnant Women',
      'vaccines': ['Td1, Td2 or Td Booster'],
      'image': 'pregnant',
      'color': Color(0xFFc4f1be), // cbeef3
    },
  ];

  // Vaccine details map (shortened for example)
  final Map<String, String> vaccineDetails = {
    'OPV-Zero': 'Oral Polio Vaccine protects against polio.',
    'BCG': 'BCG protects against tuberculosis. Side effects: Soreness, fever.',
    'Hep B (Birth dose)': 'Protects against Hepatitis B. Side effects: Redness at injection site.',
    'OPV-1': 'Oral Polio Vaccine protects against polio. Side effects: Generally none, very rare mild fever.',
    'RVV-1': 'Rotavirus Vaccine protects against rotavirus infection, which causes severe diarrhea. Side effects: Mild fever, irritability.',
    'fIPV-1': 'Fractional Inactivated Polio Vaccine protects against polio. Side effects: Mild fever, redness at injection site.',
    'Pentavalent-1': 'Pentavalent Vaccine protects against five diseases: diphtheria, pertussis, tetanus, hepatitis B, and Haemophilus influenzae type b. Side effects: Mild fever, redness at injection site.',
    'PCV-1': 'Pneumococcal Conjugate Vaccine protects against pneumococcal diseases like pneumonia and meningitis. Side effects: Mild fever, redness at injection site.',
    'OPV-2': 'Oral Polio Vaccine protects against polio. Side effects: Generally none, very rare mild fever.',
    'RVV-2': 'Rotavirus Vaccine protects against rotavirus infection, which causes severe diarrhea. Side effects: Mild fever, irritability.',
    'Pentavalent-2': 'Pentavalent Vaccine protects against five diseases: diphtheria, pertussis, tetanus, hepatitis B, and Haemophilus influenzae type b. Side effects: Mild fever, redness at injection site.',
    'PCV-2': 'Pneumococcal Conjugate Vaccine protects against pneumococcal diseases like pneumonia and meningitis. Side effects: Mild fever, redness at injection site.',
     'OPV-3': 'Oral Polio Vaccine protects against polio. Side effects: Generally none, very rare mild fever.',
  'RVV-3': 'Rotavirus Vaccine protects against rotavirus infection, which causes severe diarrhea. Side effects: Mild fever, irritability.',
  'fIPV-2': 'Fractional Inactivated Polio Vaccine protects against polio. Side effects: Mild fever, redness at injection site.',
  'Pentavalent-3': 'Pentavalent Vaccine protects against five diseases: diphtheria, pertussis, tetanus, hepatitis B, and Haemophilus influenzae type b. Side effects: Mild fever, redness at injection site.',
  'PCV-3': 'Pneumococcal Conjugate Vaccine protects against pneumococcal diseases like pneumonia and meningitis. Side effects: Mild fever, redness at injection site.',
  'MR-1': 'Measles-Rubella Vaccine protects against measles and rubella. Side effects: Mild fever, rash.',
  'fIPV-3': 'Fractional Inactivated Polio Vaccine protects against polio. Side effects: Mild fever, redness at injection site.',
  'PCV-Booster': 'Pneumococcal Conjugate Vaccine booster protects against pneumococcal diseases. Side effects: Mild fever, redness at injection site.',
  'JE-1': 'Japanese Encephalitis Vaccine protects against Japanese Encephalitis. Side effects: Mild fever, soreness at injection site.',
  'OPV-Booster': 'Oral Polio Vaccine booster protects against polio. Side effects: Generally none, very rare mild fever.',
  'MR-2': 'Measles-Rubella Vaccine protects against measles and rubella. Side effects: Mild fever, rash.',
  'DPT-Booster-1': 'Diphtheria, Pertussis, and Tetanus Booster protects against diphtheria, pertussis, and tetanus. Side effects: Mild fever, soreness at injection site.',
  'JE-2': 'Japanese Encephalitis Vaccine booster protects against Japanese Encephalitis. Side effects: Mild fever, soreness at injection site.',
  'DPT-Booster-2': 'Diphtheria, Pertussis, and Tetanus Booster protects against diphtheria, pertussis, and tetanus. Side effects: Mild fever, soreness at injection site.',
  'Td': 'Tetanus and Diphtheria Vaccine protects against tetanus and diphtheria. Side effects: Soreness at injection site, mild fever.',
  'Td1': 'Tetanus and Diphtheria Vaccine (first dose) protects against tetanus and diphtheria. Side effects: Soreness at injection site, mild fever.',
  'Td2': 'Tetanus and Diphtheria Vaccine (second dose) protects against tetanus and diphtheria. Side effects: Soreness at injection site, mild fever.',
  'Td Booster': 'Tetanus and Diphtheria Booster protects against tetanus and diphtheria. Side effects: Soreness at injection site, mild fever.',
  'Td1, Td2 or Td Booster': 'Td1, Td2, or Td Booster for pregnant women protects against tetanus and diphtheria. Side effects: Mild fever, soreness at injection site.'
};

    void _showVaccineDetails(String vaccine) {
    setState(() {
      _selectedVaccine = vaccine;
    });
    _showDialog();
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _selectedVaccine ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  vaccineDetails[_selectedVaccine ?? ''] ?? 'Details not available',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 229, 127, 119),
                      ),
                      child: Text('Close', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic for booking vaccine
                         Navigator.pushNamed(context, '/maps');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 113, 198, 116),
                      ),
                      child: Text('Book Vaccine',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                      
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccine Schedule', textAlign: TextAlign.center),
      ),
      body: ListView.builder(
        itemCount: nationalSchedule.length,
        itemBuilder: (context, index) {
          var schedule = nationalSchedule[index];
          bool isEven = index % 2 == 0;
          return Card(
            color: schedule['color'],
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: isEven
                  ? null
                  : Image.asset(images[schedule['image']] ?? 'https://example.com/default-image.png', width: 120, height: 200, fit: BoxFit.contain,),
              trailing: !isEven
                  ? null
                  : Image.asset(images[schedule['image']] ?? 'https://example.com/default-image.png', width: 120, height: 200, fit: BoxFit.contain,),
              title: Center(child: Text(schedule['age'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
               children: [
  for (var vaccine in schedule['vaccines'])
    GestureDetector(
      onTap: () => _showVaccineDetails(vaccine),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5), // Add some spacing between the items
        child: Text(
          vaccine,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20, // Reduced size
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.underline, // Adds underline
          ),
          textAlign: TextAlign.center, // Align text to center if needed
        ),
      ),
    ),
],

              ),
            ),
          );
        },
      ),
    );
  }
}

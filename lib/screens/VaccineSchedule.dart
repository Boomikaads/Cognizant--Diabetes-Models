import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class VaccinationSchedule extends StatelessWidget {
  VaccinationSchedule({Key? key}) : super(key: key);

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

  final Map<String, Color> vaccineColors = {
  'OPV-Zero': Colors.teal,
  'BCG': Colors.blue,
  'Hep B (Birth dose)': Colors.green,
  'OPV-1': Colors.orange,
  'RVV-1': Colors.purple,
  'fIPV-1': Colors.pink,
  'Pentavalent-1': Colors.yellow,
  'PCV-1': Colors.red,
  'OPV-2': Colors.lightGreen,
  'RVV-2': Colors.deepOrange,
  'Pentavalent-2': Colors.indigo,
  'PCV-2': Colors.cyan,
  'OPV-3': Colors.brown,
  'RVV-3': Colors.amber,
  'fIPV-2': Colors.lime,
  'Pentavalent-3': Colors.deepPurple,
  'PCV-3': Colors.blueGrey,
  'MR-1': Colors.lightBlue,
  'fIPV-3': Colors.pinkAccent,
  'PCV-Booster': Colors.greenAccent,
  'JE-1': Colors.orangeAccent,
  'OPV-Booster': Colors.purpleAccent,
  'MR-2': Colors.redAccent,
  'DPT-Booster-1': Colors.tealAccent,
  'JE-2': Colors.indigoAccent,
  'DPT-Booster-2': Colors.yellowAccent,
  'Td': Colors.lightGreenAccent,
  'Td1': Colors.deepOrangeAccent,
  'Td2': Colors.limeAccent,
  'Td Booster': Colors.cyanAccent,
  'Td1, Td2 or Td Booster': Colors.amberAccent,
};


  List<Appointment> getVaccinationAppointments(DateTime dob) {
    final vaccines = [
      {
        "age": "At Birth",
        "vaccines": [
          {"name": "OPV-Zero", "dueInDays": 0},
          {"name": "BCG", "dueInDays": 0},
          {"name": "Hep B (Birth dose)", "dueInDays": 0}
        ]
      },
      {
        "age": "6 weeks",
        "vaccines": [
          {"name": "OPV-1", "dueInDays": 42},
          {"name": "RVV-1", "dueInDays": 42},
          {"name": "fIPV-1", "dueInDays": 42},
          {"name": "Pentavalent-1", "dueInDays": 42},
          {"name": "PCV-1", "dueInDays": 42}
        ]
      },
      {
        "age": "10 weeks",
        "vaccines": [
          {"name": "OPV-2", "dueInDays": 70},
          {"name": "RVV-2", "dueInDays": 70},
          {"name": "Pentavalent-2", "dueInDays": 70},
          {"name": "PCV-2", "dueInDays": 70}
        ]
      },
      {
        "age": "14 weeks",
        "vaccines": [
          {"name": "OPV-3", "dueInDays": 98},
          {"name": "RVV-3", "dueInDays": 98},
          {"name": "fIPV-2", "dueInDays": 98},
          {"name": "Pentavalent-3", "dueInDays": 98},
          {"name": "PCV-3", "dueInDays": 98}
        ]
      },
      {
        "age": "9-12 months",
        "vaccines": [
          {"name": "MR-1", "dueInDays": 365},
          {"name": "fIPV-3", "dueInDays": 365},
          {"name": "PCV-Booster", "dueInDays": 365},
          {"name": "JE-1", "dueInDays": 365}
        ]
      },
      {
        "age": "16-24 months",
        "vaccines": [
          {"name": "OPV-Booster", "dueInDays": 730},
          {"name": "MR-2", "dueInDays": 730},
          {"name": "DPT-Booster-1", "dueInDays": 730},
          {"name": "JE-2", "dueInDays": 730}
        ]
      },
      {
        "age": "5-6 years",
        "vaccines": [
          {"name": "DPT-Booster-2", "dueInDays": 1825}
        ]
      },
      {
        "age": "10 years",
        "vaccines": [
          {"name": "Td", "dueInDays": 3650}
        ]
      },
      {
        "age": "16 years",
        "vaccines": [
          {"name": "Td", "dueInDays": 5840}
        ]
      }
      // Add more age groups and vaccines here
    ];

    List<Appointment> appointments = [];

    for (var vaccineEntry in vaccines) {
      if (vaccineEntry['vaccines'] != null) {
        for (var vaccine in vaccineEntry['vaccines'] as List<dynamic>) {
          final dueDate = dob.add(Duration(days: vaccine['dueInDays']));
          appointments.add(Appointment(
            startTime: dueDate,
            endTime: dueDate.add(Duration(hours: 1)),
            subject: vaccine['name'],
            color: vaccineColors[vaccine['name']] ?? Colors.grey,
          ));
        }
      }
    }

    return appointments;
  }

  void showVaccineDetails(BuildContext context, String vaccine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(vaccine, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Text(
          vaccineDetails[vaccine] ?? 'Details not available.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              // Logic for booking vaccine
              Navigator.pop(context);
            },
            child: Text('Book Vaccine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dob = ModalRoute.of(context)?.settings.arguments as DateTime?;

    if (dob == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Vaccination Schedule'),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Text(
            'Error: Date of Birth not provided!',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    final appointments = getVaccinationAppointments(dob);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vaccination Schedule'),
        backgroundColor: Colors.teal,
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: VaccineDataSource(appointments),
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onTap: (calendarTapDetails) {
  if (calendarTapDetails.appointments != null && calendarTapDetails.appointments!.isNotEmpty) {
    // Collect all appointments for the tapped date
    final appointments = calendarTapDetails.appointments!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Vaccines Scheduled"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: appointments.map((appointment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.subject,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      vaccineDetails[appointment.subject] ?? "Details not available.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Logic for booking vaccine
              Navigator.pop(context);
            },
            child: Text('Book Vaccine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No vaccines scheduled for this date.')),
    );
  }
},

      ),
    );
  }
}

class VaccineDataSource extends CalendarDataSource {
  VaccineDataSource(List<Appointment> source) {
    appointments = source;
  }
}

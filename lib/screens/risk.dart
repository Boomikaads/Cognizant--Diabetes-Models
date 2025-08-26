import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:open_filex/open_filex.dart';


class RiskPredictionScreen extends StatefulWidget {
  @override
  State<RiskPredictionScreen> createState() => _RiskPredictionScreenState();
}

class _RiskPredictionScreenState extends State<RiskPredictionScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final ApiClient api = ApiClient();

  List<Map<String, dynamic>> familyMembers = [];
  int selectedIndex = 0;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController cholesterolController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController hba1cController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController diabetesPedigreeController = TextEditingController();
  final TextEditingController poorHealthDaysController = TextEditingController();
  final TextEditingController maxHeartRateController = TextEditingController();

  // Binary features
  int smoking = 0;
  int alcohol = 0;
  int familyHistory = 0;
  int physicalActivity = 0;
  int sodiumIntake = 0;
  int fruit = 0;
  int veggies = 0;
  int stroke = 0;
  int fastingBloodSugar = 0;

  PredictResponse? prediction;
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchFamilyMembers();
  }

  Future<void> fetchFamilyMembers() async {
    try {
      final qs = await FirebaseFirestore.instance
          .collection('patients')
          .where('userId', isEqualTo: userId)
          .get();

      if (qs.docs.isNotEmpty) {
        setState(() {
          familyMembers = qs.docs.map((d) => {"id": d.id, ...d.data()}).toList();
        });
      }
    } catch (e) {
      setState(() => error = "Error fetching members: $e");
    }
  }
Map<String, dynamic> _buildPatientRecord() {
  final selected = familyMembers[selectedIndex];
  final systolic = double.tryParse(systolicController.text) ?? 0;
  final diastolic = double.tryParse(diastolicController.text) ?? 0;

  // 🔹 Gender conversion (string -> int)
  int genderValue = 0; // default female
  if (selected["gender"] is String) {
    final g = (selected["gender"] as String).toLowerCase();
    if (g == "male") genderValue = 1;
    if (g == "female") genderValue = 0;
  } else if (selected["gender"] is int) {
    genderValue = selected["gender"];
  }

  return {
     "patient_id": selected["id"],         // ✅ required by FastAPI
    "name": selected["name"] ?? "Patient", // ✅ required by FastAPI
    "age": selected["age"] ?? 0,
    "gender": genderValue, // ✅ always int now
    "systolic": systolic,
    "diastolic": diastolic,
    "blood_pressure": systolic + diastolic,
    "cholesterol": double.tryParse(cholesterolController.text) ?? 0,
    "bmi": double.tryParse(bmiController.text) ?? 0,
    "glucose": double.tryParse(glucoseController.text) ?? 0,
    "HbA1c": double.tryParse(hba1cController.text) ?? 0,
    "insulin": double.tryParse(insulinController.text) ?? 0,
    "heart_rate": double.tryParse(heartRateController.text) ?? 0,
    "smoking": smoking,
    "alcohol": alcohol,
    "family_history": familyHistory,
    "physical_activity": physicalActivity,
    "sodium_intake": sodiumIntake,
    "fruit": fruit,
    "veggies": veggies,
    "stroke": stroke,
    "fasting_blood_sugar": fastingBloodSugar,
    "diabetes_pedigree": double.tryParse(diabetesPedigreeController.text) ?? 0,
    "poor_health_days": int.tryParse(poorHealthDaysController.text) ?? 0,
    "max_heart_rate": int.tryParse(maxHeartRateController.text) ?? 0,
  };
}


  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final resp = await api.predict(_buildPatientRecord());
      setState(() => prediction = resp);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  Widget yesNoToggle(String label, int value, void Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(value: value == 1, onChanged: (v) => onChanged(v ? 1 : 0)),
      ],
    );
  }

  Color _riskColor(String label) {
    switch (label.toUpperCase()) {
      case "VERY HIGH": return Colors.red;
      case "HIGH": return Colors.orange;
      case "MEDIUM": return Colors.amber;
      default: return Colors.green;
    }
  }

  Widget _riskChip(String title, RiskItem item) {
    return Chip(
      label: Text("$title: ${item.riskLabel} (${item.probability.toStringAsFixed(2)})"),
      backgroundColor: _riskColor(item.riskLabel).withOpacity(0.15),
      side: BorderSide(color: _riskColor(item.riskLabel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Risk Prediction")),
      body: familyMembers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButton<int>(
                    value: selectedIndex,
                    items: familyMembers.asMap().entries.map((e) =>
                      DropdownMenuItem(value: e.key, child: Text(e.value["name"] ?? "Unknown"))
                    ).toList(),
                    onChanged: (v) => setState(() => selectedIndex = v!),
                  ),

                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: systolicController,
                          decoration: const InputDecoration(labelText: "Systolic"),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v==null || v.isEmpty) ? "Required" : null,
                        ),
                        TextFormField(
                          controller: diastolicController,
                          decoration: const InputDecoration(labelText: "Diastolic"),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v==null || v.isEmpty) ? "Required" : null,
                        ),
                        TextFormField(
                          controller: cholesterolController,
                          decoration: const InputDecoration(labelText: "Cholesterol"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: bmiController,
                          decoration: const InputDecoration(labelText: "BMI"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: glucoseController,
                          decoration: const InputDecoration(labelText: "Glucose"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: hba1cController,
                          decoration: const InputDecoration(labelText: "HbA1c"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: insulinController,
                          decoration: const InputDecoration(labelText: "Insulin"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: heartRateController,
                          decoration: const InputDecoration(labelText: "Heart Rate"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: diabetesPedigreeController,
                          decoration: const InputDecoration(labelText: "Diabetes Pedigree"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: poorHealthDaysController,
                          decoration: const InputDecoration(labelText: "Poor Health Days"),
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: maxHeartRateController,
                          decoration: const InputDecoration(labelText: "Max Heart Rate"),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 12),
                        yesNoToggle("Smoking", smoking, (v) => setState(() => smoking = v)),
                        yesNoToggle("Alcohol", alcohol, (v) => setState(() => alcohol = v)),
                        yesNoToggle("Family History", familyHistory, (v) => setState(() => familyHistory = v)),
                        yesNoToggle("Physical Activity", physicalActivity, (v) => setState(() => physicalActivity = v)),
                        yesNoToggle("Sodium Intake", sodiumIntake, (v) => setState(() => sodiumIntake = v)),
                        yesNoToggle("Fruit", fruit, (v) => setState(() => fruit = v)),
                        yesNoToggle("Veggies", veggies, (v) => setState(() => veggies = v)),
                        yesNoToggle("Stroke", stroke, (v) => setState(() => stroke = v)),
                        yesNoToggle("Fasting Blood Sugar", fastingBloodSugar, (v) => setState(() => fastingBloodSugar = v)),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : _predict,
                            child: loading ? const CircularProgressIndicator() : const Text("Predict Risk"),
                          ),
                        ),

                        if (error != null) ...[
                          const SizedBox(height: 12),
                          Text(error!, style: const TextStyle(color: Colors.red)),
                        ],

                        if (prediction != null) ...[
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _riskChip("Diabetes", prediction!.predictions["diabetes_status"]!),
                                _riskChip("Heart Disease", prediction!.predictions["heart_disease"]!),
                                _riskChip("Hypertension", prediction!.predictions["hypertension_status"]!),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Personalized Care Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(prediction!.carePlan),

                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text("Download PDF"),
                              onPressed: () async {
  try {
    // Download PDF bytes from API
    final response = await http.get(Uri.parse(prediction!.pdfUrl));

    if (response.statusCode == 200) {
  // ✅ Use system temp directory (no path_provider needed)
  final dir = Directory.systemTemp;
  final file = File("${dir.path}/care_plan_${prediction!.patientId}.pdf");

  // Save file
  await file.writeAsBytes(response.bodyBytes);

  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("✅ PDF saved at: ${file.path}")),
  );

  // Optionally open PDF directly
  await OpenFilex.open(file.path);

} else {
  throw Exception("Failed to download PDF (status ${response.statusCode})");
}

  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Download failed: $e")),
    );
  }
}

                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

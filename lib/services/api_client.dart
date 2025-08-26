import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';

class RiskItem {
  final double probability;
  final String riskLabel;
  final String riskDescription;

  RiskItem({required this.probability, required this.riskLabel, required this.riskDescription});

  factory RiskItem.fromJson(Map<String, dynamic> j) => RiskItem(
    probability: (j['probability'] as num).toDouble(),
    riskLabel: j['risk_label'] as String,
    riskDescription: j['risk_description'] as String,
  );
}

class PredictResponse {
  final String patientId;
  final Map<String, RiskItem> predictions;
  final String carePlan;
  final String pdfUrl;

  PredictResponse({required this.patientId,required this.predictions, required this.carePlan, required this.pdfUrl});

  factory PredictResponse.fromJson(Map<String, dynamic> j) {
    final preds = <String, RiskItem>{};
    (j['predictions'] as Map<String, dynamic>).forEach((k, v) {
      preds[k] = RiskItem.fromJson(v as Map<String, dynamic>);
    });
    return PredictResponse(
       patientId: j['patient_id'] as String? ?? "",  // ✅ add this
      predictions: preds,
      carePlan: j['care_plan']?.toString() ?? "",
      pdfUrl: j['pdf_url']?.toString() ?? "",
    );
  }
}

class ApiClient {
  final String baseUrl;

  ApiClient._(this.baseUrl);

  /// Use correct base URL per platform
  factory ApiClient() {
    if (kIsWeb) {
      return ApiClient._("http://localhost:8000");
    }
    if (Platform.isAndroid) {
      // Android emulator -> host machine
      return ApiClient._("http://192.168.1.8:8000");
      
    }
    // iOS simulator or desktop
    return ApiClient._("http://127.0.0.1:8000");
  }

  Future<PredictResponse> predict(Map<String, dynamic> patientRecord) async {
    final uri = Uri.parse("$baseUrl/predict");
    final resp = await http.post(uri, headers: {"Content-Type": "application/json"}, body: jsonEncode(patientRecord));
    if (resp.statusCode == 200) {
      return PredictResponse.fromJson(jsonDecode(resp.body));
    }
    throw Exception("Predict failed: ${resp.statusCode} ${resp.body}");
  }

  /// Downloads the generated PDF to device and opens it
  Future<File> downloadPdf(String pdfUrlPath, {required String baseUrl}) async {
  // Ensure correct full URL
  final url = pdfUrlPath.startsWith("http")
      ? pdfUrlPath
      : "$baseUrl${pdfUrlPath.startsWith('/') ? '' : '/'}$pdfUrlPath";

  // Debug print to confirm full download URL
  print("📥 Downloading PDF from: $url");

  final resp = await http.get(Uri.parse(url));
  if (resp.statusCode != 200) {
    throw Exception("PDF download failed: ${resp.statusCode} -> ${resp.body}");
  }

  // 👇 Use system temp directory instead of path_provider
  final dir = Directory.systemTemp;
  final file = File(
    "${dir.path}/care_plan_${DateTime.now().millisecondsSinceEpoch}.pdf",
  );

  await file.writeAsBytes(resp.bodyBytes);

  print("✅ PDF saved at: ${file.path}");

  await OpenFilex.open(file.path);

  return file;
}




}

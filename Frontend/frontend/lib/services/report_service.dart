import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/report_model.dart';
import '../config/api_config.dart';
import 'token_storage.dart';

class ReportService {
  final TokenStorage _tokenStorage;

  ReportService(this._tokenStorage);

  Future<String> _imageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      throw Exception('Failed to convert image to base64: $e');
    }
  }

  Future<ReportModel> createReport({
    required File imageFile,
    required String topic,
    required String lokasi,
    required int userId,
  }) async {
    final token = await _tokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    // Convert image to base64
    final base64Image = await _imageToBase64(imageFile);

    final reportData = {
      'gambar': base64Image,
      'topic': topic,
      'lokasi': lokasi,
      'status': 'UNDONE',
      'user': userId,
    };

    final response = await http
        .post(
          Uri.parse('${ApiConfig.baseUrl}/laporan/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(reportData),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReportModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to create report: ${response.statusCode} ${response.body}');
    }
  }
}

import 'dart:io';
import '../model/report_model.dart';
import '../services/report_service.dart';

class ReportRepository {
  final ReportService _reportService;

  ReportRepository(this._reportService);

  Future<ReportModel> createReport({
    required File imageFile,
    required String topic,
    required String lokasi,
    required int userId,
  }) async {
    return await _reportService.createReport(
      imageFile: imageFile,
      topic: topic,
      lokasi: lokasi,
      userId: userId,
    );
  }
}

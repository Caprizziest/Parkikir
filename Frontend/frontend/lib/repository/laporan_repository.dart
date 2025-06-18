import '../model/report_model.dart';
import '../services/laporan_service.dart';

class LaporanRepository {
  final LaporanService _laporanService;

  LaporanRepository(this._laporanService);

  Future<List<ReportModel>> getAllLaporan() async {
    return await _laporanService.getAllLaporan();
  }

  Future<ReportModel> getLaporanById(int id) async {
    return await _laporanService.getLaporanById(id);
  }
}

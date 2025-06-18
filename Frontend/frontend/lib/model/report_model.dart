class ReportModel {
  final int? id;
  final String? gambar; // Changed to nullable since it can be null from API
  final String topic;
  final String? lokasi;
  final String status; // "DONE" or "UNDONE"
  final DateTime? tanggal;
  final int user;

  ReportModel({
    this.id,
    this.gambar, // Changed to nullable
    required this.topic,
    this.lokasi,
    required this.status,
    this.tanggal,
    required this.user,
  });
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing ReportModel from JSON: $json'); // Debug logging

      // Safe parsing with detailed error handling
      int? id;
      try {
        id = json['id'] as int?;
      } catch (e) {
        print('Error parsing id: $e');
        id = null;
      }
      String? gambar;
      try {
        gambar = json['gambar'] as String?;
        if (gambar != null && gambar.isNotEmpty) {
          print('Gambar field found, length: ${gambar.length}');
          print(
              'Gambar preview: ${gambar.length > 50 ? gambar.substring(0, 50) : gambar}...');
        } else {
          print('Gambar field is null or empty');
        }
      } catch (e) {
        print('Error parsing gambar: $e');
        gambar = null;
      }

      String topic;
      try {
        topic = json['topic'] as String? ?? '';
      } catch (e) {
        print('Error parsing topic: $e');
        topic = '';
      }

      String? lokasi;
      try {
        lokasi = json['lokasi'] as String?;
      } catch (e) {
        print('Error parsing lokasi: $e');
        lokasi = null;
      }

      String status;
      try {
        status = json['status'] as String? ?? 'UNDONE';
      } catch (e) {
        print('Error parsing status: $e');
        status = 'UNDONE';
      }

      DateTime? tanggal;
      try {
        if (json['tanggal'] != null) {
          tanggal = DateTime.tryParse(json['tanggal'].toString());
        }
      } catch (e) {
        print('Error parsing tanggal: $e');
        tanggal = null;
      }

      int user;
      try {
        user = json['user'] as int? ?? 0;
      } catch (e) {
        print('Error parsing user: $e');
        user = 0;
      }

      return ReportModel(
        id: id,
        gambar: gambar,
        topic: topic,
        lokasi: lokasi,
        status: status,
        tanggal: tanggal,
        user: user,
      );
    } catch (e, stackTrace) {
      print('Error in ReportModel.fromJson: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gambar': gambar,
      'topic': topic,
      'lokasi': lokasi,
      'status': status,
      'tanggal': tanggal?.toIso8601String(),
      'user': user,
    };
  }
}

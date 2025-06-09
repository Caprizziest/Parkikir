class ReportModel {
  final int? id;
  final String gambar; //saved as base64 in the database
  final String topic;
  final String? lokasi;
  final String status; // "DONE" or "UNDONE"
  final DateTime? tanggal;
  final int user;

  ReportModel({
    this.id,
    required this.gambar,
    required this.topic,
    this.lokasi,
    required this.status,
    this.tanggal,
    required this.user,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as int?,
      gambar: json['gambar'] as String,
      topic: json['topic'] as String,
      lokasi: json['lokasi'] as String?,
      status: json['status'] as String,
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'] as String)
          : null,
      user: json['user'] as int,
    );
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

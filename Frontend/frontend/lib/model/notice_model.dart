class NoticeModel {
  final int noticeId;
  final String tanggal;
  final String event;
  final String judul;
  final String? description;

  NoticeModel({
    required this.noticeId,
    required this.tanggal,
    required this.event,
    required this.judul,
    this.description,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeId: json['noticeid'] as int,
      tanggal: json['tanggal'] as String,
      event: json['event'] as String,
      judul: json['judul'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noticeid': noticeId,
      'tanggal': tanggal,
      'event': event,
      'judul': judul,
      'description': description,
    };
  }

  // Helper method untuk parsing tanggal jika diperlukan
  DateTime? get parsedDate {
    try {
      // Assuming tanggal is in format like "15 - 19 Mei 2025" or similar
      // You might need to adjust this parsing logic based on your actual date format
      return DateTime.tryParse(tanggal);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'Notice $noticeId - $judul';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoticeModel &&
        other.noticeId == noticeId &&
        other.tanggal == tanggal &&
        other.event == event &&
        other.judul == judul &&
        other.description == description;
  }

  @override
  int get hashCode {
    return noticeId.hashCode ^
        tanggal.hashCode ^
        event.hashCode ^
        judul.hashCode ^
        description.hashCode;
  }
}
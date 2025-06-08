import "parkiran_tertutup_model.dart";

class NoticeModel {
  final int noticeId;
  final String tanggal;
  final String event;
  final String judul;
  final String description;
  final List<ParkiranTertutup>? parkiranTertutup;

  NoticeModel({
    required this.noticeId,
    required this.tanggal,
    required this.event,
    required this.judul,
    required this.description,
    this.parkiranTertutup,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeId: json['noticeid'] as int,
      tanggal: json['tanggal'] as String,
      event: json['event'] as String,
      judul: json['judul'] as String,
      description: json['description'] ?? '',
      parkiranTertutup: json['parkiran_tertutup'] != null
          ? (json['parkiran_tertutup'] as List)
              .map((item) => ParkiranTertutup.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noticeid': noticeId,
      'tanggal': tanggal,
      'event': event,
      'judul': judul,
      'description': description,
      'parkiran_tertutup':
          parkiranTertutup?.map((item) => item.toJson()).toList(),
    };
  }

  bool get hasClosedParking =>
      parkiranTertutup != null && parkiranTertutup!.isNotEmpty;

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

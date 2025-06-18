import "parkiran_tertutup_model.dart";

class NoticeModel {
  final int noticeId;
  final DateTime dateFrom;
  final DateTime dateUntil;
  final String event;
  final String judul;
  final String description;
  final List<ParkiranTertutup>? parkiranTertutup;

  NoticeModel({
    required this.noticeId,
    required this.dateFrom,
    required this.dateUntil,
    required this.event,
    required this.judul,
    required this.description,
    this.parkiranTertutup,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeId: json['noticeid'] as int, // Dihapus '?'
      dateFrom: DateTime.parse(json['tanggalfrom']
          as String), // Sesuaikan dengan nama field di backend
      dateUntil: DateTime.parse(json['tanggaluntil']
          as String), // Sesuaikan dengan nama field di backend
      event: json['event'] as String,
      judul: json['judul'] as String,
      description: json['description'] as String? ??
          '', // description bisa null di backend
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
      'tanggalfrom':
          dateFrom.toIso8601String(), // Sesuaikan dengan nama field di backend
      'tanggaluntil':
          dateUntil.toIso8601String(), // Sesuaikan dengan nama field di backend
      'event': event,
      'judul': judul,
      'description': description,
      'parkiran_tertutup':
          parkiranTertutup?.map((item) => item.toJson()).toList(),
    };
  }

  bool get hasClosedParking =>
      parkiranTertutup != null && parkiranTertutup!.isNotEmpty;

  @override
  String toString() {
    return 'Notice $noticeId - $judul';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoticeModel &&
        other.noticeId == noticeId &&
        other.dateFrom == dateFrom &&
        other.dateUntil == dateUntil &&
        other.event == event &&
        other.judul == judul &&
        other.description == description;
  }

  @override
  int get hashCode {
    return noticeId.hashCode ^
        dateFrom.hashCode ^
        dateUntil.hashCode ^
        event.hashCode ^
        judul.hashCode ^
        description.hashCode;
  }
}

class NoticeCreateModel {
  final DateTime dateFrom;
  final DateTime dateUntil;
  final String event;
  final String judul;
  final String description;

  NoticeCreateModel({
    required this.dateFrom,
    required this.dateUntil,
    required this.event,
    required this.judul,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'tanggalfrom': dateFrom.toIso8601String(),
      'tanggaluntil': dateUntil.toIso8601String(),
      'event': event,
      'judul': judul,
      'description': description,
    };
  }
}

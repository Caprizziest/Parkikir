import "slot_parkir_model.dart";

class ParkiranTertutup {
  final int id;
  final SlotParkir slotparkir;
  final int noticeId;

  ParkiranTertutup({
    required this.id,
    required this.slotparkir,
    required this.noticeId,
  });

  factory ParkiranTertutup.fromJson(Map<String, dynamic> json) {
    return ParkiranTertutup(
      id: json['id'] ?? 0,
      slotparkir: SlotParkir.fromJson(json['slotparkir'] ?? {}),
      noticeId: json['notice'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slotparkir': slotparkir.toJson(),
      'notice': noticeId,
    };
  }
}

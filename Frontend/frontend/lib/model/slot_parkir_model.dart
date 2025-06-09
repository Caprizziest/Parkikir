class SlotParkir {
  final String slotparkirid;
  final String status;

  SlotParkir({
    required this.slotparkirid,
    required this.status,
  });

  factory SlotParkir.fromJson(Map<String, dynamic> json) {
    return SlotParkir(
      slotparkirid: json['slotparkirid'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slotparkirid': slotparkirid,
      'status': status,
    };
  }

  // Helper method untuk mengecek apakah slot tersedia
  bool get isAvailable =>
      status.toLowerCase() == 'available' || status.toLowerCase() == 'kosong';

  // Helper method untuk mendapatkan display name
  String get displayName => slotparkirid;
}

// booking_model.dart
class BookingModel {
  final int id;
  final String slotId;
  final int userId;
  final String status;
  final DateTime createdAt;
  final double totalPrice;
  final String description;
  final DateTime bookingDate;

  BookingModel({
    required this.id,
    required this.slotId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.totalPrice,
    required this.description,
    required this.bookingDate,

  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? -1,
      slotId: json['slot_id'] ?? '',
      userId: json['user_id'] ?? -1,
      status: json['status'] ?? 'UNKNOWN',
      createdAt: DateTime.parse(json['created_at']),
      totalPrice: json['total_price']?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      bookingDate: DateTime.parse(
      json['bookingDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'id': id,
    'slotparkir': slotId, // renamed from slot_id
    'user': userId,       // renamed from user_id
    'tanggal': bookingDate.toIso8601String().split('T')[0], // YYYY-MM-DD
    'status': status,
    'totalharga': totalPrice.toInt(), // send as integer
    };
  }
}

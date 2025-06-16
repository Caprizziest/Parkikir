class BookingModel {
  final String slotId;
  final String description;
  final DateTime bookingDate;
  final String status;

  BookingModel({
    required this.slotId,
    required this.description,
    required this.bookingDate,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      slotId: json['slotId'] ?? '',
      description: json['description'] ?? '',
      bookingDate: DateTime.parse(
          json['bookingDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'booked',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slotId': slotId,
      'description': description,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }
}

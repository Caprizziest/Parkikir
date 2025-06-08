
class PaymentModel {
  final String token;
  final String redirectUrl;
  final int orderId;
  final int totalHarga;

  PaymentModel({
    required this.token,
    required this.redirectUrl,
    required this.orderId,
    required this.totalHarga,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      token: json['token'],
      redirectUrl: json['redirect_url'],
      orderId: json['order_id'],
      totalHarga: json['totalharga'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'redirect_url': redirectUrl,
      'order_id': orderId,
      'totalharga': totalHarga,
    };
  }
}
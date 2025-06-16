// payment_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/payment_service.dart';
import '../repository/payment_repository.dart';
import '../model/payment_model.dart';

// Payment state enum
enum PaymentState {
  initial,
  loading,
  success,
  error,
}

// Payment state class
class PaymentViewState {
  final PaymentState state;
  final PaymentModel? paymentData;
  final String? errorMessage;
  final bool isProcessing;

  const PaymentViewState({
    this.state = PaymentState.initial,
    this.paymentData,
    this.errorMessage,
    this.isProcessing = false,
  });

  PaymentViewState copyWith({
    PaymentState? state,
    PaymentModel? paymentData,
    String? errorMessage,
    bool? isProcessing,
  }) {
    return PaymentViewState(
      state: state ?? this.state,
      paymentData: paymentData ?? this.paymentData,
      errorMessage: errorMessage ?? this.errorMessage,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

// Payment ViewModel
class PaymentViewModel extends StateNotifier<PaymentViewState> {
  final PaymentRepository paymentRepository;

  PaymentViewModel({required this.paymentRepository}) 
      : super(const PaymentViewState());

  // Create payment
  Future<void> createPayment(int bookingId, int userId) async {
    state = state.copyWith(
      state: PaymentState.loading,
      isProcessing: true,
    );

    try {
      final result = await paymentRepository.createPayment(bookingId, userId);
      
      if (result['success'] == true) {
        final paymentData = PaymentModel(
          token: result['token'],
          redirectUrl: result['redirect_url'],
          orderId: result['order_id'],
          totalHarga: result['totalharga'],
        );

        state = state.copyWith(
          state: PaymentState.success,
          paymentData: paymentData,
          isProcessing: false,
        );
      } else {
        state = state.copyWith(
          state: PaymentState.error,
          errorMessage: result['message'] ?? 'Payment creation failed',
          isProcessing: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        state: PaymentState.error,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
        isProcessing: false,
      );
    }
  }

  // Reset state
  void resetState() {
    state = const PaymentViewState();
  }

  // Retry payment creation
  Future<void> retryPayment(int bookingId, int userId) async {
    await createPayment(bookingId, userId);
  }
}

// Providers
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final paymentService = ref.watch(paymentServiceProvider);
  return PaymentRepository(paymentService: paymentService);
});

final paymentViewModelProvider = StateNotifierProvider<PaymentViewModel, PaymentViewState>((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return PaymentViewModel(paymentRepository: paymentRepository);
});

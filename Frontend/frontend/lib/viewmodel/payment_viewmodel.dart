// payment_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/payment_service.dart';
import '../services/booking_service.dart';
import '../services/token_service.dart';
import '../repository/payment_repository.dart';
import '../repository/booking_repository.dart';
import '../model/payment_model.dart';
import '../model/booking_model.dart';

// Payment state enum
enum PaymentState {
  initial,
  creatingBooking,
  processingPayment,
  success,
  error,
}

// Payment state class
class PaymentViewState {
  final PaymentState state;
  final BookingModel? booking;
  final PaymentModel? paymentData;
  final String? errorMessage;
  final bool isProcessing;

  const PaymentViewState({
    this.state = PaymentState.initial,
    this.booking,
    this.paymentData,
    this.errorMessage,
    this.isProcessing = false,
  });

  PaymentViewState copyWith({
    PaymentState? state,
    BookingModel? booking,
    PaymentModel? paymentData,
    String? errorMessage,
    bool? isProcessing,
  }) {
    return PaymentViewState(
      state: state ?? this.state,
      booking: booking ?? this.booking,
      paymentData: paymentData ?? this.paymentData,
      errorMessage: errorMessage ?? this.errorMessage,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

// Payment ViewModel
class PaymentViewModel extends StateNotifier<PaymentViewState> {
  final BookingRepository bookingRepository;
  final PaymentRepository paymentRepository;

  PaymentViewModel({
    required this.bookingRepository,
    required this.paymentRepository,
  }) : super(const PaymentViewState());

  // Create booking and then payment
  Future<void> createBookingAndPayment({
    required String slotId,
    required double totalPrice,
  }) async {
    // Step 1: Create booking
    state = state.copyWith(
      state: PaymentState.creatingBooking,
      isProcessing: true,
    );

    try {
      final bookingResult = await bookingRepository.createBooking(
        slotId: slotId,
        totalPrice: totalPrice,
      );

      if (bookingResult['success'] != true) {
        state = state.copyWith(
          state: PaymentState.error,
          errorMessage: bookingResult['message'] ?? 'Failed to create booking',
          isProcessing: false,
        );
        return;
      }

      final booking = bookingResult['booking'] as BookingModel;

      state = state.copyWith(
        booking: booking,
        state: PaymentState.processingPayment,
      );

      // Step 2: Create payment
      final paymentResult = await paymentRepository.createPayment(
        booking.id,
        booking.userId,
      );

      if (paymentResult['success'] == true) {
        final paymentData = PaymentModel(
          token: paymentResult['token'],
          redirectUrl: paymentResult['redirect_url'],
          orderId: paymentResult['order_id'],
          totalHarga: paymentResult['totalharga'],
        );

        state = state.copyWith(
          state: PaymentState.success,
          paymentData: paymentData,
          isProcessing: false,
        );
      } else {
        state = state.copyWith(
          state: PaymentState.error,
          errorMessage: paymentResult['message'] ?? 'Payment creation failed',
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

  // Retry the entire process
  Future<void> retryBookingAndPayment({
    required String slotId,
    required double totalPrice,
  }) async {
    await createBookingAndPayment(
      slotId: slotId,
      totalPrice: totalPrice,
    );
  }
}

// Providers
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService();
});

final bookingServiceProvider = Provider<BookingService>((ref) {
  final tokenService = ref.watch(tokenServiceProvider);
  return BookingService(tokenService: tokenService);
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final bookingService = ref.watch(bookingServiceProvider);
  return BookingRepository(bookingService: bookingService);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final paymentService = ref.watch(paymentServiceProvider);
  return PaymentRepository(paymentService: paymentService);
});

final paymentViewModelProvider = StateNotifierProvider<PaymentViewModel, PaymentViewState>((ref) {
  final bookingRepository = ref.watch(bookingRepositoryProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return PaymentViewModel(
    bookingRepository: bookingRepository,
    paymentRepository: paymentRepository,
  );
});

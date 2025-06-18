import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:url_launcher/url_launcher.dart'; // Commented out since not needed now
import '../viewmodel/payment_viewmodel.dart';

class PaymentView extends ConsumerStatefulWidget {
  final String selectedSpot;
  final double price;

  const PaymentView({
    super.key,
    required this.selectedSpot,
    required this.price,
  });

  @override
  ConsumerState<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends ConsumerState<PaymentView> {
  @override
  void initState() {
    super.initState();
    // Reset payment state when entering the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentViewModelProvider.notifier).resetState();
    });
  }

  void _handlePayment() {
    ref.read(paymentViewModelProvider.notifier).createBookingAndPayment(
      slotId: widget.selectedSpot,
      totalPrice: widget.price,
    );
  }

  // 🚫 Temporarily disabled since real payment is not being used
  // void _handlePaymentSuccess(String redirectUrl) async {
  //   try {
  //     final uri = Uri.parse(redirectUrl);
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.externalApplication);
  //     } else {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Could not launch payment URL'),
  //             backgroundColor: Colors.red,
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error launching payment: ${e.toString()}'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  String _getStateMessage(PaymentState state) {
    switch (state) {
      case PaymentState.creatingBooking:
        return 'Creating booking...';
      case PaymentState.processingPayment:
        return 'Updating slot status...';
      default:
        return 'Processing...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentViewModelProvider);

    // Listen to state changes for navigation
    ref.listen<PaymentViewState>(paymentViewModelProvider, (previous, next) {
      if (next.state == PaymentState.success && next.paymentData != null) {
        // 🚫 Skip redirect if not using real payment
        // _handlePaymentSuccess(next.paymentData!.redirectUrl);

        // ✅ Instead, go directly to dashboard
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking confirmed! Slot is now unavailable.'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/success');
        });
      } else if (next.state == PaymentState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Operation failed'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _handlePayment(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Location', 'Parkiran Mobil UC'),
                  _buildSummaryRow('Parking Spot', widget.selectedSpot),
                  _buildSummaryRow(
                    'Price',
                    'Rp. ${widget.price.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (m) => '${m[1]}.')}',
                  ),
                  if (paymentState.booking != null) ...[
                    const SizedBox(height: 8),
                    _buildSummaryRow('Booking ID', '#${paymentState.booking!.id}'),
                    _buildSummaryRow('Status', paymentState.booking!.status.toUpperCase()),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Rp. ${widget.price.toStringAsFixed(0).replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (m) => '${m[1]}.')}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3C39F2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Payment Method Section
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF3C39F2),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Midtrans Payment Gateway',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF3C39F2),
                    size: 20,
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Process Status Indicator
            if (paymentState.isProcessing)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF3C39F2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getStateMessage(paymentState.state),
                      style: const TextStyle(
                        color: Color(0xFF3C39F2),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            // Error State
            if (paymentState.state == PaymentState.error)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        paymentState.errorMessage ?? 'Operation failed',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Payment Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: paymentState.isProcessing ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C39F2),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: paymentState.isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Book & Proceed to Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/order/presentation/view/user_order_screen.dart';
import 'package:agrix/features/users/payment/presentation/state/user_payment_state.dart';
import 'package:agrix/features/users/payment/presentation/viewmodel/user_payment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends ConsumerStatefulWidget {
  final String paymentUrl;
  final String orderId;
  final String pidx;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.orderId,
    required this.pidx,
  });

  @override
  ConsumerState<PaymentWebViewScreen> createState() =>
      _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends ConsumerState<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isPaymentComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
                print('🌐 Page started: $url');

                // Check if we're being redirected back to the web app
                if (url.contains('localhost:3000/auth/payment/verify') ||
                    url.contains('yourdomain.com/auth/payment/verify')) {
                  // Parse the URL to get parameters
                  final uri = Uri.parse(url);
                  final pidx = uri.queryParameters['pidx'];
                  final orderId = uri.queryParameters['purchase_order_id'];
                  final status = uri.queryParameters['status'];

                  print(
                    '📱 Redirect detected - pidx: $pidx, orderId: $orderId, status: $status',
                  );

                  if (status == 'Completed' &&
                      pidx != null &&
                      orderId != null) {
                    _handlePaymentSuccess(pidx, orderId);
                  } else if (status == 'Failed' || status == 'Cancelled') {
                    _handlePaymentFailure();
                  }
                }
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
                print('✅ Page finished: $url');
              },
              onNavigationRequest: (NavigationRequest request) {
                print('🧭 Navigation request: ${request.url}');

                // Alternative way to detect redirect
                if (request.url.contains(
                      'localhost:3000/auth/payment/verify',
                    ) ||
                    request.url.contains(
                      'yourdomain.com/auth/payment/verify',
                    )) {
                  final uri = Uri.parse(request.url);
                  final pidx = uri.queryParameters['pidx'];
                  final orderId = uri.queryParameters['purchase_order_id'];
                  final status = uri.queryParameters['status'];

                  if (status == 'Completed' &&
                      pidx != null &&
                      orderId != null) {
                    _handlePaymentSuccess(pidx, orderId);
                  } else if (status == 'Failed' || status == 'Cancelled') {
                    _handlePaymentFailure();
                  }

                  // Prevent loading the web app page in WebView
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> _handlePaymentSuccess(String pidx, String orderId) async {
    if (_isPaymentComplete) return;
    _isPaymentComplete = true;

    print('💰 Payment successful - verifying...');

    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showErrorAndPop('Authentication required');
      return;
    }

    // Show loading dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            ),
      );
    }

    await ref
        .read(userPaymentViewModelProvider.notifier)
        .verifyKhaltiPayment(token: token, pidx: pidx, orderId: orderId);

    // Dismiss loading dialog
    if (mounted) {
      Navigator.pop(context); // Dismiss dialog
    }
  }

  void _handlePaymentFailure() {
    if (_isPaymentComplete) return;
    _isPaymentComplete = true;

    print('❌ Payment failed or cancelled');

    showSnackBar(
      context: context,
      message: 'Payment failed or cancelled',
      isSuccess: false,
    );
    Navigator.pop(context);
  }

  void _showErrorAndPop(String message) {
    showSnackBar(context: context, message: message, isSuccess: false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UserPaymentState>(userPaymentViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == UserPaymentViewStatus.success) {
        // Payment verification successful
        if (mounted) {
          showSnackBar(
            context: context,
            message: 'Payment successful! Order placed.',
            isSuccess: true,
          );

          // Use MaterialPageRoute with pushAndRemoveUntil
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const UserOrdersScreen()),
            (route) => route.isFirst,
          );
        }
      } else if (next.status == UserPaymentViewStatus.error &&
          next.errorMessage != null) {
        // Payment verification failed
        if (mounted) {
          showSnackBar(
            context: context,
            message: next.errorMessage!,
            isSuccess: false,
          );
          Navigator.pop(context); // Close WebView
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Khalti Payment',
          style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Cancel Payment'),
                    content: const Text('Are you sure you want to cancel?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.logoutRed,
                        ),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            ),
        ],
      ),
    );
  }
}

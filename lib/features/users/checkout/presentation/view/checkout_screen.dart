import 'dart:convert';

import 'package:agrix/app/theme/app_colors.dart';
import 'package:agrix/app/theme/app_styles.dart';
import 'package:agrix/core/api/api_endpoints.dart';
import 'package:agrix/core/services/storage/user_session_service.dart';
import 'package:agrix/core/utils/snackbar_utils.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/cart/presentation/state/cart_state.dart';
import 'package:agrix/features/users/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:agrix/features/users/checkout/domain/entity/checkout_entity.dart';
import 'package:agrix/features/users/checkout/presentation/view/widgets/address_step_widget.dart';
import 'package:agrix/features/users/checkout/presentation/view/widgets/payment_step_widget.dart';
import 'package:agrix/features/users/checkout/presentation/view/widgets/review_step_widget.dart';
import 'package:agrix/features/users/order/presentation/view/user_order_screen.dart';
import 'package:agrix/features/users/payment/presentation/state/user_payment_state.dart';
import 'package:agrix/features/users/payment/presentation/view/payment_webview_screen.dart';
import 'package:agrix/features/users/payment/presentation/viewmodel/user_payment_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum CheckoutStep { address, payment, review }

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  CheckoutStep _currentStep = CheckoutStep.address;
  bool _isLoading = true;
  bool _isProcessing = false;
  bool _isKhaltiProcessing = false;

  List<AddressEntity> _addresses = [];
  int _selectedAddressIndex = 0;
  bool _showNewAddressForm = false;

  final _newAddressFormKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  PaymentMethod _paymentMethod = PaymentMethod.cod;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCartAndSetup();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadCartAndSetup() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    await ref.read(cartViewModelProvider.notifier).getCart(token: token);

    final cartState = ref.read(cartViewModelProvider);
    if (cartState.cart != null) {
      _setupInitialAddress(cartState.cart!);
    }

    setState(() => _isLoading = false);
  }

  void _setupInitialAddress(CartEntity cart) {
    final userSession = ref.read(userSessionServiceProvider);
    final fullName = userSession.getCurrentUserFullName() ?? '';
    final phone = userSession.getCurrentUserPhoneNumber() ?? '';

    _addresses = [
      AddressEntity(
        fullName: fullName,
        phone: phone,
        addressLine1: '123 Main Street',
        city: 'Kathmandu',
        state: 'Bagmati',
        postalCode: '44600',
        isDefault: true,
      ),
    ];

    _fullNameController.text = fullName;
    _phoneController.text = phone;
  }

  void _showAuthError() {
    showSnackBar(
      context: context,
      message: 'Authentication required',
      isSuccess: false,
    );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  double _calculateSubtotal(CartEntity cart) {
    return cart.items.fold(0.0, (sum, item) => sum + item.itemTotal);
  }

  double _calculateTax(double subtotal) {
    return subtotal * 0.13;
  }

  double _calculateTotal(double subtotal, double tax) {
    return subtotal + tax;
  }

  void _addNewAddress() {
    if (_newAddressFormKey.currentState!.validate()) {
      final newAddress = AddressEntity(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine1: _addressLine1Controller.text.trim(),
        addressLine2:
            _addressLine2Controller.text.trim().isEmpty
                ? null
                : _addressLine2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        isDefault: false,
      );

      setState(() {
        _addresses.add(newAddress);
        _selectedAddressIndex = _addresses.length - 1;
        _showNewAddressForm = false;
      });

      _clearAddressForm();
    }
  }

  void _clearAddressForm() {
    _fullNameController.clear();
    _phoneController.clear();
    _addressLine1Controller.clear();
    _addressLine2Controller.clear();
    _cityController.clear();
    _stateController.clear();
    _postalCodeController.clear();
  }

  void _cancelNewAddress() {
    setState(() {
      _showNewAddressForm = false;
    });
    _clearAddressForm();
  }

  Future<Map<String, dynamic>?> _createOrder(String token) async {
    try {
      final cartState = ref.read(cartViewModelProvider);
      final cart = cartState.cart;
      if (cart == null) return null;

      final orderData = {
        'items':
            cart.items
                .map(
                  (item) => {
                    'product': item.productId,
                    'name': item.name,
                    'price': item.price,
                    'discount': item.discount,
                    'quantity': item.quantity,
                    'business': item.businessId,
                    if (item.image != null) 'image': item.image,
                  },
                )
                .toList(),
        'shippingAddress': {
          'fullName': _addresses[_selectedAddressIndex].fullName,
          'phone': _addresses[_selectedAddressIndex].phone,
          'addressLine1': _addresses[_selectedAddressIndex].addressLine1,
          if (_addresses[_selectedAddressIndex].addressLine2 != null)
            'addressLine2': _addresses[_selectedAddressIndex].addressLine2,
          'city': _addresses[_selectedAddressIndex].city,
          'state': _addresses[_selectedAddressIndex].state,
          'postalCode': _addresses[_selectedAddressIndex].postalCode,
        },
        'paymentMethod': _paymentMethod == PaymentMethod.cod ? 'cod' : 'khalti',
        // 'notes': _notesController.text, // Optional - add if you have a notes field
      };

      print('📤 Sending order data: ${jsonEncode(orderData)}');

      final response = await Dio().post(
        '${ApiEndpoints.baseUrl}/order',
        data: orderData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (response.data['success'] == true) {
          return response.data['order'];
        }
      }

      throw Exception(response.data['message'] ?? 'Failed to create order');
    } on DioException catch (e) {
      print('❌ DioError: ${e.message}');
      if (e.response != null) {
        print('🔴 Status: ${e.response?.statusCode}');
        print('🔴 Data: ${e.response?.data}');
      }
      return null;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<void> _handlePlaceOrder() async {
    setState(() => _isProcessing = true);

    if (_paymentMethod == PaymentMethod.cod) {
      await _handleCodOrder();
    } else {
      await _handleKhaltiPayment();
    }
  }

  Future<void> _handleCodOrder() async {
    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    try {
      final order = await _createOrder(token);

      if (order == null) {
        throw Exception('Failed to create order');
      }

      await ref.read(cartViewModelProvider.notifier).clearCart(token: token);

      setState(() => _isProcessing = false);

      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Order placed successfully!',
          isSuccess: true,
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UserOrdersScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      showSnackBar(
        context: context,
        message: 'Failed to place order: $e',
        isSuccess: false,
      );
    }
  }

  Future<void> _handleKhaltiPayment() async {
    if (_addresses.isEmpty) {
      showSnackBar(
        context: context,
        message: 'Please select a shipping address',
        isSuccess: false,
      );
      setState(() => _currentStep = CheckoutStep.address);
      return;
    }

    setState(() {
      _isKhaltiProcessing = true;
      _isProcessing = false;
    });

    final token = await ref.read(userSessionServiceProvider).getToken();
    if (token == null) {
      _showAuthError();
      return;
    }

    try {
      final order = await _createOrder(token);

      if (order == null) {
        throw Exception('Failed to create order');
      }

      final orderId = order['_id'];
      final total = order['total'].toDouble();
      final returnUrl = 'http://localhost:3000/auth/payment/verify';
      await ref
          .read(userPaymentViewModelProvider.notifier)
          .initiateKhaltiPayment(
            token: token,
            orderId: orderId,
            amount: total,
            returnUrl: returnUrl,
          );
    } catch (e) {
      setState(() {
        _isKhaltiProcessing = false;
      });
      showSnackBar(
        context: context,
        message: 'Failed to process payment: $e',
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartViewModelProvider);
    final cart = cartState.cart;

    ref.listen<UserPaymentState>(userPaymentViewModelProvider, (
      previous,
      next,
    ) {
      if (next.status == UserPaymentViewStatus.success &&
          next.initiatedPayment != null) {
        if (mounted) {
          setState(() {
            _isKhaltiProcessing = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PaymentWebViewScreen(
                    paymentUrl: next.initiatedPayment!.paymentUrl,
                    orderId: next.initiatedPayment!.orderId,
                    pidx: next.initiatedPayment!.pidx,
                  ),
            ),
          );
        }
      } else if (next.status == UserPaymentViewStatus.error) {
        if (mounted) {
          setState(() {
            _isKhaltiProcessing = false;
          });
          showSnackBar(
            context: context,
            message: next.errorMessage ?? 'Payment initiation failed',
            isSuccess: false,
          );
        }
      }
    });

    if (_isLoading || cartState.status == CartStatus.loading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      );
    }

    if (cart == null || cart.items.isEmpty) {
      return _buildEmptyCartView();
    }

    final subtotal = _calculateSubtotal(cart);
    final tax = _calculateTax(subtotal);
    final total = _calculateTotal(subtotal, tax);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildStepIndicator(),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildCurrentStep(cart)),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 1,
                          child: _buildOrderSummary(cart, subtotal, tax, total),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildCurrentStep(cart),
                        const SizedBox(height: 32),
                        _buildOrderSummary(cart, subtotal, tax, total),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textBlack,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCartView() {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: AppStyles.headline2.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Checkout', style: AppStyles.headline1.copyWith(fontSize: 32)),
        const SizedBox(height: 4),
        Text(
          'Please review your order and complete payment',
          style: AppStyles.bodyMedium.copyWith(color: AppColors.textGrey),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _stepItem(1, "Address", _currentStep == CheckoutStep.address, true),
        _stepLine(_currentStep != CheckoutStep.address),
        _stepItem(
          2,
          "Payment",
          _currentStep == CheckoutStep.payment,
          _currentStep != CheckoutStep.address,
        ),
        _stepLine(_currentStep == CheckoutStep.review),
        _stepItem(
          3,
          "Review",
          _currentStep == CheckoutStep.review,
          _currentStep == CheckoutStep.review,
        ),
      ],
    );
  }

  Widget _stepItem(int index, String label, bool isCurrent, bool isVisited) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color:
                isCurrent
                    ? AppColors.primaryGreen
                    : (isVisited
                        ? AppColors.primaryGreen.withOpacity(0.2)
                        : Colors.white),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCurrent ? AppColors.primaryGreen : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child:
                isVisited && !isCurrent
                    ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.primaryGreen,
                    )
                    : Text(
                      "$index",
                      style: AppStyles.caption.copyWith(
                        color: isCurrent ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppStyles.caption.copyWith(
            color: isCurrent ? AppColors.textBlack : AppColors.textGrey,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(bool active) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
        child: Container(
          height: 2,
          color: active ? AppColors.primaryGreen : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildCurrentStep(CartEntity cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: _getStepWidget(cart),
    );
  }

  Widget _getStepWidget(CartEntity cart) {
    switch (_currentStep) {
      case CheckoutStep.address:
        return AddressStepWidget(
          addresses: _addresses,
          selectedAddressIndex: _selectedAddressIndex,
          onAddressSelected:
              (index) => setState(() => _selectedAddressIndex = index),
          onContinue: () => setState(() => _currentStep = CheckoutStep.payment),
          showNewAddressForm: _showNewAddressForm,
          onAddNewAddress: () => setState(() => _showNewAddressForm = true),
          onCancelNewAddress: _cancelNewAddress,
          formKey: _newAddressFormKey,
          fullNameController: _fullNameController,
          phoneController: _phoneController,
          addressLine1Controller: _addressLine1Controller,
          addressLine2Controller: _addressLine2Controller,
          cityController: _cityController,
          stateController: _stateController,
          postalCodeController: _postalCodeController,
          onSaveAddress: _addNewAddress,
        );
      case CheckoutStep.payment:
        return PaymentStepWidget(
          selectedMethod: _paymentMethod,
          onMethodSelected: (method) => setState(() => _paymentMethod = method),
          onBack: () => setState(() => _currentStep = CheckoutStep.address),
          onContinue: () => setState(() => _currentStep = CheckoutStep.review),
        );
      case CheckoutStep.review:
        return ReviewStepWidget(
          cart: cart,
          address: _addresses[_selectedAddressIndex],
          paymentMethod: _paymentMethod,
          onBack: () => setState(() => _currentStep = CheckoutStep.payment),
          onPlaceOrder: _handlePlaceOrder,
          isProcessing: _isProcessing,
          isKhaltiProcessing: _isKhaltiProcessing,
        );
    }
  }

  Widget _buildOrderSummary(
    CartEntity cart,
    double subtotal,
    double tax,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.imagePlaceholderGrey, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Summary',
                style: AppStyles.bodyLarge.copyWith(fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${cart.totalItems} Items',
                  style: AppStyles.caption.copyWith(
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _summaryRow('Subtotal', _formatCurrency(subtotal), isLight: true),
          const SizedBox(height: 12),
          _summaryRow('VAT (13%)', _formatCurrency(tax), isLight: true),
          const SizedBox(height: 12),
          _summaryRow(
            'Shipping Fee',
            'Free',
            isLight: true,
            valueColor: Colors.green[700],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: AppColors.imagePlaceholderGrey, thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: AppStyles.caption.copyWith(fontSize: 13),
                  ),
                  Text(
                    _formatCurrency(total),
                    style: AppStyles.headline2.copyWith(
                      color: AppColors.primaryGreen,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.verified_user,
                color: AppColors.primaryGreen,
                size: 30,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.textLightGrey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Prices are inclusive of all taxes.',
                    style: AppStyles.caption.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isLight = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: isLight ? AppColors.textGrey : AppColors.textBlack,
          ),
        ),
        Text(
          value,
          style: AppStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textBlack,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: 'Rs. ',
      decimalDigits: 0,
    ).format(amount);
  }
}

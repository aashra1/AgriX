import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/checkout/domain/entity/checkout_entity.dart';
import 'package:agrix/features/users/checkout/presentation/view/widgets/address_step_widget.dart';
import 'package:agrix/features/users/checkout/presentation/view/widgets/payment_step_widget.dart';
import 'package:agrix/features/users/checkout/presentation/view/widgets/review_step_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));
}

void main() {
  group('PaymentStepWidget', () {
    testWidgets('1. renders payment title and both options', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PaymentStepWidget(
            selectedMethod: PaymentMethod.cod,
            onMethodSelected: (_) {},
            onBack: () {},
            onContinue: () {},
          ),
        ),
      );

      expect(find.text('Payment Method'), findsOneWidget);
      expect(find.text('Khalti Wallet'), findsOneWidget);
      expect(find.text('Cash on Delivery'), findsOneWidget);
      expect(find.text('FAST'), findsOneWidget);
    });

    testWidgets('2. tapping khalti calls onMethodSelected with khalti', (
      tester,
    ) async {
      PaymentMethod? selected;

      await tester.pumpWidget(
        _wrap(
          PaymentStepWidget(
            selectedMethod: PaymentMethod.cod,
            onMethodSelected: (method) => selected = method,
            onBack: () {},
            onContinue: () {},
          ),
        ),
      );

      await tester.tap(find.text('Khalti Wallet'));
      await tester.pump();

      expect(selected, PaymentMethod.khalti);
    });

    testWidgets('3. tapping cod calls onMethodSelected with cod', (
      tester,
    ) async {
      PaymentMethod? selected;

      await tester.pumpWidget(
        _wrap(
          PaymentStepWidget(
            selectedMethod: PaymentMethod.khalti,
            onMethodSelected: (method) => selected = method,
            onBack: () {},
            onContinue: () {},
          ),
        ),
      );

      await tester.tap(find.text('Cash on Delivery'));
      await tester.pump();

      expect(selected, PaymentMethod.cod);
    });

    testWidgets('4. tapping review order triggers onContinue', (tester) async {
      var called = false;

      await tester.pumpWidget(
        _wrap(
          PaymentStepWidget(
            selectedMethod: PaymentMethod.cod,
            onMethodSelected: (_) {},
            onBack: () {},
            onContinue: () => called = true,
          ),
        ),
      );

      await tester.tap(find.text('Review Order'));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('5. tapping back triggers onBack', (tester) async {
      var called = false;

      await tester.pumpWidget(
        _wrap(
          PaymentStepWidget(
            selectedMethod: PaymentMethod.cod,
            onMethodSelected: (_) {},
            onBack: () => called = true,
            onContinue: () {},
          ),
        ),
      );

      await tester.tap(find.text('Back to shipping'));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('6. shows selection check icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PaymentStepWidget(
            selectedMethod: PaymentMethod.khalti,
            onMethodSelected: (_) {},
            onBack: () {},
            onContinue: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('AddressStepWidget', () {
    late TextEditingController fullName;
    late TextEditingController phone;
    late TextEditingController line1;
    late TextEditingController line2;
    late TextEditingController city;
    late TextEditingController state;
    late TextEditingController zip;

    final addresses = const [
      AddressEntity(
        fullName: 'Sneha',
        phone: '9800000000',
        addressLine1: 'Baneshwor',
        city: 'Kathmandu',
        state: 'Bagmati',
        postalCode: '44600',
        isDefault: true,
      ),
      AddressEntity(
        fullName: 'Hari',
        phone: '9811111111',
        addressLine1: 'Lalitpur',
        city: 'Lalitpur',
        state: 'Bagmati',
        postalCode: '44700',
      ),
    ];

    setUp(() {
      fullName = TextEditingController();
      phone = TextEditingController();
      line1 = TextEditingController();
      line2 = TextEditingController();
      city = TextEditingController();
      state = TextEditingController();
      zip = TextEditingController();
    });

    tearDown(() {
      fullName.dispose();
      phone.dispose();
      line1.dispose();
      line2.dispose();
      city.dispose();
      state.dispose();
      zip.dispose();
    });

    AddressStepWidget buildWidget({
      bool showForm = false,
      void Function(int)? onSelected,
      VoidCallback? onAdd,
      VoidCallback? onCancel,
      VoidCallback? onSave,
      VoidCallback? onContinue,
      VoidCallback? onLocation,
      bool isFetchingLocation = false,
      String? locationInfoText,
    }) {
      return AddressStepWidget(
        addresses: addresses,
        selectedAddressIndex: 0,
        onAddressSelected: onSelected ?? (_) {},
        onContinue: onContinue ?? () {},
        showNewAddressForm: showForm,
        onAddNewAddress: onAdd ?? () {},
        onCancelNewAddress: onCancel ?? () {},
        formKey: GlobalKey<FormState>(),
        fullNameController: fullName,
        phoneController: phone,
        addressLine1Controller: line1,
        addressLine2Controller: line2,
        cityController: city,
        stateController: state,
        postalCodeController: zip,
        onSaveAddress: onSave ?? () {},
        onUseCurrentLocation: onLocation,
        isFetchingLocation: isFetchingLocation,
        locationInfoText: locationInfoText,
      );
    }

    testWidgets('7. renders section title and addresses', (tester) async {
      await tester.pumpWidget(_wrap(buildWidget()));

      expect(find.text('Select Delivery Address'), findsOneWidget);
      expect(find.text('Sneha'), findsOneWidget);
      expect(find.text('Hari'), findsOneWidget);
      expect(find.text('DEFAULT'), findsOneWidget);
    });

    testWidgets('8. tapping second address calls onAddressSelected index', (
      tester,
    ) async {
      int? selectedIndex;

      await tester.pumpWidget(
        _wrap(buildWidget(onSelected: (index) => selectedIndex = index)),
      );

      await tester.tap(find.text('Hari'));
      await tester.pump();

      expect(selectedIndex, 1);
    });

    testWidgets('9. add new address action visible when form hidden', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(buildWidget(showForm: false)));

      expect(find.text('Add New Shipping Address'), findsOneWidget);
    });

    testWidgets('10. tapping add new address triggers callback', (tester) async {
      var called = false;

      await tester.pumpWidget(
        _wrap(buildWidget(showForm: false, onAdd: () => called = true)),
      );

      await tester.tap(find.text('Add New Shipping Address'));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('11. add new address action hidden when form shown', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(buildWidget(showForm: true)));

      expect(find.text('Add New Shipping Address'), findsNothing);
    });

    testWidgets('12. form fields appear when form is shown', (tester) async {
      await tester.pumpWidget(_wrap(buildWidget(showForm: true)));

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Address Line 1'), findsOneWidget);
      expect(find.text('Postal Code'), findsOneWidget);
    });

    testWidgets('13. tapping save address triggers onSaveAddress', (
      tester,
    ) async {
      var called = false;

      await tester.pumpWidget(
        _wrap(buildWidget(showForm: true, onSave: () => called = true)),
      );

      await tester.ensureVisible(find.text('Save Address'));
      await tester.tap(find.text('Save Address'));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('14. tapping cancel triggers onCancelNewAddress', (tester) async {
      var called = false;

      await tester.pumpWidget(
        _wrap(buildWidget(showForm: true, onCancel: () => called = true)),
      );

      await tester.ensureVisible(find.text('Cancel'));
      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('15. tapping continue triggers onContinue', (tester) async {
      var called = false;

      await tester.pumpWidget(
        _wrap(buildWidget(onContinue: () => called = true)),
      );

      await tester.tap(find.text('Continue to Payment'));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('16. location button shown when callback provided', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(buildWidget(onLocation: () {})));

      expect(find.text('Use Current Location'), findsOneWidget);
    });

    testWidgets('17. tapping location button calls callback', (tester) async {
      var called = false;

      await tester.pumpWidget(
        _wrap(buildWidget(onLocation: () => called = true)),
      );

      await tester.tap(find.text('Use Current Location'));
      await tester.pump();

      expect(called, true);
    });

    testWidgets('18. detecting location text shown when fetching', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          buildWidget(
            onLocation: () {},
            isFetchingLocation: true,
          ),
        ),
      );

      expect(find.text('Detecting location...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('19. location info text is shown when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          buildWidget(
            onLocation: () {},
            locationInfoText: 'Kathmandu, Bagmati (27.7, 85.3)',
          ),
        ),
      );

      expect(find.text('Kathmandu, Bagmati (27.7, 85.3)'), findsOneWidget);
    });
  });

  group('ReviewStepWidget', () {
    final cart = CartEntity(
      id: 'c1',
      userId: 'u1',
      items: const [
        CartItemEntity(
          id: 'i1',
          productId: 'p1',
          quantity: 2,
          price: 150,
          businessId: 'b1',
          name: 'Organic Seeds',
        ),
      ],
      totalAmount: 300,
      totalItems: 2,
    );

    const address = AddressEntity(
      fullName: 'Sneha',
      phone: '9800000000',
      addressLine1: 'Baneshwor',
      city: 'Kathmandu',
      state: 'Bagmati',
      postalCode: '44600',
    );

    testWidgets('20. renders final review and product line', (tester) async {
      await tester.pumpWidget(
        _wrap(
          ReviewStepWidget(
            cart: cart,
            address: address,
            paymentMethod: PaymentMethod.cod,
            onBack: () {},
            onPlaceOrder: () {},
            isProcessing: false,
            isKhaltiProcessing: false,
          ),
        ),
      );

      expect(find.text('Final Review'), findsOneWidget);
      expect(find.text('Organic Seeds'), findsOneWidget);
      expect(find.text('x2'), findsOneWidget);
    });

    testWidgets('21. cod shows confirm place order text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          ReviewStepWidget(
            cart: cart,
            address: address,
            paymentMethod: PaymentMethod.cod,
            onBack: () {},
            onPlaceOrder: () {},
            isProcessing: false,
            isKhaltiProcessing: false,
          ),
        ),
      );

      expect(find.text('Confirm & Place Order'), findsOneWidget);
    });

    testWidgets('22. khalti shows pay with khalti text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          ReviewStepWidget(
            cart: cart,
            address: address,
            paymentMethod: PaymentMethod.khalti,
            onBack: () {},
            onPlaceOrder: () {},
            isProcessing: false,
            isKhaltiProcessing: false,
          ),
        ),
      );

      expect(find.text('Pay with Khalti'), findsOneWidget);
    });

    testWidgets('23. back and place order callbacks are triggered', (
      tester,
    ) async {
      var backCalled = false;
      var placeCalled = false;

      await tester.pumpWidget(
        _wrap(
          ReviewStepWidget(
            cart: cart,
            address: address,
            paymentMethod: PaymentMethod.cod,
            onBack: () => backCalled = true,
            onPlaceOrder: () => placeCalled = true,
            isProcessing: false,
            isKhaltiProcessing: false,
          ),
        ),
      );

      await tester.tap(find.text('Change payment method'));
      await tester.tap(find.text('Confirm & Place Order'));
      await tester.pump();

      expect(backCalled, true);
      expect(placeCalled, true);
    });
  });
}

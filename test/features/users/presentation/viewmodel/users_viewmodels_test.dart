import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/users/auth/domain/entities/auth_entity.dart';
import 'package:agrix/features/users/auth/domain/use_cases/login_usecase.dart';
import 'package:agrix/features/users/auth/domain/use_cases/register_usecase.dart';
import 'package:agrix/features/users/auth/presentation/state/auth_state.dart';
import 'package:agrix/features/users/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/cart/domain/usecase/cart_usecase.dart';
import 'package:agrix/features/users/cart/presentation/state/cart_state.dart';
import 'package:agrix/features/users/cart/presentation/viewmodel/cart_viewmodel.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/domain/usecase/user_order_usecase.dart';
import 'package:agrix/features/users/order/presentation/state/user_order_state.dart';
import 'package:agrix/features/users/order/presentation/viewmodel/user_order_viewmodel.dart';
import 'package:agrix/features/users/payment/domain/entity/user_payment_entity.dart';
import 'package:agrix/features/users/payment/domain/usecase/user_payment_usecase.dart';
import 'package:agrix/features/users/payment/presentation/state/user_payment_state.dart';
import 'package:agrix/features/users/payment/presentation/viewmodel/user_payment_viewmodel.dart';
import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:agrix/features/users/product/domain/usecase/user_product_usecase.dart';
import 'package:agrix/features/users/product/presentation/state/user_product_state.dart';
import 'package:agrix/features/users/product/presentation/viewmodel/user_product_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockGetCartUsecase extends Mock implements GetCartUsecase {}

class MockAddToCartUsecase extends Mock implements AddToCartUsecase {}

class MockUpdateCartItemUsecase extends Mock implements UpdateCartItemUsecase {}

class MockRemoveFromCartUsecase extends Mock implements RemoveFromCartUsecase {}

class MockClearCartUsecase extends Mock implements ClearCartUsecase {}

class MockGetCartCountUsecase extends Mock implements GetCartCountUsecase {}

class MockGetAllUserProductsUsecase extends Mock
    implements GetAllUserProductsUsecase {}

class MockGetUserProductsByCategoryUsecase extends Mock
    implements GetUserProductsByCategoryUsecase {}

class MockGetUserProductByIdUsecase extends Mock
    implements GetUserProductByIdUsecase {}

class MockSearchUserProductsUsecase extends Mock
    implements SearchUserProductsUsecase {}

class MockCreateUserOrderUsecase extends Mock implements CreateUserOrderUsecase {}

class MockGetUserOrdersUsecase extends Mock implements GetUserOrdersUsecase {}

class MockGetUserOrderByIdUsecase extends Mock
    implements GetUserOrderByIdUsecase {}

class MockInitiateKhaltiPaymentUsecase extends Mock
    implements InitiateKhaltiPaymentUsecase {}

class MockVerifyKhaltiPaymentUsecase extends Mock
    implements VerifyKhaltiPaymentUsecase {}

class MockGetPaymentByOrderIdUsecase extends Mock
    implements GetPaymentByOrderIdUsecase {}

class MockGetUserPaymentsUsecase extends Mock implements GetUserPaymentsUsecase {}

class FakeGetAllUserProductsParams extends Fake
    implements GetAllUserProductsUsecaseParams {}

class FakeGetUserProductByIdParams extends Fake
    implements GetUserProductByIdUsecaseParams {}

class FakeCreateUserOrderParams extends Fake
    implements CreateUserOrderUsecaseParams {}

class FakeGetUserOrdersParams extends Fake implements GetUserOrdersUsecaseParams {}

class FakeInitiateKhaltiParams extends Fake
    implements InitiateKhaltiPaymentUsecaseParams {}

class FakeVerifyKhaltiParams extends Fake
    implements VerifyKhaltiPaymentUsecaseParams {}

class FakeGetUserPaymentsParams extends Fake
    implements GetUserPaymentsUsecaseParams {}

void main() {
  const authEntity = AuthEntity(
    authId: 'u1',
    fullName: 'Sneha',
    email: 'sneha@agrix.com',
    password: 'secret',
  );

  final cartEntity = CartEntity(
    id: 'c1',
    userId: 'u1',
    items: const [
      CartItemEntity(
        id: 'i1',
        productId: 'p1',
        quantity: 2,
        price: 100,
        businessId: 'b1',
        name: 'Seeds',
      ),
    ],
    totalAmount: 200,
    totalItems: 2,
  );

  const productA = UserProductEntity(
    id: 'p1',
    businessId: 'b1',
    name: 'Seeds',
    categoryId: 'cat1',
    price: 120,
    stock: 10,
  );

  const productB = UserProductEntity(
    id: 'p2',
    businessId: 'b2',
    name: 'Fertilizer',
    categoryId: 'cat1',
    price: 180,
    stock: 5,
  );

  const orderEntity = UserOrderEntity(
    id: 'o1',
    userId: 'u1',
    items: [
      UserOrderItemEntity(
        id: 'oi1',
        productId: 'p1',
        productName: 'Seeds',
        price: 120,
        quantity: 1,
        businessId: 'b1',
      ),
    ],
    shippingAddress: UserOrderShippingAddressEntity(
      fullName: 'Sneha',
      phone: '9800000000',
      addressLine1: 'Kathmandu',
      city: 'Kathmandu',
      state: 'Bagmati',
      postalCode: '44600',
    ),
    paymentMethod: UserOrderPaymentMethod.cod,
    subtotal: 120,
    tax: 15.6,
    total: 135.6,
  );

  final initiatedPayment = InitiatePaymentEntity(
    pidx: 'pidx_1',
    paymentUrl: 'https://pay.khalti.com',
    expiresAt: DateTime(2026, 1, 1),
    orderId: 'o1',
  );

  const paymentEntity = UserPaymentEntity(
    id: 'pay1',
    userId: 'u1',
    orderId: 'o1',
    amount: 135.6,
    status: UserPaymentStatus.completed,
    paymentMethod: UserPaymentMethod.khalti,
  );

  setUpAll(() {
    registerFallbackValue(FakeGetAllUserProductsParams());
    registerFallbackValue(FakeGetUserProductByIdParams());
    registerFallbackValue(FakeCreateUserOrderParams());
    registerFallbackValue(FakeGetUserOrdersParams());
    registerFallbackValue(FakeInitiateKhaltiParams());
    registerFallbackValue(FakeVerifyKhaltiParams());
    registerFallbackValue(FakeGetUserPaymentsParams());
  });

  group('AuthViewModel Tests', () {
    late MockLoginUsecase mockLoginUsecase;
    late MockRegisterUsecase mockRegisterUsecase;
    late ProviderContainer container;
    late AuthViewModel viewModel;

    setUp(() {
      mockLoginUsecase = MockLoginUsecase();
      mockRegisterUsecase = MockRegisterUsecase();

      container = ProviderContainer(
        overrides: [
          loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
          registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        ],
      );
      viewModel = container.read(authViewModelProvider.notifier);
    });

    test('1. initial state is AuthStatus.initial', () {
      expect(viewModel.state.status, AuthStatus.initial);
    });

    test('2. login success -> authenticated + authEntity', () async {
      const params = LoginUsecaseParams(
        email: 'sneha@agrix.com',
        password: 'secret',
      );
      when(() => mockLoginUsecase.call(params))
          .thenAnswer((_) async => const Right(authEntity));

      await viewModel.login(email: params.email, password: params.password);

      expect(viewModel.state.status, AuthStatus.authenticated);
      expect(viewModel.state.authEntity, authEntity);
    });

    test('3. login failure -> error message', () async {
      const params = LoginUsecaseParams(email: 'bad', password: 'bad');
      when(() => mockLoginUsecase.call(params)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Invalid credentials')),
      );

      await viewModel.login(email: params.email, password: params.password);

      expect(viewModel.state.status, AuthStatus.error);
      expect(viewModel.state.errorMessage, 'Invalid credentials');
    });

    test('4. register false result -> error with fallback message', () async {
      const params = RegisterUsecaseParams(
        fullName: 'Sneha',
        email: 'sneha@agrix.com',
        password: 'secret',
      );
      when(() => mockRegisterUsecase.call(params))
          .thenAnswer((_) async => const Right(false));

      await viewModel.register(
        fullName: params.fullName,
        email: params.email,
        password: params.password,
      );

      expect(viewModel.state.status, AuthStatus.error);
      expect(viewModel.state.errorMessage, 'Registration failed');
    });
  });

  group('CartViewModel Tests', () {
    late MockGetCartUsecase getCartUsecase;
    late MockAddToCartUsecase addToCartUsecase;
    late MockUpdateCartItemUsecase updateCartItemUsecase;
    late MockRemoveFromCartUsecase removeFromCartUsecase;
    late MockClearCartUsecase clearCartUsecase;
    late MockGetCartCountUsecase getCartCountUsecase;
    late ProviderContainer container;
    late CartViewModel viewModel;

    setUp(() {
      getCartUsecase = MockGetCartUsecase();
      addToCartUsecase = MockAddToCartUsecase();
      updateCartItemUsecase = MockUpdateCartItemUsecase();
      removeFromCartUsecase = MockRemoveFromCartUsecase();
      clearCartUsecase = MockClearCartUsecase();
      getCartCountUsecase = MockGetCartCountUsecase();

      container = ProviderContainer(
        overrides: [
          getCartUsecaseProvider.overrideWithValue(getCartUsecase),
          addToCartUsecaseProvider.overrideWithValue(addToCartUsecase),
          updateCartItemUsecaseProvider.overrideWithValue(updateCartItemUsecase),
          removeFromCartUsecaseProvider.overrideWithValue(removeFromCartUsecase),
          clearCartUsecaseProvider.overrideWithValue(clearCartUsecase),
          getCartCountUsecaseProvider.overrideWithValue(getCartCountUsecase),
        ],
      );
      viewModel = container.read(cartViewModelProvider.notifier);
    });

    test('5. getCart success -> loaded + itemCount', () async {
      const params = GetCartUsecaseParams(token: 'token');
      when(() => getCartUsecase.call(params))
          .thenAnswer((_) async => Right(cartEntity));

      await viewModel.getCart(token: 'token');

      expect(viewModel.state.status, CartStatus.loaded);
      expect(viewModel.state.itemCount, 2);
    });

    test('6. addToCart failure -> error and isUpdating false', () async {
      const params = AddToCartUsecaseParams(
        token: 'token',
        productId: 'p1',
        quantity: 1,
      );
      when(() => addToCartUsecase.call(params)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Add failed')),
      );

      await viewModel.addToCart(token: 'token', productId: 'p1', quantity: 1);

      expect(viewModel.state.status, CartStatus.error);
      expect(viewModel.state.isUpdating, false);
      expect(viewModel.state.errorMessage, 'Add failed');
    });

    test('7. updateCartItem success -> updated', () async {
      const params = UpdateCartItemUsecaseParams(
        token: 'token',
        productId: 'p1',
        quantity: 3,
      );
      when(() => updateCartItemUsecase.call(params))
          .thenAnswer((_) async => Right(cartEntity));

      await viewModel.updateCartItem(token: 'token', productId: 'p1', quantity: 3);

      expect(viewModel.state.status, CartStatus.updated);
      expect(viewModel.state.isUpdating, false);
    });

    test('8. getCartCount failure returns 0', () async {
      const params = GetCartCountUsecaseParams(token: 'token');
      when(() => getCartCountUsecase.call(params)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Count failed')),
      );

      final count = await viewModel.getCartCount(token: 'token');

      expect(count, 0);
    });

    test('9. resetStatus from updated -> loaded', () {
      viewModel.state = viewModel.state.copyWith(status: CartStatus.updated);
      viewModel.resetStatus();
      expect(viewModel.state.status, CartStatus.loaded);
    });
  });

  group('UserProductViewModel Tests', () {
    late MockGetAllUserProductsUsecase getAllUsecase;
    late MockGetUserProductsByCategoryUsecase byCategoryUsecase;
    late MockGetUserProductByIdUsecase byIdUsecase;
    late MockSearchUserProductsUsecase searchUsecase;
    late ProviderContainer container;
    late UserProductViewModel viewModel;

    setUp(() {
      getAllUsecase = MockGetAllUserProductsUsecase();
      byCategoryUsecase = MockGetUserProductsByCategoryUsecase();
      byIdUsecase = MockGetUserProductByIdUsecase();
      searchUsecase = MockSearchUserProductsUsecase();

      container = ProviderContainer(
        overrides: [
          getAllUserProductsUsecaseProvider.overrideWithValue(getAllUsecase),
          getUserProductsByCategoryUsecaseProvider.overrideWithValue(byCategoryUsecase),
          getUserProductByIdUsecaseProvider.overrideWithValue(byIdUsecase),
          searchUserProductsUsecaseProvider.overrideWithValue(searchUsecase),
        ],
      );
      viewModel = container.read(userProductViewModelProvider.notifier);
    });

    test('10. getAllProducts success page 1 -> loaded + hasReachedMax false', () async {
      const params = GetAllUserProductsUsecaseParams(page: 1, limit: 2, refresh: false);
      when(() => getAllUsecase.call(params))
          .thenAnswer((_) async => const Right([productA, productB]));

      await viewModel.getAllProducts(page: 1, limit: 2);

      expect(viewModel.state.status, UserProductStatus.loaded);
      expect(viewModel.state.products.length, 2);
      expect(viewModel.state.hasReachedMax, false);
    });

    test('11. getAllProducts appends on next page', () async {
      const first = GetAllUserProductsUsecaseParams(page: 1, limit: 1, refresh: false);
      const second = GetAllUserProductsUsecaseParams(page: 2, limit: 1, refresh: false);
      when(() => getAllUsecase.call(first))
          .thenAnswer((_) async => const Right([productA]));
      when(() => getAllUsecase.call(second))
          .thenAnswer((_) async => const Right([productB]));

      await viewModel.getAllProducts(page: 1, limit: 1);
      await viewModel.getAllProducts(page: 2, limit: 1);

      expect(viewModel.state.products.length, 2);
      expect(viewModel.state.products, [productA, productB]);
    });

    test('12. getAllProducts early-return when hasReachedMax', () async {
      viewModel.state = viewModel.state.copyWith(hasReachedMax: true, status: UserProductStatus.loaded);

      await viewModel.getAllProducts(page: 2, limit: 20);

      verifyNever(() => getAllUsecase.call(any()));
    });

    test('13. getProductById failure -> error', () async {
      when(() => byIdUsecase.call(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Not found')),
      );

      await viewModel.getProductById(productId: 'p404');

      expect(viewModel.state.status, UserProductStatus.error);
      expect(viewModel.state.errorMessage, 'Not found');
    });

    test('14. selectProduct + clearSelection updates selectedProduct', () {
      viewModel.selectProduct(productA);
      expect(viewModel.state.selectedProduct, productA);

      viewModel.clearSelection();
      expect(viewModel.state.selectedProduct, isNull);
    });
  });

  group('UserOrderViewModel Tests', () {
    late MockCreateUserOrderUsecase createUsecase;
    late MockGetUserOrdersUsecase getOrdersUsecase;
    late MockGetUserOrderByIdUsecase getByIdUsecase;
    late ProviderContainer container;
    late UserOrderViewModel viewModel;

    setUp(() {
      createUsecase = MockCreateUserOrderUsecase();
      getOrdersUsecase = MockGetUserOrdersUsecase();
      getByIdUsecase = MockGetUserOrderByIdUsecase();

      container = ProviderContainer(
        overrides: [
          createUserOrderUsecaseProvider.overrideWithValue(createUsecase),
          getUserOrdersUsecaseProvider.overrideWithValue(getOrdersUsecase),
          getUserOrderByIdUsecaseProvider.overrideWithValue(getByIdUsecase),
        ],
      );
      viewModel = container.read(userOrderViewModelProvider.notifier);
    });

    test('15. createOrder success -> created + currentOrder', () async {
      when(() => createUsecase.call(any()))
          .thenAnswer((_) async => const Right(orderEntity));

      await viewModel.createOrder(token: 'token', orderData: const {'items': []});

      expect(viewModel.state.status, UserOrderViewStatus.created);
      expect(viewModel.state.currentOrder, orderEntity);
      expect(viewModel.state.orders.length, 1);
    });

    test('16. getUserOrders refresh replaces orders', () async {
      when(() => getOrdersUsecase.call(any()))
          .thenAnswer((_) async => const Right([orderEntity]));

      await viewModel.getUserOrders(token: 'token', refresh: true);

      expect(viewModel.state.status, UserOrderViewStatus.loaded);
      expect(viewModel.state.orders, [orderEntity]);
    });

    test('17. getUserOrders early-return when loading', () async {
      viewModel.state = viewModel.state.copyWith(status: UserOrderViewStatus.loading);

      await viewModel.getUserOrders(token: 'token');

      verifyNever(() => getOrdersUsecase.call(any()));
    });

    test('18. resetStatus changes created -> loaded', () {
      viewModel.state = viewModel.state.copyWith(status: UserOrderViewStatus.created);
      viewModel.resetStatus();
      expect(viewModel.state.status, UserOrderViewStatus.loaded);
    });
  });

  group('UserPaymentViewModel Tests', () {
    late MockInitiateKhaltiPaymentUsecase initiateUsecase;
    late MockVerifyKhaltiPaymentUsecase verifyUsecase;
    late MockGetPaymentByOrderIdUsecase getByOrderUsecase;
    late MockGetUserPaymentsUsecase getUserPaymentsUsecase;
    late ProviderContainer container;
    late UserPaymentViewModel viewModel;

    setUp(() {
      initiateUsecase = MockInitiateKhaltiPaymentUsecase();
      verifyUsecase = MockVerifyKhaltiPaymentUsecase();
      getByOrderUsecase = MockGetPaymentByOrderIdUsecase();
      getUserPaymentsUsecase = MockGetUserPaymentsUsecase();

      container = ProviderContainer(
        overrides: [
          initiateKhaltiPaymentUsecaseProvider.overrideWithValue(initiateUsecase),
          verifyKhaltiPaymentUsecaseProvider.overrideWithValue(verifyUsecase),
          getPaymentByOrderIdUsecaseProvider.overrideWithValue(getByOrderUsecase),
          getUserPaymentsUsecaseProvider.overrideWithValue(getUserPaymentsUsecase),
        ],
      );
      viewModel = container.read(userPaymentViewModelProvider.notifier);
    });

    test('19. initiateKhaltiPayment success -> success + initiatedPayment', () async {
      when(() => initiateUsecase.call(any()))
          .thenAnswer((_) async => Right(initiatedPayment));

      await viewModel.initiateKhaltiPayment(
        token: 'token',
        orderId: 'o1',
        amount: 135.6,
        returnUrl: 'https://return',
      );

      expect(viewModel.state.status, UserPaymentViewStatus.success);
      expect(viewModel.state.initiatedPayment, initiatedPayment);
    });

    test('20. verifyKhaltiPayment failure -> error message', () async {
      when(() => verifyUsecase.call(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Verification failed')),
      );

      await viewModel.verifyKhaltiPayment(token: 'token', pidx: 'pidx_1', orderId: 'o1');

      expect(viewModel.state.status, UserPaymentViewStatus.error);
      expect(viewModel.state.errorMessage, 'Verification failed');
    });

    test('21. getUserPayments appends page 2 data', () async {
      when(() => getUserPaymentsUsecase.call(any())).thenAnswer((invocation) async {
        final params =
            invocation.positionalArguments.first as GetUserPaymentsUsecaseParams;
        if (params.page == 1) {
          return const Right([paymentEntity]);
        }
        return Right([
          paymentEntity.copyWith(id: 'pay2', orderId: 'o2'),
        ]);
      });

      await viewModel.getUserPayments(token: 'token', page: 1, limit: 1);
      await viewModel.getUserPayments(token: 'token', page: 2, limit: 1);

      expect(viewModel.state.payments.length, 2);
      expect(viewModel.state.currentPage, 2);
    });

    test('22. clearError clears message only', () {
      viewModel.state = viewModel.state.copyWith(
        status: UserPaymentViewStatus.error,
        errorMessage: 'x',
      );

      viewModel.clearError();

      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.status, UserPaymentViewStatus.error);
    });

    test('23. resetState returns initial state', () {
      viewModel.state = viewModel.state.copyWith(
        status: UserPaymentViewStatus.success,
        payments: const [paymentEntity],
      );

      viewModel.resetState();

      expect(viewModel.state, const UserPaymentState());
    });
  });
}

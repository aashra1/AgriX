import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/domain/repository/business_auth_repository.dart';
import 'package:agrix/features/business/auth/domain/use_cases/business_login_usecase.dart';
import 'package:agrix/features/business/auth/domain/use_cases/business_register_usecase.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/entity/business_transaction_entity.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/repository/business_transaction_repository.dart';
import 'package:agrix/features/business/buisness_dashboard/payments/domain/usecase/business_transaction_usecase.dart';
import 'package:agrix/features/category/domain/entity/category_entity.dart';
import 'package:agrix/features/category/domain/repository/category_repository.dart';
import 'package:agrix/features/category/domain/usecase/category_usecases.dart';
import 'package:agrix/features/users/auth/domain/entities/auth_entity.dart';
import 'package:agrix/features/users/auth/domain/repository/auth_repository.dart';
import 'package:agrix/features/users/auth/domain/use_cases/login_usecase.dart';
import 'package:agrix/features/users/auth/domain/use_cases/register_usecase.dart';
import 'package:agrix/features/users/cart/domain/entity/cart_entity.dart';
import 'package:agrix/features/users/cart/domain/repository/cart_repository.dart';
import 'package:agrix/features/users/cart/domain/usecase/cart_usecase.dart';
import 'package:agrix/features/users/order/domain/entity/user_order_entity.dart';
import 'package:agrix/features/users/order/domain/repository/user_order_repository.dart';
import 'package:agrix/features/users/order/domain/usecase/user_order_usecase.dart';
import 'package:agrix/features/users/payment/domain/entity/user_payment_entity.dart';
import 'package:agrix/features/users/payment/domain/repository/user_payment_repository.dart';
import 'package:agrix/features/users/payment/domain/usecase/user_payment_usecase.dart';
import 'package:agrix/features/users/product/domain/entity/user_product_entity.dart';
import 'package:agrix/features/users/product/domain/repository/user_product_repository.dart';
import 'package:agrix/features/users/product/domain/usecase/user_product_usecase.dart';
import 'package:agrix/features/users/profile/domain/entity/profile_entity.dart';
import 'package:agrix/features/users/profile/domain/repository/profile_repository.dart';
import 'package:agrix/features/users/profile/domain/usecase/profile_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockCartRepository extends Mock implements ICartRepository {}

class MockUserProductRepository extends Mock implements IUserProductRepository {}

class MockUserProfileRepository extends Mock implements IUserProfileRepository {}

class MockUserPaymentRepository extends Mock implements IUserPaymentRepository {}

class MockUserOrderRepository extends Mock implements IUserOrderRepository {}

class MockCategoryRepository extends Mock implements ICategoryRepository {}

class MockBusinessAuthRepository extends Mock implements IBusinessAuthRepository {}

class MockBusinessWalletRepository extends Mock
    implements IBusinessWalletRepository {}

void main() {
  late MockAuthRepository authRepository;
  late MockCartRepository cartRepository;
  late MockUserProductRepository userProductRepository;
  late MockUserProfileRepository userProfileRepository;
  late MockUserPaymentRepository userPaymentRepository;
  late MockUserOrderRepository userOrderRepository;
  late MockCategoryRepository categoryRepository;
  late MockBusinessAuthRepository businessAuthRepository;
  late MockBusinessWalletRepository businessWalletRepository;

  const tAuthEntity = AuthEntity(
    authId: 'u1',
    fullName: 'Sneha',
    email: 'sneha@agrix.com',
    password: 'secret',
  );

  const tBusinessEntity = BusinessAuthEntity(
    businessId: 'b1',
    businessName: 'AgriX Shop',
    email: 'shop@agrix.com',
    password: 'secret',
    phoneNumber: '9800000000',
  );

  final tCartEntity = CartEntity(
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

  const tProductEntity = UserProductEntity(
    id: 'p1',
    businessId: 'b1',
    name: 'Organic Seeds',
    categoryId: 'cat1',
    price: 250,
    stock: 20,
  );

  const tProfileEntity = UserProfileEntity(
    id: 'u1',
    fullName: 'Sneha',
    email: 'sneha@agrix.com',
    phoneNumber: '9800000000',
  );

  final tInitiatedPayment = InitiatePaymentEntity(
    pidx: 'pidx_123',
    paymentUrl: 'https://khalti.com/pay',
    expiresAt: DateTime(2026, 1, 1),
    orderId: 'o1',
  );

  const tPaymentEntity = UserPaymentEntity(
    id: 'pay1',
    userId: 'u1',
    orderId: 'o1',
    amount: 450,
    status: UserPaymentStatus.completed,
    paymentMethod: UserPaymentMethod.khalti,
  );

  const tOrderEntity = UserOrderEntity(
    id: 'o1',
    userId: 'u1',
    items: [
      UserOrderItemEntity(
        id: 'oi1',
        productId: 'p1',
        productName: 'Organic Seeds',
        price: 250,
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
    subtotal: 250,
    tax: 32.5,
    total: 282.5,
  );

  const tCategory = CategoryEntity(id: 'cat1', name: 'Seeds');

  final tTransaction = BusinessTransactionEntity(
    id: 't1',
    type: TransactionType.credit,
    amount: 500,
    balance: 1400,
    reference: 'REF001',
    description: 'Order payment',
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(tAuthEntity);
    registerFallbackValue(tBusinessEntity);
  });

  setUp(() {
    authRepository = MockAuthRepository();
    cartRepository = MockCartRepository();
    userProductRepository = MockUserProductRepository();
    userProfileRepository = MockUserProfileRepository();
    userPaymentRepository = MockUserPaymentRepository();
    userOrderRepository = MockUserOrderRepository();
    categoryRepository = MockCategoryRepository();
    businessAuthRepository = MockBusinessAuthRepository();
    businessWalletRepository = MockBusinessWalletRepository();
  });

  group('Usecases Unit Tests', () {
    test('1. LoginUsecase forwards email/password and returns AuthEntity', () async {
      final usecase = LoginUsecase(authRepository: authRepository);
      const params = LoginUsecaseParams(
        email: 'sneha@agrix.com',
        password: 'secret',
      );

      when(() => authRepository.loginUser(params.email, params.password))
          .thenAnswer((_) async => const Right(tAuthEntity));

      final result = await usecase(params);

      expect(result, const Right(tAuthEntity));
      verify(() => authRepository.loginUser(params.email, params.password)).called(1);
    });

    test('2. LoginUsecase propagates failure', () async {
      final usecase = LoginUsecase(authRepository: authRepository);
      const params = LoginUsecaseParams(email: 'x@y.com', password: 'bad');

      when(() => authRepository.loginUser(params.email, params.password))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'invalid')));

      final result = await usecase(params);

      expect(result, const Left(ApiFailure(message: 'invalid')));
    });

    test('3. RegisterUsecase maps params into AuthEntity and calls repository', () async {
      final usecase = RegisterUsecase(authRepository: authRepository);
      const params = RegisterUsecaseParams(
        fullName: 'Sneha',
        email: 'sneha@agrix.com',
        password: 'secret',
        phoneNumber: '9800000000',
        address: 'Kathmandu',
      );

      when(
        () => authRepository.registerUser(any(), imagePath: any(named: 'imagePath')),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(params);

      expect(result, const Right(true));
      final captured = verify(
        () => authRepository.registerUser(captureAny(), imagePath: any(named: 'imagePath')),
      ).captured.first as AuthEntity;
      expect(captured.fullName, params.fullName);
      expect(captured.email, params.email);
      expect(captured.password, params.password);
      expect(captured.phoneNumber, params.phoneNumber);
      expect(captured.address, params.address);
    });

    test('4. GetCartUsecase returns cart from repository', () async {
      final usecase = GetCartUsecase(repository: cartRepository);
      const params = GetCartUsecaseParams(token: 'token');

      when(() => cartRepository.getCart(token: 'token'))
          .thenAnswer((_) async => Right(tCartEntity));

      final result = await usecase(params);

      expect(result, Right(tCartEntity));
    });

    test('5. AddToCartUsecase forwards productId and quantity', () async {
      final usecase = AddToCartUsecase(repository: cartRepository);
      const params = AddToCartUsecaseParams(
        token: 'token',
        productId: 'p1',
        quantity: 3,
      );

      when(() => cartRepository.addToCart(
            token: params.token,
            productId: params.productId,
            quantity: params.quantity,
          )).thenAnswer((_) async => Right(tCartEntity));

      final result = await usecase(params);

      expect(result, Right(tCartEntity));
      verify(() => cartRepository.addToCart(
            token: params.token,
            productId: params.productId,
            quantity: params.quantity,
          )).called(1);
    });

    test('6. UpdateCartItemUsecase forwards update values', () async {
      final usecase = UpdateCartItemUsecase(repository: cartRepository);
      const params = UpdateCartItemUsecaseParams(
        token: 'token',
        productId: 'p1',
        quantity: 1,
      );

      when(() => cartRepository.updateCartItem(
            token: params.token,
            productId: params.productId,
            quantity: params.quantity,
          )).thenAnswer((_) async => Right(tCartEntity));

      final result = await usecase(params);

      expect(result, Right(tCartEntity));
    });

    test('7. RemoveFromCartUsecase forwards token and productId', () async {
      final usecase = RemoveFromCartUsecase(repository: cartRepository);
      const params = RemoveFromCartUsecaseParams(token: 'token', productId: 'p1');

      when(() => cartRepository.removeFromCart(token: 'token', productId: 'p1'))
          .thenAnswer((_) async => Right(tCartEntity));

      final result = await usecase(params);

      expect(result, Right(tCartEntity));
    });

    test('8. GetAllUserProductsUsecase forwards pagination params', () async {
      final usecase = GetAllUserProductsUsecase(repository: userProductRepository);
      const params = GetAllUserProductsUsecaseParams(page: 2, limit: 12, refresh: true);

      when(() => userProductRepository.getAllProducts(
            page: params.page,
            limit: params.limit,
            refresh: params.refresh,
          )).thenAnswer((_) async => const Right([tProductEntity]));

      final result = await usecase(params);

      expect(result, const Right([tProductEntity]));
    });

    test('9. GetUserProductsByCategoryUsecase forwards category and pagination', () async {
      final usecase = GetUserProductsByCategoryUsecase(repository: userProductRepository);
      const params = GetUserProductsByCategoryUsecaseParams(
        categoryId: 'cat1',
        page: 1,
        limit: 20,
        refresh: false,
      );

      when(() => userProductRepository.getProductsByCategory(
            categoryId: params.categoryId,
            page: params.page,
            limit: params.limit,
            refresh: params.refresh,
          )).thenAnswer((_) async => const Right([tProductEntity]));

      final result = await usecase(params);

      expect(result, const Right([tProductEntity]));
    });

    test('10. GetUserProfileUsecase fetches profile by token', () async {
      final usecase = GetUserProfileUsecase(repository: userProfileRepository);
      const params = GetUserProfileUsecaseParams(token: 'token');

      when(() => userProfileRepository.getUserProfile(token: 'token'))
          .thenAnswer((_) async => const Right(tProfileEntity));

      final result = await usecase(params);

      expect(result, const Right(tProfileEntity));
    });

    test('11. ChangePasswordUsecase forwards all password fields', () async {
      final usecase = ChangePasswordUsecase(repository: userProfileRepository);
      const params = ChangePasswordUsecaseParams(
        token: 'token',
        currentPassword: 'old',
        newPassword: 'new',
        confirmPassword: 'new',
      );

      when(() => userProfileRepository.changePassword(
            token: params.token,
            currentPassword: params.currentPassword,
            newPassword: params.newPassword,
            confirmPassword: params.confirmPassword,
          )).thenAnswer((_) async => const Right(true));

      final result = await usecase(params);

      expect(result, const Right(true));
    });

    test('12. InitiateKhaltiPaymentUsecase forwards all required fields', () async {
      final usecase = InitiateKhaltiPaymentUsecase(repository: userPaymentRepository);
      const params = InitiateKhaltiPaymentUsecaseParams(
        token: 'token',
        orderId: 'o1',
        amount: 450,
        returnUrl: 'https://return',
      );

      when(() => userPaymentRepository.initiateKhaltiPayment(
            token: params.token,
            orderId: params.orderId,
            amount: params.amount,
            returnUrl: params.returnUrl,
          )).thenAnswer((_) async => Right(tInitiatedPayment));

      final result = await usecase(params);

      expect(result, Right(tInitiatedPayment));
    });

    test('13. VerifyKhaltiPaymentUsecase forwards token/pidx/orderId', () async {
      final usecase = VerifyKhaltiPaymentUsecase(repository: userPaymentRepository);
      const params = VerifyKhaltiPaymentUsecaseParams(
        token: 'token',
        pidx: 'pidx_123',
        orderId: 'o1',
      );

      when(() => userPaymentRepository.verifyKhaltiPayment(
            token: params.token,
            pidx: params.pidx,
            orderId: params.orderId,
          )).thenAnswer((_) async => const Right(tPaymentEntity));

      final result = await usecase(params);

      expect(result, const Right(tPaymentEntity));
    });

    test('14. CreateUserOrderUsecase forwards raw order data', () async {
      final usecase = CreateUserOrderUsecase(repository: userOrderRepository);
      const orderData = {'items': [], 'paymentMethod': 'cod'};
      const params = CreateUserOrderUsecaseParams(token: 'token', orderData: orderData);

      when(() => userOrderRepository.createOrder(
            token: params.token,
            orderData: params.orderData,
          )).thenAnswer((_) async => const Right(tOrderEntity));

      final result = await usecase(params);

      expect(result, const Right(tOrderEntity));
    });

    test('15. GetUserOrderByIdUsecase forwards token and orderId', () async {
      final usecase = GetUserOrderByIdUsecase(repository: userOrderRepository);
      const params = GetUserOrderByIdUsecaseParams(token: 'token', orderId: 'o1');

      when(() => userOrderRepository.getOrderById(token: 'token', orderId: 'o1'))
          .thenAnswer((_) async => const Right(tOrderEntity));

      final result = await usecase(params);

      expect(result, const Right(tOrderEntity));
    });

    test('16. GetCategoriesUsecase returns category list', () async {
      final usecase = GetCategoriesUsecase(categoryRepository: categoryRepository);

      when(() => categoryRepository.getCategories())
          .thenAnswer((_) async => const Right([tCategory]));

      final result = await usecase.call();

      expect(result, const Right([tCategory]));
    });

    test('17. BusinessLoginUsecase forwards email/password', () async {
      final usecase = BusinessLoginUsecase(authRepository: businessAuthRepository);
      const params = BusinessLoginUsecaseParams(email: 'shop@agrix.com', password: 'secret');

      when(() => businessAuthRepository.loginBusiness(params.email, params.password))
          .thenAnswer((_) async => const Right(tBusinessEntity));

      final result = await usecase(params);

      expect(result, const Right(tBusinessEntity));
    });

    test('18. BusinessRegisterUsecase maps params into BusinessAuthEntity', () async {
      final usecase = BusinessRegisterUsecase(authRepository: businessAuthRepository);
      const params = BusinessRegisterUsecaseParams(
        businessName: 'AgriX Shop',
        email: 'shop@agrix.com',
        password: 'secret',
        phoneNumber: '9800000000',
        address: 'Kathmandu',
      );

      when(
        () => businessAuthRepository.registerBusiness(
          any(),
          imagePath: any(named: 'imagePath'),
        ),
      )
          .thenAnswer((_) async => const Right({'ok': true}));

      final result = await usecase(params);

      expect(result.isRight(), true);
      final map = result.getOrElse(() => <String, dynamic>{});
      expect(map['ok'], true);
      final captured = verify(
            () => businessAuthRepository.registerBusiness(
              captureAny(),
              imagePath: any(named: 'imagePath'),
            ),
          )
          .captured
          .single as BusinessAuthEntity;
      expect(captured.businessName, params.businessName);
      expect(captured.email, params.email);
      expect(captured.phoneNumber, params.phoneNumber);
      expect(captured.address, params.address);
    });

    test('19. GetTransactionsUsecase combines transactions + pagination', () async {
      final usecase = GetTransactionsUsecase(repository: businessWalletRepository);
      const params = GetTransactionsUsecaseParams(token: 'token', page: 1, limit: 10);

      when(() => businessWalletRepository.getTransactions(
            token: params.token,
            page: params.page,
            limit: params.limit,
          )).thenAnswer((_) async => Right([tTransaction]));
      when(() => businessWalletRepository.getPagination())
          .thenAnswer((_) async => const Right({'currentPage': 1, 'totalPages': 3}));

      final result = await usecase(params);

      expect(result.isRight(), true);
      final payload = result.getOrElse(() => <String, dynamic>{});
      expect(payload['transactions'], [tTransaction]);
      expect(payload['pagination'], const {'currentPage': 1, 'totalPages': 3});
    });
  });
}

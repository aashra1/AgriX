import 'package:agrix/core/error/failure.dart';
import 'package:agrix/features/business/auth/domain/entities/business_auth_entity.dart';
import 'package:agrix/features/business/auth/domain/use_cases/business_login_usecase.dart';
import 'package:agrix/features/business/auth/domain/use_cases/business_register_usecase.dart';
import 'package:agrix/features/business/auth/domain/use_cases/upload_document_usecase.dart';
import 'package:agrix/features/business/auth/presentation/state/business_auth_state.dart';
import 'package:agrix/features/business/auth/presentation/viewmodel/business_auth_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockBusinessLoginUsecase extends Mock implements BusinessLoginUsecase {}

class MockBusinessRegisterUsecase extends Mock
    implements BusinessRegisterUsecase {}

class MockUploadDocumentUsecase extends Mock implements UploadDocumentUsecase {}

// Fake Params for Mocktail to handle .call(any())
class FakeLoginParams extends Fake implements BusinessLoginUsecaseParams {}

class FakeRegisterParams extends Fake
    implements BusinessRegisterUsecaseParams {}

void main() {
  late BusinessAuthViewModel viewModel;
  late MockBusinessLoginUsecase mockLoginUsecase;
  late MockBusinessRegisterUsecase mockRegisterUsecase;
  late MockUploadDocumentUsecase mockUploadUsecase;

  // Test Data
  final tBusiness = BusinessAuthEntity(
    businessId: '1',
    businessName: 'AgriX Corp',
    email: 'biz@agrix.com',
    phoneNumber: '1234567890',
    businessStatus: 'Active',
    password: 'password123',
  );

  setUpAll(() {
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeRegisterParams());
  });

  setUp(() {
    mockLoginUsecase = MockBusinessLoginUsecase();
    mockRegisterUsecase = MockBusinessRegisterUsecase();
    mockUploadUsecase = MockUploadDocumentUsecase();

    final container = ProviderContainer(
      overrides: [
        businessLoginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        businessRegisterUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        uploadDocumentUsecaseProvider.overrideWithValue(mockUploadUsecase),
      ],
    );

    viewModel = container.read(businessAuthViewModelProvider.notifier);
  });

  group('BusinessAuthViewModel Logic Tests', () {
    test('Should have initial state with BusinessAuthStatus.initial', () {
      expect(viewModel.state.status, BusinessAuthStatus.initial);
    });

    test(
      'loginBusiness: successful login updates status to authenticated',
      () async {
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => Right(tBusiness));

        await viewModel.loginBusiness(
          email: 'biz@agrix.com',
          password: 'password123',
        );

        expect(viewModel.state.status, BusinessAuthStatus.authenticated);
        expect(viewModel.state.businessEntity, tBusiness);
      },
    );

    test(
      'loginBusiness: failed login updates status to error with message',
      () async {
        when(() => mockLoginUsecase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Invalid Credentials')),
        );

        await viewModel.loginBusiness(email: 'wrong@biz.com', password: '123');

        expect(viewModel.state.status, BusinessAuthStatus.error);
        expect(viewModel.state.errorMessage, 'Invalid Credentials');
      },
    );

    test(
      'registerBusiness: success with tempToken triggers needsDocumentUpload status',
      () async {
        final mockResponse = {
          'business': tBusiness,
          'tempToken': 'upload_token_123',
        };

        when(
          () => mockRegisterUsecase.call(any()),
        ).thenAnswer((_) async => Right(mockResponse));

        await viewModel.registerBusiness(
          businessName: 'AgriX Corp',
          email: 'biz@agrix.com',
          password: 'password123',
          phoneNumber: '1234567890',
        );

        expect(viewModel.state.status, BusinessAuthStatus.needsDocumentUpload);
        expect(viewModel.state.tempToken, 'upload_token_123');
      },
    );
  });
}

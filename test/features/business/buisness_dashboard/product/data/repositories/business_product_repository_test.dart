import 'package:agrix/core/services/connectivity/network_infor.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/datasource/business_product_datasource.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_api_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/model/business_product_hive_model.dart';
import 'package:agrix/features/business/buisness_dashboard/product/data/repositories/business_product_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements IProductRemoteDatasource {}

class MockLocalDataSource extends Mock implements IProductLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepository repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(
      ProductHiveModel(
        name: '',
        categoryId: '',
        price: 0,
        stock: 0,
        businessId: '',
      ),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepository(
      remoteDatasource: mockRemoteDataSource,
      localDatasource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('ProductRepository Unit Tests', () {
    const tToken = 'valid_token';
    const tProductId = 'p123';

    final tProductApiModel = ProductApiModel(
      id: tProductId,
      businessId: 'b1',
      name: 'Organic Fertilizer',
      categoryName: 'supplies',
      price: 250.0,
      stock: 10,
      categoryId: '1',
    );

 

    final tProductHiveModel = ProductHiveModel(
      productId: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      businessId: 'b1',
      name: 'Organic Fertilizer',
      categoryId: '1',
      categoryName: 'supplies',
      price: 250.0,
      stock: 10,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('getBusinessProducts should return local data when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getBusinessProducts(any()),
      ).thenAnswer((_) async => [tProductHiveModel]);

      final result = await repository.getBusinessProducts(token: tToken);

      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.getBusinessProducts(any())).called(1);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test(
      'addProduct should return ApiFailure when online but API call fails',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.addProduct(
            productData: any(named: 'productData'),
            token: any(named: 'token'),
            imagePath: any(named: 'imagePath'),
          ),
        ).thenThrow(Exception('API Error'));

        final result = await repository.addProduct(
          name: 'Organic Fertilizer',
          categoryId: '1',
          price: 250.0,
          stock: 10,
          token: tToken,
        );

        expect(result.isLeft(), true);
      },
    );

    test(
      'addProduct should return LocalDatabaseFailure when offline and local save fails',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.addProduct(any()),
        ).thenThrow(Exception('Hive Error'));

        final result = await repository.addProduct(
          name: 'Organic Fertilizer',
          categoryId: '1',
          price: 250.0,
          stock: 10,
          token: tToken,
        );

        expect(result.isLeft(), true);
      },
    );
  });
}

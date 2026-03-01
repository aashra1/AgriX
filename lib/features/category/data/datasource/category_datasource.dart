import 'package:agrix/features/category/data/model/category_api_model.dart';

abstract interface class ICategoryRemoteDatasource {
  Future<List<CategoryApiModel>> getCategories();
}

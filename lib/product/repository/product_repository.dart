import 'package:baemin/common/const/data.dart';
import 'package:baemin/common/dio/dio.dart';
import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/common/model/pagination_params.dart';
import 'package:baemin/common/repository/base_pagination_repository.dart';
import 'package:baemin/product/model/product_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';

part 'product_repository.g.dart';

final productReposigoryProvider = Provider<ProductRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return ProductRepository(dio, baseUrl: 'http://$ip/product');
  },
);

@RestApi()
abstract class ProductRepository implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}

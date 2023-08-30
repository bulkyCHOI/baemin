import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/common/provider/pagination_provider.dart';
import 'package:baemin/product/model/product_model.dart';
import 'package:baemin/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(productReposigoryProvider);
  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}

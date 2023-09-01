import 'package:baemin/common/component/pagination_list_view.dart';
import 'package:baemin/product/component/product_card.dart';
import 'package:baemin/product/model/product_model.dart';
import 'package:baemin/product/provider/product_provider.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return ProductCard.fromProductModel(
          model: model,
        );
      },
    );
  }
}

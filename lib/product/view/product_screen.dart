import 'package:baemin/common/component/pagination_list_view.dart';
import 'package:baemin/product/component/product_card.dart';
import 'package:baemin/product/model/product_model.dart';
import 'package:baemin/product/provider/product_provider.dart';
import 'package:baemin/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      provider: productProvider,
      itemBuilder: <ProductModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(
                  id: model.restaurant.id,
                ),
              ),
            );
          },
          child: ProductCard.fromProductModel(
            model: model,
          ),
        );
      },
    );
  }
}

import 'package:baemin/common/const/data.dart';
import 'package:baemin/common/dio/dio.dart';
import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/restaurant/component/restaurant_card.dart';
import 'package:baemin/restaurant/model/restaurant_model.dart';
import 'package:baemin/restaurant/provider/restaurant_provider.dart';
import 'package:baemin/restaurant/repository/restaurant_repository.dart';
import 'package:baemin/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {  //로딩중인 상태의 클래스이면
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final cp = data as CursorPagination;  //임시로 일단 이렇게 처리해서 아래 데이터를 유효하게 하자

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          itemCount: cp.data.length,
          itemBuilder: (_, index) {
            final pItem = cp.data[index];

            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                        id: pItem.id,
                      ),
                    ),
                  );
                },
                child: RestaurantCard.fromModel(model: pItem));
          },
          separatorBuilder: (_, index) {
            return SizedBox(
              height: 16.0,
            );
          },
        ));
  }
}

import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/common/provider/pagination_provider.dart';
import 'package:baemin/restaurant/model/restaurant_model.dart';
import 'package:baemin/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    // is로 해서 as를 쓴것처럼 캐스팅이 되었다.
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);  //OrNull 함수가 collection.dart에 정의되어 있다. >>> 데이터가 없으면 null을 return하도록 만들어 줘야한다.
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  //base를 제네릭으로 넣어주면 extends된 어떤 클래스도 사용가능하다.
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    //만약에 아직 데이터가 하다도 없는 상태라면 == CursorPagination이 아니라면
    //데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await this.paginate();
    }

    //state가 CursorPagination이 아닐때 그냥 return
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    //[RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
    // 만약 요청  id:10이면
    //list.where((e) => e.id == 10) >>> 데이터 없으므로 에러가 발생함.
    // 데이터가 없는 경우에는 캐시의 끝에 데이터를 추가한다.
    //[RestaurantModel(1), RestaurantModel(2), RestaurantModel(3), RestaurantModel(10)]
    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          resp,
        ],
      );
    } else {
      //예시
      //[RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
      //id:2인 element의 DetailModel을 가져와라
      //getDetail(id:2);
      //[RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? resp : e,
            )
            .toList(),
      );
    }
  }
}

import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/restaurant/model/restaurant_model.dart';
import 'package:baemin/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier,
    CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> { //base를 제네릭으로 넣어주면 extends된 어떤 클래스도 사용가능하다.
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) { //생성단계이므로 로딩인 상태의 클래스를 받도록 한다.
    paginate(); //constructor에 추가하여 바로 실행되도록
  }

  paginate() async {
    final resp = await repository.paginate();

    state = resp;
  }
}

import 'package:baemin/common/model/cursor_pagination_model.dart';
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

  paginate({
    int fetchCount = 20,
    bool fetchMore = false, //true 추가 데이터 가져오기, false 새로고침(현재 상태를 덮어씌움)
    bool forceRefetch = false,  //강제로 다시 로딩하기 true = CursorPaginationLoading()
}) async {
    final resp = await repository.paginate();
    state = resp;
    // State의 상태
    // 1) CursorPagination - 정상적으로 데이터가 있는 상태
    // 2) CursorPaginationLoading - 데이터가 로딩중인 상태(현재 캐시 없음)
    // 3) CursorPaginationError - 에러가 있는 상태
    // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
    // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때
  }
}

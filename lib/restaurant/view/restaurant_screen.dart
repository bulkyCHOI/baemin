import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/restaurant/component/restaurant_card.dart';
import 'package:baemin/restaurant/provider/restaurant_provider.dart';
import 'package:baemin/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  //스크롤을 내리면서 어디쯤 왓는지 확인하기 위해 컨트롤러를 추가한다.
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    //현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면, 새로운 뎅디터를 추가 요청
    // 현재위치 > 최대길이 - 300 픽셀 이면 추가요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    //완전 처음 올딩일때
    if (data is CursorPaginationLoading) {
      //로딩중인 상태의 클래스이면
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    //에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = data as CursorPagination; //임시로 일단 이렇게 처리해서 아래 데이터를 유효하게 하자

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1,  //맨 마지막에 로딩바를 보여주기 위해 하나 추가해놓고
          itemBuilder: (_, index) {
            if (index == cp.data.length) {  //로딩처릴르 여기서 해준다.
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: data is CursorPaginationFetchingMore //아래에 데이터가 더 있다면
                      ? CircularProgressIndicator() //로딩을 표시해주고
                      : Text('데이터가 마지막입니다 ㅠㅠ'), //없다면 메시지를 보여준다.
                ),
              );
            }
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

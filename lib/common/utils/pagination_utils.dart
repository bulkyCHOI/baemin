import 'package:baemin/common/provider/pagination_provider.dart';
import 'package:flutter/cupertino.dart';

class PaginationUtils {
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
  }) {
    //현재 위치가 최대 길이보다 조금 덜되는 위치까지 왔다면, 새로운 뎅디터를 추가 요청
    // 현재위치 > 최대길이 - 300 픽셀 이면 추가요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}

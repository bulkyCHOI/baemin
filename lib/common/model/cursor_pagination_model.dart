import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

abstract class CursorPaginationBase{} //상태를 클래스로 만든다.

class CursorPaginationError extends CursorPaginationBase{ //에러가 났을대의 클래스
  final String message;

  CursorPaginationError({
    required this.message,
});
}



class CursorPaginationLoading extends CursorPaginationBase{}  //로딩중일때의 클래스

@JsonSerializable(
  genericArgumentFactories: true, // 이 옵션을 켜놔야 제네릭으로 들어온 타입의 factory constructor를 사용하여 만들어준다.
)
class CursorPagination<T> extends CursorPaginationBase{       //제네릭으로 타입을 넣어줌으로써 아래 data 가 제네릭으로 입력된 클래스로 만들어짐
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  factory CursorPagination.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>   // T라는 제너릭을 T의 factory constructor를 사용하여 json으로 만들어준다.
      _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}

class CursorPaginationRefetching<T> extends CursorPagination<T>{  //다시 처음부터 불러오기 = 새로고침 상태를 나타내는 클래스
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

class CursorPaginationFetchingMore<T> extends CursorPagination<T>{  //페이지네이션 다음 데이터를 요청할대의 상태를 나타내는 클래스
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}
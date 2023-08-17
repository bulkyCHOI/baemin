import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true, // 이 옵션을 켜놔야 제네릭으로 들어온 타입의 factory constructor를 사용하여 만들어준다.
)
class CursorPagination<T> {       //제네릭으로 타입을 넣어줌으로써 아래 data 가 제네릭으로 입력된 클래스로 만들어짐
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

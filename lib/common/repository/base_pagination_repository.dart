import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/common/model/pagination_params.dart';

//interface처럼 사용하기 위함 instance는 생성 불가
abstract class IBasePaginationRepository<T>{
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),  //build time에 정해지게 하기 위해서 const
  });
}
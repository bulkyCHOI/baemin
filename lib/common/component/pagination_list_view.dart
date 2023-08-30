import 'package:baemin/common/model/cursor_pagination_model.dart';
import 'package:baemin/common/model/model_with_id.dart';
import 'package:baemin/common/provider/pagination_provider.dart';
import 'package:baemin/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    //완전 처음 올딩일때
    if (state is CursorPaginationLoading) {
      //로딩중인 상태의 클래스이면
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    //에러
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(
                    forceRefetch: true,
                  );
            },
            child: Text('다시 시도'),
          )
        ],
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    final cp = state as CursorPagination<T>; //임시로 일단 이렇게 처리해서 아래 데이터를 유효하게 하자

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1, //맨 마지막에 로딩바를 보여주기 위해 하나 추가해놓고
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              //로딩처릴르 여기서 해준다.
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: cp is CursorPaginationFetchingMore //아래에 데이터가 더 있다면
                      ? CircularProgressIndicator() //로딩을 표시해주고
                      : Text('데이터가 마지막입니다 ㅠㅠ'), //없다면 메시지를 보여준다.
                ),
              );
            }
            final pItem = cp.data[index];

            return widget.itemBuilder(
              context,
              index,
              pItem,
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(
              height: 16.0,
            );
          },
        ));
  }
}

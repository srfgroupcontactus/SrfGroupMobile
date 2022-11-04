import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_app/src/modules/cart/screens/item_scroll_cart.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:my_app/src/shared/utils/interceptor.dart';

class InfiniteScrollCart extends StatefulWidget {

  final int selectedIndex;

  const InfiniteScrollCart({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _InfiniteScrollCartState createState() => _InfiniteScrollCartState();
}

class _InfiniteScrollCartState extends State<InfiniteScrollCart> {
  dynamic pageCarts;

  final PagingController<int, dynamic> _pagingController =
  PagingController(firstPageKey: 0);

  @override
  void initState() {
    print('selectedIndex selectedIndex = ${widget.selectedIndex}');
    _pagingController.addPageRequestListener((pageKey) {
      _search(pageKey);
    });
    super.initState();
  }

  void _search(int pageKey) async {
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}cart/current-user?page=${pageKey}&size=${ORDERS_PER_PAGE}';
    endPoint.method = 'get';
    callApi(endPoint, {}, context).then((result) {
      debugPrint('Success response carts: ${result}');
      setState(() {
        this.pageCarts = result;
        List responseList = result['content'];
        final isLastPage = responseList.length < ORDERS_PER_PAGE;
        if (isLastPage) {
          _pagingController.appendLastPage(responseList);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(responseList, nextPageKey);
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(() => _pagingController.refresh()),
                  child: PagedListView<int, dynamic>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        itemBuilder: (context, item, index) {
                          return ItemScrollCart(cart: item,);
                        }
                    ),
                  ),
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        )
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

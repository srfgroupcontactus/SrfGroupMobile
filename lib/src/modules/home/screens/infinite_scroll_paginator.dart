import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_app/src/shared/screens/item_offer.dart';
import '../../../shared/utils/interceptor.dart';
import 'package:my_app/src/shared/constants/constants.dart';

class InfiniteScrollPaginator extends StatefulWidget {
  @override
  _InfiniteScrollPaginatorState createState() => _InfiniteScrollPaginatorState();
}

class _InfiniteScrollPaginatorState extends State<InfiniteScrollPaginator> {
  dynamic pageOFfers;

  final PagingController<int, dynamic> _pagingController =
  PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _search(pageKey);
    });
    super.initState();
  }

  void _search(int pageKey) async {
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}offer/public?page=${pageKey}&size=${ORDERS_PER_PAGE}';
    endPoint.method = 'get';
    callApi(endPoint, {}, context).then((result) {
      // debugPrint('Success response: ${json.encode(result)}');
      setState(() {
        this.pageOFfers = result;
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
            Row(
              children: [
                new IconButton(
                  icon: Icon(Icons.filter_list_sharp),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search ...',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Search by title';
                      }
                      return null;
                    },
                  ),
                ),
                new IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                )
              ],
            ),
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(() => _pagingController.refresh()),
                  child: PagedListView<int, dynamic>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        itemBuilder: (context, item, index) {
                          return ItemOffer(offer: item);
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

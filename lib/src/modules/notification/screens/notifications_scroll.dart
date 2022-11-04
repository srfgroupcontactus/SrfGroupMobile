import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:my_app/src/shared/utils/interceptor.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScrollPaginator extends StatefulWidget {
  @override
  _INotificationsScrollPaginatorState createState() => _INotificationsScrollPaginatorState();
}

class _INotificationsScrollPaginatorState extends State<NotificationsScrollPaginator> {

  dynamic pageNotifications;

  final PagingController<int, dynamic> _pagingController =
  PagingController(firstPageKey: 0);

  void _getListMyNotifications(int pageKey) async {
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}notification/current-user?page=${pageKey}&size=${ORDERS_PER_PAGE}';
    endPoint.method = 'get';
    callApi(endPoint, {}, context).then((result) {
      // debugPrint('Success response: ${json.encode(result)}');
      setState(() {
        this.pageNotifications = result;
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
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getListMyNotifications(pageKey);
    });
    super.initState();
  }

  Widget contentSection(var notification) {
    print('notification ${notification}');
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
              child:Row(
                children: <Widget>[
                  CircleAvatar(
                    child: Icon(
                      Icons.notifications,
                      color: Colors.red[500],
                    ),
                    backgroundColor: Colors.transparent,
                    // backgroundColor: Colors.brown.shade800,
                    // child: const Text('AH'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${timeago.format(DateTime.parse(notification['dateCreated']))}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        Text(
                          '${notification['content']}',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
          /*3*/
//          Icon(
//            Icons.star,
//            color: Colors.red[500],
//          ),
          // Text('${offer['amount']!=null ? offer['amount'].toString() : '' }'),
          // Text('400'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(() => _pagingController.refresh()),
                  child: PagedListView<int, dynamic>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<dynamic>(
                        itemBuilder: (context, item, index) {
                          return contentSection(item);
                        }
                    ),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}

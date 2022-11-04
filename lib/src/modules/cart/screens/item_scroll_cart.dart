import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/src/modules/offer/screens/details-offer.dart';
import 'package:my_app/src/shared/utils/common_functions.dart';

class ItemScrollCart extends StatefulWidget {

  final dynamic cart;

  ItemScrollCart({Key? key, required this.cart}) : super(key: key);

  @override
  _ItemScrollCartState createState() => _ItemScrollCartState();

}

class _ItemScrollCartState extends State<ItemScrollCart> {

  @override
  Widget build(BuildContext context) {

    Widget mediaSection(var offer) {
      if(offer['offerImages']!=null && offer['offerImages'].length > 0 ){
        return CachedNetworkImage(
          imageUrl: getImageForOffer(offer['id'], offer['offerImages'][0]['path']),
          imageBuilder: (context, imageProvider) => Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                //image size fill
                image: imageProvider,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            alignment: Alignment.center,
            child:
            CircularProgressIndicator(), // you can add pre loader iamge as well to show loading.
          ), //show progress  while loading image
          errorWidget: (context, url, error) =>
              Image.asset('images/defaults/default_image.jpg'),
          //show no iamge availalbe image on error laoding
        );
      }
      return Container();
    }

    Widget titleSection(var cart) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
                child:Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                      getUserAvatar(cart['user']['id'], cart['user']['imageUrl'], cart['user']['sourceConnectedDevice']),
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
                            '${getFullnameUser(cart['user'])}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          Text(
                            'qsdq',
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
            Icon(
              Icons.star,
              color: Colors.red[500],
            ),
            // Text('${offer['amount']!=null ? offer['amount'].toString() : '' }'),
            Text('${cart['total']} TND'),
          ],
        ),
      );
    }

    // Color color = Theme.of(context).primaryColor;

    Widget buttonSection(var offer) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(Colors.grey[600], Icons.check, 'fssdf'),
          _buildButtonColumn(Colors.grey[600], Icons.near_me, 'ROUTE'),
          _buildButtonColumn(Colors.grey[600], Icons.share, 'SHARE'),
        ],
      );
    }

    Widget textSection(var offer) {
      return Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'fffff',
          softWrap: true,
        ),
      );
    };

    Widget conainerSection(item) {
      return new GestureDetector(
          onTap: () {
//            Navigator.of(context).push(MaterialPageRoute(
//                builder: (BuildContext context) =>
//                    DetailsOffer(id: item['id'])));
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 0, right: 0, top: 10, bottom: 0),
            child: Container(
              // height: 200,
              // color: Colors.deepPurple[200],
              color: Colors.white,
              child: Column(
                children: [
                  mediaSection(item),
                  titleSection(item),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, //change here don't //worked
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin:
                        EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0, right: 12.0),
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                            color: Colors.red, borderRadius: BorderRadius.circular(40.0)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "task.title",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Duration:',
                            style: TextStyle(color: Colors.black, fontSize: 14.0),
                          )
                        ],
                      ),
                      new Spacer(), // I just added one line
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                textStyle: const TextStyle(fontSize: 20),
                                backgroundColor: Colors.red
                            ),
                            child: Text('delete', style: TextStyle(color: Colors.white))
                        )
                      ),
                    ],
                  ),
                  // buttonSection(item),
                  textSection(item),
                ],
              ),
            ),
          ));
    };

    return conainerSection(widget.cart);
  }

  Column _buildButtonColumn(Color? color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}

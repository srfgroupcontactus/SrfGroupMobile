import 'package:flutter/material.dart';
import '../../../shared/utils/interceptor.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsOffer extends StatefulWidget {

  final int id;

  DetailsOffer({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsOfferState createState() => _DetailsOfferState();

}

class _DetailsOfferState extends State<DetailsOffer> {

  bool _isLoading = true;
  dynamic detailsOffer;

  void _getDetailsOffer(int offerId) async {
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}offer/public/${offerId}';
    endPoint.method = 'get';
    callApi(endPoint, {}, context).then((result) {
      // debugPrint('_getDetailsOffer Success response: ${json.encode(result)}');
      setState(() {
        this.detailsOffer = result;
        _isLoading = false;
      });
    });
  }


  @override
  void initState() {
    _getDetailsOffer(widget.id);
  }

  @override
  Widget build(BuildContext context) {

    print('offer id = ${widget.id}');

    Widget swipperSection = Image.asset(
      'images/defaults/default_image.jpg',
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Oeschinen Lake Campground',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Kandersteg, Switzerland',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const Text('41'),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'CALL'),
        _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
    );

    Widget textSection = Padding(
      padding: EdgeInsets.all(32),
      child: Html(
        // anchorKey: staticAnchorKey,
        data: "${this.detailsOffer!=null ? this.detailsOffer['offer']['description'] : ''}",
      )
    );

    Widget containerSection(){
      if( _isLoading ){
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                color: Colors.purple,
              ),
            ],
          ),
        );
      }else{
        return ListView(
          children: [
            swipperSection,
            titleSection,
            buttonSection,
            textSection,
          ]
        );
      }
    }

    return Scaffold(
          appBar: AppBar(
              title: Text("Details offer"),
              backgroundColor: Colors.amber,
          ),
          body: containerSection()
    );
  }


  Column _buildButtonColumn(Color color, IconData icon, String label) {
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
              color: color,
            ),
          ),
        ),
      ],
    );
  }

}

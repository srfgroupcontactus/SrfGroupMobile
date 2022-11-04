import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:my_app/src/shared/locale/app_locale.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../shared/utils/interceptor.dart';

const List<String> listTypesOffer = <String>[
  'SellOffer',
  'RentOffer',
  'FindOffer'
];

class AddUpdateOffer extends StatefulWidget {
  @override
  _AddUpdateOfferState createState() => _AddUpdateOfferState();
}

class _AddUpdateOfferState extends State<AddUpdateOffer> {
  List<XFile>? _imageFileList = [];

  List<String> items = List<String>.generate(10000, (i) => 'Item $i');
  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();

  final type_controller = TextEditingController();
  final title_controller = TextEditingController();
  final description_controller = TextEditingController();
  var _isLoading = false;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage(
          maxWidth: null,
          maxHeight: null,
          imageQuality: null,
        );
        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: null,
          maxHeight: null,
          imageQuality: null,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  Future<dynamic> uploadFiles(String offerId) async {
    print('Upload file with id ${offerId}');
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}offer/upload-images';
    endPoint.method = 'post';
    endPoint.isMultipart = true;
    endPoint.listFiles = _imageFileList;
    endPoint.requestFieldName = 'offerId';
    endPoint.requestFieldValue = offerId;
    callApi(
        endPoint, jsonEncode(<String, String>{}), context
    ).then((dynamic result){
      if( result=='true' ){
        setState(() => _isLoading = false);
        Navigator.pop(context);
      }
    }).catchError((error){
      print('Error response: ${error}');
    });

  }


  void _addOFfer(String email,
      String password,){
    setState(() => _isLoading = true);
    EndPoint endPoint = EndPoint();
    endPoint.url = '${baseUrl}sell-offer/create';
    endPoint.method = 'post';
    callApi(
        endPoint,
        jsonEncode(<String, dynamic>{
          'title': title_controller.text,
          'description': description_controller.text,
          'offerImages' : _imageFileList!.map((XFile image){
            return {
              'path': image.name
            };
          }).toList()
        }), context
    ).then((result){
      print('result add ${result}');
      setState(() {
        if( _imageFileList!.length == 0 ){
          this._isLoading = false;
          Navigator.pop(context);
        }
        else{
          uploadFiles(result['id'].toString());
        }
      });
    }).catchError((error){
      setState(() {
        this._isLoading = false;
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _buildHorizontalList() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return SizedBox(
          height: 150,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imageFileList!.length,
              itemBuilder: (_, index) {
                return Row(
                  children: <Widget>[
                    Container(
                        color: Colors.grey,
                        margin: new EdgeInsets.symmetric(horizontal: 10.0),
                        child: Stack(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Image.file(File(_imageFileList![index].path),
                                      width: 150, height: 150),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              width: 50,
                              height: 100,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                      tooltip: 'Increase volume by 10',
                                      iconSize: 30,
                                      onPressed: () {
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text('Remove'),
                                                  content: const Text(
                                                      'Remove this image'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Remove');
                                                        setState(() {
                                                          print(
                                                              "Remove image ${index}");
                                                          _imageFileList!
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      child: const Text(
                                                          'Remove',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                );
              }));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      // isVideo = false;
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _imageFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLocale>(builder: (context, provider, snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.add_offer_title_page),
          backgroundColor: Colors.amber,
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 15,),
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Type offer",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple, width: 1),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple, width: 1),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple, width: 1),
                                // borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              // fillColor: Colors.blueAccent,
                            ),
                            validator: (value) => value == null ? "Select your choice" : null,
                            // dropdownColor: Colors.blueAccent,
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: listTypesOffer.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }).toList()
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: title_controller,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.purple
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.purple),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Title',
                                hintText: 'Enter your title'),
                            validator: (val) => val!.length < 4
                                ? 'Your password is too Password too short..'
                                : null,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: description_controller,
                            maxLines: 6, //or null
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.purple
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.purple),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Description',
                                hintText: 'Enter your description'),
                            validator: (val) => val!.length < 4
                                ? 'Your password is too Password too short..'
                                : null,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      // _displayAllImages(),
                      _buildHorizontalList(),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: (){
                            if( _formKey.currentState!.validate() ){
                              _isLoading ? null : _addOFfer('', '');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            primary: Colors.purple,
                          ),
                          icon: _isLoading
                              ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                              : const Icon(Icons.add_circle),
                          label: const Text('Add offer'),
                        ),
                      ),
                    ])
            )
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  // isVideo = false;
                  _onImageButtonPressed(
                    ImageSource.gallery,
                    context: context,
                    isMultiImage: true,
                  );
                },
                heroTag: 'image1',
                tooltip: 'Pick Multiple Image from gallery',
                child: const Icon(Icons.photo_library),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  // isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
      );
    });
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

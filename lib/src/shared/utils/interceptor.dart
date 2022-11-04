import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/src/shared/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String appToken = "tokenCurrentUser";

class ApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final cache = await SharedPreferences.getInstance();
      final token = cache.getString(appToken);

      if (token != '') {
        data.headers[HttpHeaders.authorizationHeader] = 'Bearer ${token}';
      }

      data.headers[HttpHeaders.contentTypeHeader] = "application/json; charset=UTF-8";
      data.headers['sourceConnectedDevice'] = SourceProvider['ANDROID'].toString();
      data.headers['langKey'] = "fr";
    } catch (e) {
      print(e);
    }
    print(data.params);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}


class EndPoint {
  late String url;
  late String method;
  late String? useMock;
  late String? baseUrl;
  late String? loading;
  late bool? isMultipart = false;
  late List<XFile>? listFiles;
  late String? requestFieldName;
  late String? requestFieldValue;
}


Future callApi(
    EndPoint endpoint,
    var requestData,
    BuildContext context) async {
  var parsedResponse;
  var response;


  InterceptedClient _client = InterceptedClient.build(interceptors: [
    ApiInterceptor(),
  ]);

  try {

    var url = Uri.parse(endpoint.url);

    if( endpoint.method == 'get' ){
      response = await _client.get(url);
    }
    else if( endpoint.method == 'post' ){

      if( endpoint.isMultipart == true ){

        http.MultipartRequest request = http.MultipartRequest('POST', url);
        for(var i = 0; i < endpoint.listFiles!.length; i++) {
          request.files.add(await http.MultipartFile.fromPath('files', endpoint.listFiles![i].path));
        }
        request.fields[endpoint.requestFieldName.toString()] = endpoint.requestFieldValue.toString();


        final cache = await SharedPreferences.getInstance();
        final token = cache.getString(appToken);

        if (token != '') {
          request.headers[HttpHeaders.authorizationHeader] = 'Bearer ${token}';
        }

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          return response.stream.bytesToString();
        }
        else {
          return Future.error('Unexpected error 😢');
        }
      }
      else{
        response = await _client.post(url, body: requestData);
      }
    }

    if (response.statusCode == 201 || response.statusCode == 200 ) {

      print('Result response : ${response.body}');

      // Show success message
      showSuccessAlert(response, context);
     parsedResponse = json.decode(utf8.decode(response.bodyBytes));
    } else {
      // Error message
      showErrorAlert(response, context);
      return Future.error(response.body);
    }
  } on SocketException {
    return Future.error('No Internet connection 😑');
  } on FormatException {
    return Future.error('Bad response format 👎');
  } on Exception catch (error) {
    return Future.error('Unexpected error 😢');
  }
  return parsedResponse;
}


/**
 * Show Error message
 */
void showErrorAlert(dynamic response, BuildContext context){
  if(json.decode(response.body)!=null){
    String msg = (json.decode(response.body))['message'];
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.deepOrange,
      content: Text(msg),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'ACTION',
        onPressed: () { },
      ),
    ));
  }
}


/**
 * Show success message
 */
void showSuccessAlert(dynamic response, BuildContext context){
  if(response.headers!=null){
    var msg = response.headers['x-app-alert'];
    if( msg!= null ){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(msg),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.purple,
          onPressed: () { },
        ),
      ));
    }
  }
}

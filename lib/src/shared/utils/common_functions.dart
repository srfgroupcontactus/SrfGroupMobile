import 'package:flutter/material.dart';
import 'package:my_app/src/shared/constants/constants.dart';


getFullnameUser(var user){
  return user['firstName']!='' || user['lastName']!=''
      ? user['firstName'] + " " + user['lastName']
      : user['email'];
}

/**
 *
 */
getUserAvatar(
var userId,
var imageUrl,
var sourceConnectedDevice){
  if (
  sourceConnectedDevice == SourceProvider['WEB_BROWSER'] ||
  sourceConnectedDevice == SourceProvider['MOBILE_BROWSER']
  ) {
    if (imageUrl==null || imageUrl=='') {
      return AssetImage('images/defaults/avatar.png');
    }
    return NetworkImage('${APP_API_END_POINT}api/user/public/avatar/${userId}/${imageUrl}');
  }

  // GooglePlus or Facebook
  return NetworkImage(imageUrl);
}


/**
 *
 */
getImageForOffer(var offerId, var path){
  return '${APP_API_END_POINT}api/offer/public/files/${offerId}/${path}';
}

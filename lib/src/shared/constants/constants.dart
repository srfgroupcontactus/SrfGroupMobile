const APP_API_END_POINT = 'http://192.168.110.96:8080/';
const baseUrl = '${APP_API_END_POINT}api/';
const urlWS = 'https://srf-group-back.herokuapp.com/';
const oneSignalId = '52e18c28-761d-409f-a363-f58a9bd41cfe';
const currentUserStorage = 'currentUser';
const tokenCurrentUserStorage = 'tokenCurrentUser';
const ORDERS_PER_PAGE = 10;
const SourceProvider = {
  "WEB_BROWSER": "WebBrowser",
  "MOBILE_BROWSER": "MobileBrowser",
  "GOOGLE_PLUS": "GooglePlus",
  "GOOGLE_ONE_TAP_LOGIN": "GoogleOneTapLogin",
  "FACEBOOK": "Facebook",
  "ANDROID": "Android"
};

const TypeOfferEnum = {
  "Sell": "SellOffer",
  "Rent": "RentOffer",
  "Find": "FindOffer",
};

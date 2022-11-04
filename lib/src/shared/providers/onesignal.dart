import 'package:my_app/src/shared/constants/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

String _debugLabelString = "";
String? _emailAddress;
String? _smsNumber;
String? _externalUserId;
String? _language;
bool _enableConsentButton = false;

// CHANGE THIS parameter to true if you want to test GDPR privacy consent
bool _requireConsent = true;

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initOneSignal() async {

  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(oneSignalId);

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  /*
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    // this.setState(() {
      _debugLabelString =
      "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    // });
  });

  OneSignal.shared
      .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    print('FOREGROUND HANDLER CALLED WITH: ${event}');
    /// Display Notification, send null to not display
    event.complete(null);

    // this.setState(() {
      _debugLabelString =
      "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    // });
  });

  OneSignal.shared
      .setInAppMessageClickedHandler((OSInAppMessageAction action) {
    // this.setState(() {
      _debugLabelString =
      "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
    // });
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
  });

  OneSignal.shared.setEmailSubscriptionObserver(
          (OSEmailSubscriptionStateChanges changes) {
        print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
      });

  OneSignal.shared.setSMSSubscriptionObserver(
          (OSSMSSubscriptionStateChanges changes) {
        print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
      });

  OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
    print("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
  });

  OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
    print("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
  });

  OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
    print("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
  });

  OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
    print("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
  });

  // NOTE: Replace with your own app ID from https://www.onesignal.com
  OneSignal.shared
    .setAppId(oneSignalAppId)
    .then((value){
      print("Init OneSignal Successfully");
      OneSignal.shared.getDeviceState().then((deviceState){
        print("DeviceState: ${deviceState?.userId?.toString()}");
      });
    });


  // iOS-only method to open launch URLs in Safari when set to false
  OneSignal.shared.setLaunchURLsInApp(false);

  bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
  print("requiresConsent: $requiresConsent");

  // this.setState(() {
    _enableConsentButton = requiresConsent;
  // });

  // Some examples of how to use In App Messaging public methods with OneSignal SDK
  // oneSignalInAppMessagingTriggerExamples();

  OneSignal.shared.disablePush(false);

  // Some examples of how to use Outcome Events public methods with OneSignal SDK
  // oneSignalOutcomeEventsExamples();

  bool userProvidedPrivacyConsent = await OneSignal.shared.userProvidedPrivacyConsent();
  print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
  */

}

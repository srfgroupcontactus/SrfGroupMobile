import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter/material.dart';
import 'src/modules/contact-us/screens/contact_us.dart';
import 'package:my_app/src/modules/main/screens/main.screen.dart';
import 'package:my_app/src/modules/notification/screens/notification.dart';
import 'package:my_app/src/modules/offer/screens/add_update.dart';
import 'package:my_app/src/modules/settings/screens/settings.dart';
import 'package:my_app/src/modules/user/screens/activate-account/activate-account.dart';
import 'package:my_app/src/modules/user/screens/register/register.dart';
import 'src/modules/offer/screens/details-offer.dart';
import 'package:my_app/src/modules/user/viewmodel/session.viewmodel.dart';
import 'src/modules/user/screens/login/login.dart';
import 'package:my_app/src/modules/home/screens/home.screen.dart';
import 'package:my_app/src/modules/user/viewmodel/login.viemodel.dart';
import 'package:provider/provider.dart';
import 'package:my_app/src/shared/providers/onesignal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/shared/locale/app_locale.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  AppLocale appLocale = AppLocale();
  appLocale.fetchLocale();

  // Init OneSignal
  initOneSignal();

  // Init WS
  // initWebsocket();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>AuthViewModel()),
        ChangeNotifierProvider(create: (_)=>SessionViewModel()),
        ChangeNotifierProvider(create: (_)=>AppLocale())
      ],
      child: Consumer<AppLocale>(builder: (context, provider, snapshot) {
        return MaterialApp(
          locale: provider.locale,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('fr', ''), // Spanish, no country code
            Locale('en', ''), // English, no country code
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => MainPage(),
            // '/': (context) => HomePage(title: 'Recherche'),
            '/home': (context) => HomePage(title: 'Recherche'),
            '/login': (context) => Login(),
            'register': (context) => Register(),
            '/details-offer': (context) => DetailsOffer(id: -1),
            '/settings': (context) => Settings(),
            '/activation-account': (context) => ActivateAccount(),
            '/add-update': (context) => AddUpdateOffer(),
            '/notifications': (context) => Notifications(),
            '/contact-us': (context) => ContactUs()
          },
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.purple,
            scaffoldBackgroundColor: Colors.grey[300],
          )
        );
      }
    )
  );

  }
}

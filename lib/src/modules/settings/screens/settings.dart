import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_app/src/shared/locale/app_locale.dart';
import 'package:provider/provider.dart';

const List<String> list = <String>['fr', 'en'];

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppLocale>(builder: (context, provider, snapshot) {
      dropdownValue = provider.locale == Locale('fr') ? 'fr' : 'en';

      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.settings_title_page),
            backgroundColor: Colors.amber[600],
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      print('changeLocale ${value}');
                      dropdownValue = value!;
                      provider.changeLocale(Locale(value));
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )
            ],
          )

      );
    });
  }
}

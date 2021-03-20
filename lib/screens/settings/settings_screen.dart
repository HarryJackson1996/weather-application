import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_application/utils/enums.dart';
import 'package:weather_application/widgets/themed_text.dart';
import 'widgets/settings_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).backgroundColor,
          statusBarIconBrightness: Theme.of(context).primaryColorBrightness,
        ),
        elevation: 0.0,
        centerTitle: true,
        title: ThemedText(
          'Settings',
          themedTextStyle: ThemedTextStyle.H1,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            SettingsItem(
              title: 'Theme',
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weather_application/models/weather_model.dart';
import 'package:weather_application/screens/weather/widgets/weather/vertical_weather_item.dart';
import 'package:weather_application/utils/date_utils.dart';
import 'package:weather_application/utils/weather_icons_icons.dart';

class ForecastWeatherItem extends StatelessWidget {
  final Weather weather;

  ForecastWeatherItem(this.weather);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: VerticalWeatherWidget(
                primaryText: MyDateUtils.convertUnixToDateString(weather.dt, 'EEE, HH:00'),
                iconData: WeatherIcons.getWeatherIcon(weather.icon),
                value: weather.temp + "\u00B0",
                iconFlex: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

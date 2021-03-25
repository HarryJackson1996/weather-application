import 'package:hive/hive.dart';
import 'package:weather_application/consts/consts.dart';
import 'package:weather_application/consts/screen_consts.dart';
import 'package:weather_application/models/weather_model.dart';
import 'package:weather_application/utils/date_utils.dart';
import 'package:weather_application/utils/enums.dart';
import 'package:weather_application/widgets/annotated_scaffold.dart';
import 'package:weather_application/widgets/themed_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_application/blocs/weather/weather_bloc.dart';
import 'package:weather_application/screens/weather/widgets/forecast/forecast_weather.dart';
import 'package:weather_application/screens/weather/widgets/weather/weather_card.dart';
import '../search/search_screen.dart';
import '../../utils/extensions/extensions.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        Weather weather = Hive.box<Weather>(weatherBoxKey).get(weatherBoxKey);
        String myCity = weather?.name ?? 'London';
        if (MyDateUtils.timeDifference(weather.dt, 20)) {
          BlocProvider.of<WeatherBloc>(context).add(
            WeatherFetchedEvent(id: weatherBoxKey, city: myCity, unit: 'Metric'),
          );
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        String myCity = Hive.box<Weather>(weatherBoxKey).get(weatherBoxKey)?.name ?? 'London';
        return AnnotatedScaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ThemedText(
                  myCity,
                  themedTextStyle: ThemedTextStyle.H1,
                )
              ],
            ),
            leading: IconButton(
              icon: Container(
                child: Icon(
                  Icons.refresh,
                  color: Theme.of(context).buttonColor,
                ),
              ),
              onPressed: () async {
                BlocProvider.of<WeatherBloc>(context)
                  ..add(
                    WeatherFetchedEvent(id: weatherBoxKey, city: myCity, unit: 'Metric'),
                  );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).buttonColor,
                ),
                onPressed: () async {
                  showSearch(context: context, delegate: SearchScreen());
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).buttonColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, settingsRoute);
                },
              ),
            ],
          ),
          body: _mapWeatherStateToWidget(state),
        );
      },
    );
  }

  Widget _mapWeatherStateToWidget(WeatherState state) {
    if (state is WeatherLoadSuccess) {
      if (_controller == null) {
        _controller = AnimationController(duration: Duration(milliseconds: 1200), vsync: this);
      }
      _controller.reset();
      _controller.forward();

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(
                right: myPadding,
                bottom: myPadding / 2,
                top: myPadding / 2,
                left: myPadding,
              ),
              color: Theme.of(context).backgroundColor,
              child: CurrentWeatherCard(state.weather),
            ).animate(
              _controller,
              start: 0.2,
              end: 0.7,
              curve: Curves.linear,
              animationType: AnimationType.FADE,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: ForecastWeather(state.weather.forecast.forecast),
            ).animate(
              _controller,
              start: 0.4,
              end: 0.9,
              curve: Curves.linear,
              animationType: AnimationType.FADE,
            ),
          ),
        ],
      ).addTopbarPadding();
    }
    if (state is WeatherLoadFailure) {
      return Center(child: Text('Unable to fetch Weather'));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

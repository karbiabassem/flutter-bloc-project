import 'package:bloc_ptoject/bloc/weather_bloc.dart';
import 'package:bloc_ptoject/data/model/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<WeatherBloc, WeatherState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is WeatherInitial) {
                return buildInitialInput();
              } else if (state is WeatherLoading) {
                return buildLoading();
              } else if (state is WeatherLoaded) {
                return buildColumnWithData(context, state.weather);
              } else if (state is WeatherError) {
                return buildInitialInput();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(weather.cityName,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700)),
        Text(
          "${weather.temperatureCelsius.toStringAsFixed(1)}",
          style: TextStyle(fontSize:80),
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child:TextField(
        onSubmitted: (value) =>submitCityName(context,value) ,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(hintText: "Enter a city",
        border:OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon:Icon(Icons.search)
        ),
      )
    );
  }
  void submitCityName(BuildContext context, String cityName) {
    // Get the Bloc using the BlocProvider
    // False positive lint warning, safe to ignore until it gets fixed...
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    // Initiate getting the weather
    weatherBloc.add(GetWeather(cityName));
  }
}

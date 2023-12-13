import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchBarController = TextEditingController();

  late Future<Weather> weatherData;

  @override
  void initState() {
    super.initState();

    weatherData = getDataByCoordinates();
  }

  Future<Weather> getDataByCity(String city) {
    return WeatherService().getWeatherByCity(city);
  }

  Future<Weather> getDataByCoordinates() async {
    return WeatherService().getWeatherByCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        forceMaterialTransparency: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CupertinoSearchTextField(
              controller: searchBarController,
              onSubmitted: (value) => setState(() {
                weatherData = getDataByCity(value);
              }),
              style: const TextStyle(
                color: Colors.grey
              ),
              onSuffixTap: () => setState(() {
                searchBarController.text='';
                weatherData = getDataByCoordinates();
              }),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).pushNamed("/favourites"), icon: const Icon(Icons.favorite)),
          const SizedBox(width: 16.0),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favourites').listenable(),
        builder: (context, Box favouritesBox, _) {
          return FutureBuilder(
            future: weatherData,
            builder: (context, AsyncSnapshot<Weather> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Text('No data available');
              } else {
                Weather weather = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            weather.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            onPressed: () {
                              int index = favouritesBox.values
                                  .toList()
                                  .indexOf(weather.name);

                              if (index != -1) {
                                Hive.box('favourites').deleteAt(index);
                              } else {
                                Hive.box('favourites').add(weather.name);
                              }
                            },
                            icon: favouritesBox.values.contains(weather.name)
                                ? const Icon(Icons.bookmark, color: Colors.red,)
                                : const Icon(Icons.bookmark_outline),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${weather.main.temp?.round()}°C',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Image.network(
                            "https://openweathermap.org/img/wn/${weather.weather.first.icon}@4x.png",
                          ),
                        ],
                      ),
                      Text(
                        'Weather Condition: ${weather.weather.first.description}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'Wind Speed: ${weather.wind.speed}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

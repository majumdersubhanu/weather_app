import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/api_service.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getFavouriteCities(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favourite cities'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: WeatherService()
                        .getWeatherByCity(snapshot.data![index]),
                    builder: (context, AsyncSnapshot<Weather> weatherSnapshot) {
                      if (weatherSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox(); // Do not show loading for now
                      } else if (weatherSnapshot.hasError) {
                        return _buildErrorCard(snapshot.data![index],
                            weatherSnapshot.error.toString());
                      } else if (!weatherSnapshot.hasData) {
                        return _buildErrorCard(
                            snapshot.data![index], 'No data available');
                      } else {
                        Weather weather = weatherSnapshot.data!;
                        return _buildWeatherCard(weather);
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildWeatherCard(Weather weather) {
    return ListTile(
      title: Text(
        weather.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      leading: Image.network(
        "https://openweathermap.org/img/wn/${weather.weather.first.icon}@4x.png",
        height: 40,
        width: 40,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Temperature: ${weather.main.temp?.round()}°C',
              style: const TextStyle(fontSize: 16)),
          Text('Weather: ${weather.weather.first.description}',
              style: const TextStyle(fontSize: 16)),
        ],
      ),

    );
  }

  Widget _buildErrorCard(String cityName, String errorMessage) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          cityName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Error: $errorMessage',
            style: const TextStyle(fontSize: 16, color: Colors.red)),
      ),
    );
  }

  Future<List<String>> getFavouriteCities() async {
    var favouritesBox = Hive.box('favourites');
    return favouritesBox.values.toList().cast<String>();
  }
}

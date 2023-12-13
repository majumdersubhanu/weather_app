import 'dart:convert';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utils/constants.dart';

class WeatherService {
  WeatherService();

  Future<Weather> getWeatherByCity(String city) async {
    final response = await http
        .get(Uri.parse('${baseUrl}q=$city&appid=$apiKey$optionalParameters'));

    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedBody = json.decode(response.body);
      return Weather.fromJson(decodedBody);
    } else if (response.statusCode == 404) {
      throw Exception('Place not found');
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Weather> getWeatherByCurrentLocation() async {
    Position position = await determinePosition();
    var lat = position.latitude;
    var lon = position.longitude;
    final response = await http.get(Uri.parse(
        '${baseUrl}lat=$lat&lon=$lon&appid=$apiKey$optionalParameters'));

    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedBody = json.decode(response.body);
      return Weather.fromJson(decodedBody);
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

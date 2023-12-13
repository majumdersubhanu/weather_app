import 'package:freezed_annotation/freezed_annotation.dart';

import 'main_model.dart';
import 'weather_detail_model.dart';
import 'wind_model.dart';

part 'weather_model.freezed.dart';

part 'weather_model.g.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    required List<WeatherDetail> weather,
    required Main main,
    required Wind wind,
    required String name,
  }) = _Weather;

  factory Weather.fromJson(Map<String, Object?> json) =>
      _$WeatherFromJson(json);
}

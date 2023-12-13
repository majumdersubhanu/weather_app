import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_detail_model.freezed.dart';

part 'weather_detail_model.g.dart';

@freezed
class WeatherDetail with _$WeatherDetail {
  const factory WeatherDetail({
    required int? id,
    required String? main,
    required String? description,
    required String? icon,
  }) = _WeatherDetail;

  factory WeatherDetail.fromJson(Map<String, Object?> json) =>
      _$WeatherDetailFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wind_model.freezed.dart';

part 'wind_model.g.dart';

@freezed
class Wind with _$Wind {
  const factory Wind({
    required double? speed,
    required double? deg,
    required double? gust,
  }) = _Wind;

  factory Wind.fromJson(Map<String, Object?> json) =>
      _$WindFromJson(json);
}

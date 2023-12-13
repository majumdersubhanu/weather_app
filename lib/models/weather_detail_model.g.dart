// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeatherDetailImpl _$$WeatherDetailImplFromJson(Map<String, dynamic> json) =>
    _$WeatherDetailImpl(
      id: json['id'] as int?,
      main: json['main'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$WeatherDetailImplToJson(_$WeatherDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

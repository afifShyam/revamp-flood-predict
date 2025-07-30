import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
sealed class WeatherModel with _$WeatherModel {
  factory WeatherModel({
    @Default(0.0) final double temp,
    @Default(0) final int humidity,
    @Default('') final String name,
    @Default('') final String country,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);
}

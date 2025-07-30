import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_model.freezed.dart';
part 'forecast_model.g.dart';

@freezed
sealed class ForecastModel with _$ForecastModel {
  const ForecastModel._();

  const factory ForecastModel({
    @Default(0.0) double? temp,
    @Default(0) int? humidity,
    @Default(0.0) double? rain,
    @Default(0) int? date,
  }) = _ForecastModel;

  factory ForecastModel.fromJson(Map<String, dynamic> json) => _$ForecastModelFromJson(json);
}


import 'package:equatable/equatable.dart';
import 'package:wheather_app/features/feature_weather/data/models/for_cast_city_model.dart';

class ForecastDaysEntity extends Equatable{
  final double? lat;
  final double? lon;
  final String? timezone;
  final int? timezoneOffset;
  final Current? current;
  final List<Daily>? daily;
  final List<Alerts>? alerts;

  ForecastDaysEntity({
    this.lat,
    this.lon,
    this.timezone,
    this.timezoneOffset,
    this.current,
    this.daily,
    this.alerts});

  @override
  // TODO: implement props
  List<Object?> get props => [
    lat,
    lon,
    timezone,
    timezoneOffset,
    current,
    daily,
    alerts,
  ];

  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
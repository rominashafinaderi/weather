
import'package:flutter/material.dart';
import 'package:wheather_app/features/feature_weather/domain/entites/current_city_entity.dart';
@immutable
abstract class CwStatus{

 }
 class CwLoading extends CwStatus{}
 class CwCompleted extends CwStatus{
  final CurrentcityEntity currentcityEntity;
  CwCompleted(this.currentcityEntity);
 }
 class CwError extends CwStatus{
  final String message;

  CwError(this.message);

 }
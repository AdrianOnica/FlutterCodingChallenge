import 'package:coding_challenge/model/Events.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AppState extends Equatable {}

class LoadingState extends AppState {
  @override
  List<Object?> get props => [];
}

class GetEventsState extends AppState {
  final List<Events> events;
  GetEventsState({required this.events});
  @override
  List<Object?> get props => [events];
}

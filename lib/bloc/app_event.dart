import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AppEvent extends Equatable {}

class LoadEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

import 'package:coding_challenge/bloc/app_event.dart';
import 'package:coding_challenge/bloc/app_state.dart';
import 'package:coding_challenge/model/Events.dart';
import 'package:coding_challenge/repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final Repository _repository;

  AppBloc(this._repository) : super(LoadingState()) {
    on<LoadEvent>((event, emit) async {
      try {
      List<Events>? events = await _repository.getEvents();
        emit(GetEventsState(events: events!));
      }catch(e) {
        emit(LoadingState());
      }
    });
  }
}

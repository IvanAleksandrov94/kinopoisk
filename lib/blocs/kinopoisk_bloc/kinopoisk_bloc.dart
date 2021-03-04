import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'kinopoisk_event.dart';
part 'kinopoisk_state.dart';

class KinopoiskBloc extends Bloc<KinopoiskEvent, KinopoiskState> {
  KinopoiskBloc() : super(KinopoiskInitialState());

  @override
  Stream<KinopoiskState> mapEventToState(
    KinopoiskEvent event,
  ) async* {
    if (event is KinopoiskInitialEvent) {
      yield* mapToInitState(event);
    }
  }

  Stream<KinopoiskState> mapToInitState(KinopoiskInitialEvent event) async* {
    yield KinopoiskInitialState();
  }
}

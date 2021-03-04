import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sqlbloc_event.dart';
part 'sqlbloc_state.dart';

class SqlBloc extends Bloc<SqlEvent, SqlState> {
  SqlBloc() : super(SqlInitialState());

  @override
  Stream<SqlState> mapEventToState(
    SqlEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

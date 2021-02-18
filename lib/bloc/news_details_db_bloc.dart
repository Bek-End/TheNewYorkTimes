import 'dart:io';

import 'package:NYTimesApp/bloc/switch_screen_bloc.dart';
import 'package:NYTimesApp/database/database_provider.dart';
import 'package:NYTimesApp/models/home_news_db_model.dart';
import 'package:rxdart/rxdart.dart';

//events
abstract class NewsDetailsDBEvents {}

class NewsDetailsDBInitialEvent extends NewsDetailsDBEvents {
  final HomeNewsDBModel homeNewsDBModel;
  NewsDetailsDBInitialEvent({this.homeNewsDBModel});
}

class NewsDetailsDBDeleteEvent extends NewsDetailsDBEvents {
  final HomeNewsDBModel homeNewsDBModel;
  NewsDetailsDBDeleteEvent({this.homeNewsDBModel});
}

//states
abstract class NewsDetailsDBStates {}

class NewsDetailsDBInitialState extends NewsDetailsDBStates {
  final HomeNewsDBModel homeNewsDBModel;
  NewsDetailsDBInitialState({this.homeNewsDBModel});
}

class NewsDetailsDBDeletedState extends NewsDetailsDBStates {}

//bloc
class NewsDetailsDBBloc {
  BehaviorSubject<NewsDetailsDBStates> _subject =
      BehaviorSubject<NewsDetailsDBStates>();
  BehaviorSubject<NewsDetailsDBStates> get subject => _subject;

  NewsDetailsDBBloc._();
  static final bloc = NewsDetailsDBBloc._();

  void mapEventToState(NewsDetailsDBEvents event) async {
    switch (event.runtimeType) {
      case NewsDetailsDBInitialEvent:
        NewsDetailsDBInitialEvent initialEvent = event;
        _subject.sink.add(NewsDetailsDBInitialState(
            homeNewsDBModel: initialEvent.homeNewsDBModel));
        break;
      case NewsDetailsDBDeleteEvent:
        NewsDetailsDBDeleteEvent dbDeleteEvent = event;
        _subject.sink.add(NewsDetailsDBDeletedState());
        await Future.delayed(Duration(seconds: 1));
        DatabaseProvider.db.deleteFileFromLocaStorage(
            File(dbDeleteEvent.homeNewsDBModel.path));
        DatabaseProvider.db.delete(dbDeleteEvent.homeNewsDBModel);
        SwitchScreenBloc.bloc.mapEventToState(SwitchScreenEvents.MAIN);
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

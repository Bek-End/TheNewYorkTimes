import 'package:NYTimesApp/bloc/news_details_bloc.dart';
import 'package:NYTimesApp/bloc/switch_screen_bloc.dart';
import 'package:NYTimesApp/models/home_news_model.dart';
import 'package:NYTimesApp/models/home_news_response.dart';
import 'package:NYTimesApp/repository/project_repo.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

//events
abstract class TodayTabEvents {}

class TodayTabInitialEvent extends TodayTabEvents {}

class TodayTabOnTapEvent extends TodayTabEvents {
  final Results news;

  TodayTabOnTapEvent({this.news});
}

//states
abstract class TodayTabStates {}

class TodayTabInitialState extends TodayTabStates {
  final HomeNewsResponse homeNewsResponse;

  TodayTabInitialState({this.homeNewsResponse});
}

class TodayTabNoInternetState extends TodayTabStates {}

//bloc
class TodayTabBloc {
  BehaviorSubject<TodayTabStates> _subject = BehaviorSubject<TodayTabStates>();
  BehaviorSubject<TodayTabStates> get subject => _subject;

  TodayTabBloc._();
  static final bloc = TodayTabBloc._();
  Connectivity connectivity = Connectivity();

  void mapEventToState(TodayTabEvents event) async {
    ConnectivityResult connect = await connectivity.checkConnectivity();
    if (connect == ConnectivityResult.none) {
      _subject.sink.add(TodayTabNoInternetState());
    } else {
      switch (event.runtimeType) {
        case TodayTabInitialEvent:
          _subject.sink.add(TodayTabInitialState(
              homeNewsResponse: await projectRepo.getNews()));
          break;
        case TodayTabOnTapEvent:
          TodayTabOnTapEvent tapEvent = event;
          NewsDetailsBloc.bloc
              .mapEventToState(NewsDetailsInitialEvent(news: tapEvent.news));
          SwitchScreenBloc.bloc
              .mapEventToState(SwitchScreenEvents.NEWS_DETAILS);
          break;
      }
    }
  }

  void dispose() {
    _subject?.close();
  }
}

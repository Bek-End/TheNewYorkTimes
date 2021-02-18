import 'package:NYTimesApp/bloc/news_details_db_bloc.dart';
import 'package:NYTimesApp/bloc/switch_screen_bloc.dart';
import 'package:NYTimesApp/bloc/today_tab_bloc.dart';
import 'package:NYTimesApp/database/database_provider.dart';
import 'package:NYTimesApp/models/home_news_db_model.dart';
import 'package:rxdart/rxdart.dart';

//events
abstract class SavedTabEvents {}

class SavedTabInitialEvent extends SavedTabEvents {}

class SavedTabOnTapEvent extends SavedTabEvents {
  final HomeNewsDBModel homeNewsDBModel;
  SavedTabOnTapEvent({this.homeNewsDBModel});
}

//states
abstract class SavedTabStates {}

class SavedTabInitialState extends SavedTabStates {
  final List<HomeNewsDBModel> homeNewsDBModels;
  SavedTabInitialState({this.homeNewsDBModels});
}

//bloc
class SavedTabBloc {
  BehaviorSubject<SavedTabStates> _subject = BehaviorSubject<SavedTabStates>();
  BehaviorSubject<SavedTabStates> get sunject => _subject;

  void mapEventToState(SavedTabEvents event) async {
    switch (event.runtimeType) {
      case SavedTabInitialEvent:
        List<HomeNewsDBModel> homeNewsDBModels =
            await DatabaseProvider.db.getAllNews();
        _subject.sink
            .add(SavedTabInitialState(homeNewsDBModels: homeNewsDBModels));
        break;
      case SavedTabOnTapEvent:
        SavedTabOnTapEvent tabOnTapEvent = event;
        NewsDetailsDBBloc.bloc.mapEventToState(NewsDetailsDBInitialEvent(
            homeNewsDBModel: tabOnTapEvent.homeNewsDBModel));
        SwitchScreenBloc.bloc
            .mapEventToState(SwitchScreenEvents.NEWS_SAVED_DETAILS);
    }
  }

  SavedTabBloc._();
  static final bloc = SavedTabBloc._();

  void dispose() {
    _subject?.close();
  }
}

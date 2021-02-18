import 'package:rxdart/rxdart.dart';

enum SwitchScreenEvents { MAIN, NEWS_DETAILS, NEWS_SAVED_DETAILS }

enum SwitchScreenStates { MAIN, NEWS_DETAILS, NEWS_SAVED_DETAILS }

class SwitchScreenBloc {
  BehaviorSubject<SwitchScreenStates> _subject =
      BehaviorSubject<SwitchScreenStates>();
  BehaviorSubject<SwitchScreenStates> get subject => _subject;

  final defaultState = SwitchScreenStates.MAIN;

  SwitchScreenBloc._();
  static final bloc = SwitchScreenBloc._();

  void mapEventToState(SwitchScreenEvents event) {
    switch (event) {
      case SwitchScreenEvents.MAIN:
        _subject.sink.add(SwitchScreenStates.MAIN);
        break;
      case SwitchScreenEvents.NEWS_DETAILS:
        _subject.sink.add(SwitchScreenStates.NEWS_DETAILS);
        break;
      case SwitchScreenEvents.NEWS_SAVED_DETAILS:
        _subject.sink.add(SwitchScreenStates.NEWS_SAVED_DETAILS);
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

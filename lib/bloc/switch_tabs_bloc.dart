import 'package:rxdart/rxdart.dart';

enum SwitchTabsEvents { TODAY, SAVED, FOR_YOU, SECTIONS }
enum SwitchTabsStates { TODAY, SAVED, FOR_YOU, SECTIONS }

class SwitchTabsBloc {
  BehaviorSubject<SwitchTabsStates> _subject =
      BehaviorSubject<SwitchTabsStates>();
  BehaviorSubject<SwitchTabsStates> get subject => _subject;

  SwitchTabsStates currentState = SwitchTabsStates.TODAY;

  SwitchTabsBloc._();
  static final bloc = SwitchTabsBloc._();

  void mapEventToState(SwitchTabsEvents event) {
    switch (event) {
      case SwitchTabsEvents.TODAY:
        _subject.sink.add(SwitchTabsStates.TODAY);
        currentState = SwitchTabsStates.TODAY;
        break;
      case SwitchTabsEvents.SAVED:
        _subject.sink.add(SwitchTabsStates.SAVED);
        currentState = SwitchTabsStates.SAVED;

        break;
      case SwitchTabsEvents.FOR_YOU:
        _subject.sink.add(SwitchTabsStates.FOR_YOU);
        currentState = SwitchTabsStates.FOR_YOU;

        break;
      case SwitchTabsEvents.SECTIONS:
        _subject.sink.add(SwitchTabsStates.SECTIONS);
        currentState = SwitchTabsStates.SECTIONS;
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

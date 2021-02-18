import 'package:NYTimesApp/bloc/switch_screen_bloc.dart';
import 'package:NYTimesApp/screens/main_screen.dart';
import 'package:NYTimesApp/screens/news_details_db_screen.dart';
import 'package:NYTimesApp/screens/news_details_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: SwitchScreenBloc.bloc.subject.stream,
        initialData: SwitchScreenBloc.bloc.defaultState,
        builder: (context, AsyncSnapshot<SwitchScreenStates> snapshot) {
          switch (snapshot.data) {
            case SwitchScreenStates.MAIN:
              return MainScreen();
              break;
            case SwitchScreenStates.NEWS_DETAILS:
              return NewsDetailsScreen();
              break;
            case SwitchScreenStates.NEWS_SAVED_DETAILS:
              return NewsDetailsDBScreen();
              break;
          }
          return Scaffold();
        });
  }
}

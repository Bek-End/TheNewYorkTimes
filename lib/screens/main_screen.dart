import 'package:NYTimesApp/bloc/switch_tabs_bloc.dart';
import 'package:NYTimesApp/screens/tabs/saved_tab.dart';
import 'package:NYTimesApp/screens/tabs/for_you_tab.dart';
import 'package:NYTimesApp/screens/tabs/sections_tab.dart';
import 'package:NYTimesApp/screens/tabs/today_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset("assets/NewYorkTimes.svg"),
      ),
      body: StreamBuilder(
          stream: SwitchTabsBloc.bloc.subject.stream,
          initialData: SwitchTabsBloc.bloc.currentState,
          builder: (context, AsyncSnapshot<SwitchTabsStates> snapshot) {
            switch (snapshot.data) {
              case SwitchTabsStates.TODAY:
                return TodayTab();
                break;
              case SwitchTabsStates.SAVED:
                return SavedTab();
                break;
              case SwitchTabsStates.FOR_YOU:
                return ForYouTab();
                break;
              case SwitchTabsStates.SECTIONS:
                return SectionsTab();
                break;
              default:
                return Center(
                  child: Text("Error"),
                );
                break;
            }
          }),
      bottomNavigationBar: StreamBuilder(
          stream: SwitchTabsBloc.bloc.subject.stream,
          initialData: SwitchTabsBloc.bloc.currentState,
          builder: (context, AsyncSnapshot<SwitchTabsStates> snapshot) {
            SwitchTabsStates states = snapshot.data;
            return BottomNavigationBar(
                currentIndex: states.index,
                showUnselectedLabels: true,
                selectedItemColor: Color(0xFF000000),
                unselectedItemColor: Color(0xFFACAFBD),
                selectedFontSize: 12,
                unselectedFontSize: 10,
                onTap: (int index) {
                  SwitchTabsBloc.bloc
                      .mapEventToState(SwitchTabsEvents.values[index]);
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    label: "Today",
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home)),
                  BottomNavigationBarItem(
                    label: "Saved News",
                      icon: Icon(Icons.save_alt_outlined),
                      activeIcon: Icon(Icons.save_alt)),
                  BottomNavigationBarItem(
                    label: "For You",
                      icon: Icon(Icons.star_outline),
                      activeIcon: Icon(Icons.star)),
                  BottomNavigationBarItem(
                    label: "Sections",
                      icon: Icon(Icons.apps_outlined),
                      activeIcon: Icon(Icons.apps))
                ]);
          }),
    );
  }
}

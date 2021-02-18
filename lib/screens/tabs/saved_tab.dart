import 'package:NYTimesApp/bloc/saved_tab_bloc.dart';
import 'package:NYTimesApp/constants/constants.dart';
import 'package:NYTimesApp/models/home_news_db_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  void initState() {
    super.initState();
    SavedTabBloc.bloc.mapEventToState(SavedTabInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    double _statusBar = MediaQuery.of(context).padding.top;
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: SavedTabBloc.bloc.sunject.stream,
        builder: (context, AsyncSnapshot<SavedTabStates> snapshot) {
          SavedTabInitialState initialState;
          if (snapshot.hasData) {
            initialState = snapshot.data;
            return Container(
              height: _size.height - _statusBar,
              width: _size.width,
              child: ListView(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 12),
                  children: _buildNewsItems(initialState.homeNewsDBModels)),
            );
          } else {
            return Container(
              child: Center(
                child: SpinKitChasingDots(
                  color: Colors.black,
                ),
              ),
            );
          }
        });
  }
}

List<Widget> _buildNewsItems(List<HomeNewsDBModel> homeNewsDBModels) {
  List<Widget> completeNews = [];
  for (int i = 0; i < homeNewsDBModels.length; i++) {
    completeNews.add(_buildNewsItem(homeNewsDBModels[i].title,
        homeNewsDBModels[i].subtitle, homeNewsDBModels[i]));
  }
  return completeNews;
}

Widget _buildNewsItem(
    String title, String subTitle, HomeNewsDBModel homeNewsDBModels) {
  return InkWell(
    onTap: () {
      SavedTabBloc.bloc.mapEventToState(
          SavedTabOnTapEvent(homeNewsDBModel: homeNewsDBModels));
    },
    child: Container(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kColorBlack, width: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(children: [
            Text(
              title,
              style: TextStyle(
                  color: kColorBlack,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ]),
          SizedBox(
            height: 8,
          ),
          Wrap(children: [
            Text(
              subTitle,
              style: TextStyle(
                  color: kColorBlack,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ])
        ],
      ),
    ),
  );
}

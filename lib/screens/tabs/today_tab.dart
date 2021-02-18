import 'package:NYTimesApp/bloc/today_tab_bloc.dart';
import 'package:NYTimesApp/constants/constants.dart';
import 'package:NYTimesApp/models/home_news_model.dart';
import 'package:NYTimesApp/models/home_news_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TodayTab extends StatefulWidget {
  @override
  _TodayTabState createState() => _TodayTabState();
}

class _TodayTabState extends State<TodayTab> {
  @override
  void initState() {
    super.initState();
    TodayTabBloc.bloc.mapEventToState(TodayTabInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    double _statusBar = MediaQuery.of(context).padding.top;
    Size _size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: TodayTabBloc.bloc.subject.stream,
        builder: (context, AsyncSnapshot<TodayTabStates> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.runtimeType == TodayTabNoInternetState) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 30,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "No Internet Connection",
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  )
                ],
              ));
            } else {
              TodayTabInitialState initialState = snapshot.data;
              return Container(
                height: _size.height - _statusBar,
                width: _size.width,
                child: ListView(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 12),
                  children: _buildNewsItems(initialState.homeNewsResponse),
                ),
              );
            }
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

List<Widget> _buildNewsItems(HomeNewsResponse homeNewsResponse) {
  HomeNewsModel homeNewsModel = homeNewsResponse.homeNewsModel;
  List<Results> news = homeNewsModel.results;
  List<Widget> completeNews = [];
  for (int i = 0; i < homeNewsModel.numResults; i++) {
    completeNews.add(_buildNewsItem(news[i].title, news[i].subtitle, news[i]));
  }
  return completeNews;
}

Widget _buildNewsItem(String title, String subTitle, Results news) {
  return InkWell(
    onTap: () {
      TodayTabBloc.bloc.mapEventToState(TodayTabOnTapEvent(news: news));
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
                  fontSize: 18,
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

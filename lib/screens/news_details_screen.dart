import 'package:NYTimesApp/bloc/news_details_bloc.dart';
import 'package:NYTimesApp/bloc/switch_screen_bloc.dart';
import 'package:NYTimesApp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsScreen extends StatefulWidget {
  @override
  _NewsDetailsScreenState createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  NewsDetailsInitialState state;
  @override
  Widget build(BuildContext context) {
    double _statusBar = MediaQuery.of(context).padding.top;
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        SwitchScreenBloc.bloc.mapEventToState(SwitchScreenEvents.MAIN);
      },
      child: StreamBuilder(
          stream: NewsDetailsBloc.bloc.subject.stream,
          builder: (context, AsyncSnapshot<NewsDetailsStates> snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.runtimeType) {
                case NewsDetailsInitialState:
                  state = snapshot.data;
                  return Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back_sharp),
                          onPressed: () {
                            SwitchScreenBloc.bloc
                                .mapEventToState(SwitchScreenEvents.MAIN);
                          }),
                      actions: [
                        TextButton(
                            onPressed: () {
                              NewsDetailsBloc.bloc.mapEventToState(
                                  NewsDetailsOnSaveEvent(
                                      title: state.news.title,
                                      subTitle: state.news.subtitle,
                                      imgUrl: state.news.multimedia[0].url,
                                      articleUrl: state.news.url));
                            },
                            child: Icon(
                              Icons.save_outlined,
                              color: Colors.grey,
                              size: 30,
                            ))
                      ],
                    ),
                    body: Container(
                        height: _size.height - _statusBar,
                        width: _size.width,
                        child: ListView(
                          children: [
                            Image.network(state.news.multimedia[0].url),
                            SizedBox(
                              height: 16,
                            ),
                            textBuild(state.news.title, state.news.subtitle,
                                state.news.url),
                          ],
                        )),
                  );
                  break;
                case NewsDetailsOnSaveState:
                  NewsDetailsOnSaveState onSaveState = snapshot.data;
                  return Scaffold(
                      appBar: AppBar(
                        leading: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.grey,
                        ),
                      ),
                      body: progressBar(onSaveState));
                case NewsDetailsDownloadedState:
                  return Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back_sharp),
                            onPressed: () {
                              SwitchScreenBloc.bloc
                                  .mapEventToState(SwitchScreenEvents.MAIN);
                            }),
                        actions: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Already Saved",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      body: Container(
                          height: _size.height - _statusBar,
                          width: _size.width,
                          child: ListView(
                            children: [
                              Image.network(state.news.multimedia[0].url),
                              SizedBox(
                                height: 16,
                              ),
                              textBuild(state.news.title, state.news.subtitle,
                                  state.news.url),
                            ],
                          )));
                  break;
              }
            } else {
              return Scaffold(
                appBar: AppBar(
                  leading: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.grey,
                  ),
                ),
                body: Container(
                  child: Center(
                    child: SpinKitChasingDots(
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}

Widget textBuild(String title, String subTitle, String url) {
  return Padding(
    padding: EdgeInsets.only(left: 16, right: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(children: [
          Text(
            title,
            style: TextStyle(
                color: kColorBlack, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ]),
        SizedBox(
          height: 8,
        ),
        Wrap(children: [
          Text(
            subTitle,
            style: TextStyle(
                color: kColorBlack, fontSize: 15, fontWeight: FontWeight.w400),
          ),
          InkWell(
            child: Text(
              url,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blueAccent),
            ),
            onTap: () async {
              await launch(url);
            },
          )
        ])
      ],
    ),
  );
}

Widget progressBar(NewsDetailsOnSaveState onSaveState) {
  return Container(
    height: 190,
    padding: EdgeInsets.only(left: 50, right: 50, top: 80, bottom: 80),
    child: Center(
        child: Theme(
      data: ThemeData(accentColor: Colors.grey),
      child: LiquidLinearProgressIndicator(
        value: onSaveState.progress.floor().toDouble() / 100,
        borderRadius: 10,
        backgroundColor: Color(0xFFFFFFFF),
        direction: Axis.horizontal,
        center: Text(
          "${onSaveState.progress.floor()}%",
          style: TextStyle(color: Colors.black),
        ),
      ),
    )),
  );
}

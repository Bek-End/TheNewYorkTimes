import 'dart:io';
import 'package:NYTimesApp/bloc/news_details_db_bloc.dart';
import 'package:NYTimesApp/bloc/switch_screen_bloc.dart';
import 'package:NYTimesApp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsDBScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _statusBar = MediaQuery.of(context).padding.top;
    Size _size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        SwitchScreenBloc.bloc.mapEventToState(SwitchScreenEvents.MAIN);
      },
      child: StreamBuilder(
          stream: NewsDetailsDBBloc.bloc.subject.stream,
          // ignore: missing_return
          builder: (context, AsyncSnapshot<NewsDetailsDBStates> snapshot) {
            NewsDetailsDBInitialState initialEvent;
            if (snapshot.hasData) {
              switch (snapshot.data.runtimeType) {
                case NewsDetailsDBInitialState:
                  initialEvent = snapshot.data;
                  var file = File(initialEvent.homeNewsDBModel.path);
                  return Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back_sharp),
                          onPressed: () {
                            SwitchScreenBloc.bloc
                                .mapEventToState(SwitchScreenEvents.MAIN);
                          }),
                      actions: [
                        IconButton(
                          icon: Icon(
                            Icons.restore_from_trash,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            NewsDetailsDBBloc.bloc.mapEventToState(
                                NewsDetailsDBDeleteEvent(
                                    homeNewsDBModel:
                                        initialEvent.homeNewsDBModel));
                          },
                        )
                      ],
                    ),
                    body: Container(
                      height: _size.height - _statusBar,
                      width: _size.width,
                      child: ListView(
                        children: [
                          Image.file(file),
                          SizedBox(
                            height: 16,
                          ),
                          textBuild(initialEvent.homeNewsDBModel.title,
                              initialEvent.homeNewsDBModel.subtitle,initialEvent.homeNewsDBModel.articleUrl)
                        ],
                      ),
                    ),
                  );
                  break;
                case NewsDetailsDBDeletedState:
                  return Scaffold(
                    appBar: AppBar(
                      leading: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.grey,
                      ),
                    ),
                    body: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitThreeBounce(
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Deleting from saved",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
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

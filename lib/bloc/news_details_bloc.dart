import 'dart:io';
import 'dart:math';
import 'package:NYTimesApp/database/database_provider.dart';
import 'package:NYTimesApp/models/home_news_db_model.dart';
import 'package:NYTimesApp/models/home_news_model.dart';
import 'package:NYTimesApp/repository/project_repo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

//events
abstract class NewsDetailsEvents {}

class NewsDetailsInitialEvent extends NewsDetailsEvents {
  final Results news;

  NewsDetailsInitialEvent({this.news});
}

class NewsDetailsOnSaveEvent extends NewsDetailsEvents {
  final String title;
  final String subTitle;
  final String imgUrl;
  final String articleUrl;

  NewsDetailsOnSaveEvent({this.title, this.subTitle, this.imgUrl, this.articleUrl});
}

class NewsDetailsProgressEvent extends NewsDetailsEvents {
  final double progress;
  NewsDetailsProgressEvent({this.progress});
}

//states
abstract class NewsDetailsStates {}

class NewsDetailsInitialState extends NewsDetailsStates {
  final Results news;
  NewsDetailsInitialState({this.news});
}

class NewsDetailsOnSaveState extends NewsDetailsStates {
  final double progress;
  NewsDetailsOnSaveState({this.progress});
}

class NewsDetailsDownloadedState extends NewsDetailsStates {}

//bloc
class NewsDetailsBloc {
  BehaviorSubject<NewsDetailsStates> _subject =
      BehaviorSubject<NewsDetailsStates>();
  BehaviorSubject<NewsDetailsStates> get subject => _subject;

  NewsDetailsBloc._();

  static final bloc = NewsDetailsBloc._();
  NewsDetailsInitialEvent initialEvent;

  void mapEventToState(NewsDetailsEvents event) async {
    switch (event.runtimeType) {
      case NewsDetailsInitialEvent:
        initialEvent = event;
        _subject.sink.add(NewsDetailsInitialState(news: initialEvent.news));
        break;
      case NewsDetailsOnSaveEvent:
        NewsDetailsOnSaveEvent saveEvent = event;
        Directory directory = await getApplicationDocumentsDirectory();
        List<HomeNewsDBModel> models = await DatabaseProvider.db.getAllNews();
        List<int> ids = [];
        List<String> urls = [];
        if (models.isNotEmpty) {
          models.forEach((element) {
            ids.add(element.id);
          });
          models.forEach((element) {
            urls.add(element.url);
          });
          int newId = ids.reduce(max) + 1;
          if (urls.contains(saveEvent.imgUrl)) {
            _subject.sink.add(NewsDetailsDownloadedState());
            await Future.delayed(Duration(seconds: 1));
            _subject.sink.add(NewsDetailsInitialState(news: initialEvent.news));
          } else {
            String savePath = join(directory.path, "image{$newId}.jpg");
            print(savePath);
            await projectRepo.downloadPhoto(
                savePath: savePath, urlPath: saveEvent.imgUrl);
            HomeNewsDBModel homeNewsDBModel = HomeNewsDBModel(
                path: savePath,
                title: saveEvent.title,
                subtitle: saveEvent.subTitle,
                url: saveEvent.imgUrl,
                articleUrl: saveEvent.articleUrl
                );
            DatabaseProvider.db.insert(homeNewsDBModel);
          }
        } else {
          String savePath = join(directory.path, "image-1.jpg");
          print(savePath);
          await projectRepo.downloadPhoto(
              savePath: savePath, urlPath: saveEvent.imgUrl);
          HomeNewsDBModel homeNewsDBModel = HomeNewsDBModel(
              path: savePath,
              title: saveEvent.title,
              subtitle: saveEvent.subTitle,
              url: saveEvent.imgUrl,
              articleUrl: saveEvent.articleUrl
              );
          DatabaseProvider.db.insert(homeNewsDBModel);
        }
        break;
      case NewsDetailsProgressEvent:
        NewsDetailsProgressEvent progressEvent = event;
        if (progressEvent.progress == 100) {
          mapEventToState(NewsDetailsInitialEvent(news: initialEvent.news));
        } else {
          _subject.sink
              .add(NewsDetailsOnSaveState(progress: progressEvent.progress));
        }
    }
  }

  void dispose() {
    _subject?.close();
  }
}

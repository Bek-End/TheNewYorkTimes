import 'package:NYTimesApp/models/home_news_model.dart';

class HomeNewsResponse {
  final HomeNewsModel homeNewsModel;
  final String error;

  HomeNewsResponse({this.homeNewsModel, this.error});

  HomeNewsResponse.fromJson(var json)
      : homeNewsModel = HomeNewsModel.fromJson(json),
        error = "";

  HomeNewsResponse.withError(String errorValue)
      : error = errorValue,
        homeNewsModel = HomeNewsModel();
}

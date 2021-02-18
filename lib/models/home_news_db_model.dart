import 'package:NYTimesApp/database/database_provider.dart';

class HomeNewsDBModel {
  int id;
  String path;
  String title;
  String subtitle;
  String url;
  String articleUrl;

  HomeNewsDBModel(
      {this.id,
      this.path,
      this.title,
      this.subtitle,
      this.url,
      this.articleUrl});

  HomeNewsDBModel.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    path = map[DatabaseProvider.COLUMN_PATH];
    title = map[DatabaseProvider.COLUMN_TITLE];
    subtitle = map[DatabaseProvider.COLUMN_SUBTITLE];
    url = map[DatabaseProvider.COLUMN_URL];
    articleUrl = map[DatabaseProvider.COLUMN_ARTICLE_URL];
  }

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{
      DatabaseProvider.COLUMN_PATH: path,
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_SUBTITLE: subtitle,
      DatabaseProvider.COLUMN_URL: url,
      DatabaseProvider.COLUMN_ARTICLE_URL:articleUrl
    };

    if (id != null) {
      data[DatabaseProvider.COLUMN_ID] = id;
    }

    return data;
  }
}

import 'package:NYTimesApp/bloc/news_details_bloc.dart';
import 'package:NYTimesApp/models/home_news_response.dart';
import 'package:dio/dio.dart';

class ProjectRepo {
  Dio _dio;
  final String apiKey = "3EJJ4LtZ3h5QT1Co5bB0h9vjTNxj8HH8";
  final String mainUrl = "https://api.nytimes.com/";

  ProjectRepo() {
    _dio = Dio(BaseOptions(baseUrl: mainUrl));
  }

  Future<HomeNewsResponse> getNews() async {
    final String endPoint = "svc/topstories/v2/home.json?api-key=$apiKey";
    try {
      Response response = await _dio.get(endPoint);
      print("bitch");
      return HomeNewsResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("Error: $error, Stack: $stackTrace");
      return HomeNewsResponse.withError("Error: getting data");
    }
  }

  Future<void> downloadPhoto({String urlPath, String savePath}) async {
    await _dio.download(
      urlPath,
      savePath,
      onReceiveProgress: showDownloadProgress,
    );
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      NewsDetailsBloc.bloc.mapEventToState(
          NewsDetailsProgressEvent(progress: (received / total * 100)));
    }
  }
}

ProjectRepo projectRepo = ProjectRepo();

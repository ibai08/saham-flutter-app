import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../core/http.dart';
import '../../models/entities/post.dart';

enum PostOption { news, monthlyOutlook }

class Post {
  static Future<Map> getPost(PostOption? option, {String? page}) async {
    String request = "/wp-json/wp/v2/posts?categories[]=";
    String countPost = "10";
    String? category;
    switch (option) {
      case PostOption.news:
        category = "38";
        break;
      case PostOption.monthlyOutlook:
        category = "56";
        break;
      default:
    }
    page ??= "1";
    String link =
        request + category! + "&per_page=" + countPost + "&page=" + page;
    Response res;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    res = await dio.get(getMainSite() + link);
    return jsonDecode(res.toString());
  }

  static Future<List<PostState>> getPostList(PostOption? option,
      {String? page}) async {
    String request = "/wp-json/wp/v2/posts?categories[]=";
    String countPost = "6";
    String? category;
    switch (option) {
      case PostOption.news:
        category = "38";
        break;
      case PostOption.monthlyOutlook:
        category = "56";
        break;
      default:
    }
    page ??= "1";
    String link =
        request + category! + "&per_page=" + countPost + "&page=" + page;
    Response res;
    List<PostState> list;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    res = await dio.get(getMainSite() + link);
    list = res.data.map<PostState>((json) {
      return PostState.fromJson(json);
    }).toList();
    return list;
  }

  static Future<String> getImageFromId(String id) async {
    Response res;
    String imageUrl;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    res = await dio.get(getMainSite() + "/wp-json/wp/v2/media/" + id);
    imageUrl = res.data["guid"]["rendered"];
    return imageUrl;
  }

  static Future<String> getAuthorName(int? id) async {
    Response res;
    String authorName;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    res =
        await dio.get(getMainSite() + "/wp-json/wp/v2/users/" + id.toString());
    authorName = res.data["name"];
    return authorName;
  }

  static Future<PostDetails> getPostDetails(String? id) async {
    Response res;
    PostDetails post;
    Dio dio = Dio(); // with default Options
    dio.options.connectTimeout = const Duration(milliseconds: 10000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);
    res = await dio.get(getMainSite() + "/wp-json/wp/v2/posts/" + id!);
    post = PostDetails(
        title: res.data['title']['rendered'],
        desc: res.data['content']['rendered'],
        date: DateFormat('dd.MM.yyyy')
            .format(DateTime.parse(res.data['date_gmt']))
            .toString(),
        author: await getAuthorName(res.data['author']));
    return post;
  }

  static Future<List<SlidePromo>> getSlidePromo() async {
    Map fetchData = await TF2Request.request(
        url: getHostName() + "/traders/api/v2/promotion/list", method: 'GET');
    // Map fetchData = await TF2Request.request(
    //     url: getMainSite() + "/json/slidePromoNew.json", method: 'GET');
    return fetchData["message"]
        .map<SlidePromo>((json) => SlidePromo.fromJson(json))
        .toList();
  }
}

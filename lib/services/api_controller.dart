import 'package:dio/dio.dart';
import 'package:learncoding/models/course.dart';
import 'package:learncoding/models/lesson.dart';
import 'package:learncoding/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/explore_quiz_model.dart';
import '../models/quiz_models.dart';

class ApiProvider {
  Future<Course> retrieveCourses() async {
    String? lastUpdate;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2Rhc2hlbmNvbi5jb20vdGVzdCIsImlhdCI6MTY4MzE5MTQxMCwibmJmIjoxNjgzMTkxNDEwLCJleHAiOjE3NDYyNjM0MTAsImRhdGEiOnsidXNlciI6eyJpZCI6IjEyIn19fQ.zOgrml-PdsAXshyL5ioF7nKTF5txwB8W92aHDxfyG9c");

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.get(AppUrl.courseUrl, queryParameters: {'last_updated': lastUpdate ?? '2020-10-14 06:48:28'});
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final Course course = courseFromJson(responseBody);
      if (course.courses.isNotEmpty) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('new_lastupdate_date', course.courses.last.lastUpdated.toString());
      }
      return course;
    } else {
      throw Exception('Failed to load course');
    }
  }

  Future<Lesson> retrieveLessons(slug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    Response response = await dio.get(
      '${AppUrl.lessonUrl}/$slug',
      queryParameters: {'post_modified': '2021-10-30 13:28:40'},
    );
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final lesson = lessonFromJson(responseBody);
      return lesson;
    } else {
      throw Exception('Failed to load lesson');
    }
  }

    Future<ExploreData> retrieveQuiz() async {
    //initialize SharedPrefernec
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Quiztoken",
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2Rhc2hlbmNvbi5jb20vdGVzdCIsImlhdCI6MTY4NDU2NjU2NCwibmJmIjoxNjg0NTY2NTY0LCJleHAiOjE3NDc2Mzg1NjQsImRhdGEiOnsidXNlciI6eyJpZCI6IjkwIn19fQ.jetHRXCNxUV75Ql9CUYI6rxlnqc3PECg29UCKx7qN2Y");

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        "Bearer ${prefs.getString("Quiztoken")}";
    Response response = await dio.get(AppUrl.quizUrl);

    if (response.statusCode == 200) {
      List<QuizModle> quizModleList;
      quizModleList = (response.data['quiz'] as List)
          .map((i) => QuizModle.fromJson(i))
          .toList();
      
      return  ExploreData(quizModleList, response.data['life']);
    } else {
      throw Exception('Failed to load course');
    }
  }
}

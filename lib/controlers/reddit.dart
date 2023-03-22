import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RedditProvider extends ChangeNotifier {
  static Future<String> accessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String access = prefs.getString('Access_Token').toString();
    return access;
  }

  static Future<Map<String, dynamic>> getInfoUser() async {
    var uri = 'https://oauth.reddit.com/api/v1/me';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.get(Uri.parse(uri), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load User');
    }
  }

  static Future<Map<String, dynamic>> getMySubreddit() async {
    var uri = 'https://oauth.reddit.com/subreddits/mine/';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.get(Uri.parse(uri), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load Subreddit');
    }
  }

  static Future<Map<String, dynamic>> getAboutSubreddit(
      String subreddit) async {
    var uri = 'https://oauth.reddit.com/r/$subreddit/about';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.get(Uri.parse(uri), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Subreddit');
    }
  }

  static Future<Map<String, dynamic>> getDefaultSubreddit(String sub) async {
    var uri = 'https://oauth.reddit.com/subreddits/$sub';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.post(Uri.parse(uri), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load default subreddit');
    }
  }

  static Future<void> updateProfile(
      var darkmode,
      var over_18,
      var show_twitter,
      var email_messages,
      var email_user_new_follower,
      var email_username_mention) async {
    var update = {
      darkmode != null ? "nightmode" : darkmode: "",
      over_18 != null ? "over_18" : over_18: "",
      show_twitter != null ? "show_twitter" : show_twitter: "",
      email_messages != null ? "email_messages" : email_messages: "",
      email_user_new_follower != null
          ? "email_user_new_follower"
          : email_user_new_follower: "",
      email_username_mention != null
          ? "email_username_mention"
          : email_username_mention: "",
    };
    var access = await accessToken();
    var uri = 'https://oauth.reddit.com/api/v1/me/prefs';
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.patch(Uri.parse(uri),
        headers: headers, body: jsonEncode(update));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  static Future<List> getSubredditPost(
      String subreddit, String filter, String after) async {
    int limit = 10;
    final url =
        'https://oauth.reddit.com/r/$subreddit/$filter.json?limit=$limit&after=$after';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final posts = List<dynamic>.from(
          data['data']['children'].map((child) => child['data']).toList());
      return posts;
    } else {
      throw Exception('Failed to get posts: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getDefaultPost(
      String subreddit, String after, String before) async {
    int limit = 10;
    final url =
        'https://oauth.reddit.com/$subreddit?limit=$limit&after=$after&before=$before';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final posts = List<dynamic>.from(
          data['data']['children'].map((child) => child['data']).toList());
      return data;
    } else {
      throw Exception('Failed to get posts: ${response.statusCode}');
    }
  }

  static Future<void> subscribe(String subreddit, String action) async {
    var uri = 'https://oauth.reddit.com/api/subscribe';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    var body = {"action": action, "sr_name": subreddit};
    final response =
        await http.post(Uri.parse(uri), headers: headers, body: body);

    if (response.statusCode == 200) {
      print("success");
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load Subreddit');
    }
  }

  static Future<List> searchSubreddit(String search) async {
    var uri = 'https://oauth.reddit.com/subreddits/search?q=$search';
    var access = await accessToken();
    var headers = {'Authorization': 'Bearer $access', 'User-Agent': 'Reditech'};
    final response = await http.get(Uri.parse(uri), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final posts = List<dynamic>.from(
          data['data']['children'].map((child) => child['data']).toList());
      return posts;
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load Subreddit');
    }
  }
}

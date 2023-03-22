import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RedditAuth {
  Future<String?> fetchAutorization() async {
    final prefs = await SharedPreferences.getInstance();

    String clientId = "3HnRPdrsfEgohGpvKghZaw";
    var userAgent = "redditech";
    String redirectUri = "redditech://authorize_callback";
    var scope =
        "identity edit flair history modconfig modflair modlog modposts modwiki mysubreddits privatemessages read report save submit subscribe vote wikiedit wikiread";
    var uri =
        "https://www.reddit.com/api/v1/authorize.compact?client_id=$clientId&response_type=code&state=RANDOM_STRING&redirect_uri=$redirectUri&duration=permanent&scope=$scope";

    final authCode = await FlutterWebAuth.authenticate(
        url: uri, callbackUrlScheme: 'redditech');
    String? code = Uri.parse(authCode).queryParameters["code"];

    String authcode = code.toString();
    var basicAuthStr = clientId + ":";
    var bytes = utf8.encode(basicAuthStr);
    var base64Str = base64.encode(bytes);
    if (code != "") {
      var headers = {
        HttpHeaders.authorizationHeader: 'Basic $base64Str',
      };
      uri =
          "https://www.reddit.com/api/v1/access_token?grant_type=authorization_code&code=$code&redirect_uri=$redirectUri&scope=$scope";
      try {
        final response = await http.post(Uri.parse(uri),
            headers: headers, encoding: Encoding.getByName('utf-8'));
        if (response.statusCode == 200) {
          try {
            var responseJson = jsonDecode(response.body);
            print(responseJson['access_token']);
            await prefs.setString('App', authcode);
            await prefs.setString('Access_Token', responseJson['access_token']);
            await prefs.setString(
                'Refresh_Token', responseJson['refresh_token']);
            return "Success";
          } catch (e) {
            print(
              'redditGetAccessTokenFromCode :: Not able to parse Token',
            );
            return "error";
          }
        } else {
          return "error";
        }
      } catch (e) {
        print(
          'redditGetAccessTokenFromCode :: Not able to get Token',
        );
        return "error";
      }
    }
  }
}

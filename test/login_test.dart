// Import the test package and Counter class
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redditech/controlers/reddit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  var token = dotenv.env['SECRET'];
  test('Test getProfile', () async {
    final prefs = await SharedPreferences.getInstance();
    SharedPreferences.setMockInitialValues({});
    await prefs.setString('Access_Token', token.toString());

    var user = await RedditProvider.getInfoUser();

    expect(user["name"], "Oursbuveur");
  });
}

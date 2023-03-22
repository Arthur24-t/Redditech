import 'package:flutter/material.dart';
import 'package:redditech/controlers/reddit.dart';
import 'package:redditech/views/subreddit.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:redditech/views/navBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.subreddit,
      required this.after,
      required this.before})
      : super(key: key);
  final String subreddit;
  final String after;
  final String before;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RedditProvider.getDefaultPost(
            widget.subreddit, widget.after, widget.before),
        builder:
            (BuildContext context, AsyncSnapshot<Map<String, dynamic>> post) {
          if (post.connectionState == ConnectionState.done) {
            final posts = List<dynamic>.from(post.data?['data']['children']
                .map((child) => child['data'])
                .toList());
            return FutureBuilder<Map<String, dynamic>>(
                future: RedditProvider.getMySubreddit(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> sub) {
                  List<dynamic> subredditList =
                      sub.data?['data']['children'] ?? ["bleu"];
                  return Scaffold(
                    appBar: navBar(title: "Home"),
                    body: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            widget.after != ""
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => MyHomePage(
                                          subreddit: "best",
                                          after: "",
                                          before: post.data?["data"]
                                                  ["before"] ??
                                              "",
                                        ),
                                      ));
                                    },
                                    child: Text('before'),
                                  )
                                : Text(""),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                var element = posts[index];
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => Subreddit(
                                                    subreddit:
                                                        element?['subreddit'],
                                                    filter: "best"),
                                              ));
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "r/" + element?['subreddit'],
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              RedditProvider.subscribe(
                                                  element?['subreddit'], "sub");
                                            },
                                            child: Text('Join'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              RedditProvider.subscribe(
                                                  element?['subreddit'],
                                                  "unsub");
                                            },
                                            child: Text('Quit'),
                                          ),
                                        ],
                                      ),
                                      Text("u/" + element?['author']),
                                      Text(
                                        element?['title'] ?? "load",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      isImage(element['url'])
                                          ? Image.network(element['url'] ??
                                              "https://picsum.photos/250?image=9")
                                          : element['is_video'] == true &&
                                                  element['thumbnail'] !=
                                                      'spoiler'
                                              ? GestureDetector(
                                                  onTap: () {
                                                    launchUrl(Uri.parse(
                                                        element['secure_media']
                                                                ['reddit_video']
                                                            ['fallback_url']));
                                                  },
                                                  child: Image.network(element[
                                                          'thumbnail'] ??
                                                      "https://picsum.photos/250?image=9"),
                                                )
                                              : Text(element['selftext']),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              element?['liked'] ?? false
                                                  ? Icons.arrow_upward
                                                  : Icons
                                                      .arrow_circle_up_outlined,
                                              color: Colors.green,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              element?['dislike'] ?? false
                                                  ? Icons.arrow_downward
                                                  : Icons.arrow_circle_down,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyHomePage(
                                    subreddit: widget.subreddit,
                                    after: post.data?["data"]["after"] ?? "",
                                    before: "",
                                  ),
                                ));
                              },
                              child: Text('Next'),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: _currentIndex,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Best',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.fiber_new),
                          label: 'Hot',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.local_fire_department),
                          label: 'New',
                        ),
                      ],
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                subreddit: "best",
                                after: "",
                                before: "",
                              ),
                            ));
                            break;
                          case 1:
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                subreddit: "/r/popular/",
                                after: "",
                                before: "",
                              ),
                            ));
                            break;
                          case 2:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                      subreddit: "new",
                                      after: "",
                                      before: "",
                                    )));
                            break;
                          default:
                        }
                      },
                    ),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  bool isImage(String url) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];

    final extension = url.split('.').last.toLowerCase();

    return imageExtensions.contains(extension);
  }

  bool isVideo(String url) {
    final imageExtensions = ['mp4'];

    final extension = url.split('.').last.toLowerCase();

    return imageExtensions.contains(extension);
  }
}

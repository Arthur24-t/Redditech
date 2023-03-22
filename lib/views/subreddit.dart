import 'package:flutter/material.dart';
import 'package:redditech/controlers/reddit.dart';
import 'package:redditech/views/navBar.dart';
import 'package:url_launcher/url_launcher.dart';

class Subreddit extends StatefulWidget {
  const Subreddit({Key? key, required this.subreddit, required this.filter})
      : super(key: key);
  final String subreddit;
  final String filter;
  @override
  _Subreddit createState() => _Subreddit();
}

class _Subreddit extends State<Subreddit> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RedditProvider.getAboutSubreddit(widget.subreddit),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> about) {
        if (about.hasError) {
          return Text('Error: ${about.error}');
        } else {
          return FutureBuilder(
              future: RedditProvider.getSubredditPost(
                  widget.subreddit, widget.filter, ""),
              builder: (BuildContext context, AsyncSnapshot<List> post) {
                if (post.connectionState == ConnectionState.done) {
                  return Scaffold(
                    appBar: navBar(
                      title: about.data?['data']['display_name'] ?? "loading",
                    ),
                    body: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Image.network(about.data?["data"]['community_icon']
                                        .split("?")[0] !=
                                    ""
                                ? about.data!["data"]['community_icon']
                                    .split("?")[0]
                                : about.data?["data"]['icon_img'] ??
                                    "https://picsum.photos/250?image=9"),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                about.data?['data']['public_description'] ??
                                    "loading",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                'Subscribers :' +
                                    about.data!["data"]["subscribers"]
                                        .toString(),
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                RedditProvider.subscribe(
                                    widget.subreddit, "sub");
                              },
                              child: Text('Join'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                RedditProvider.subscribe(
                                    widget.subreddit, "unsub");
                              },
                              child: Text('Quit'),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: post.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                var element = post.data?[index];

                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                          label: 'New',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.local_fire_department),
                          label: 'Controversial',
                        ),
                      ],
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Subreddit(
                                  subreddit: widget.subreddit, filter: "best"),
                            ));
                            break;
                          case 1:
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Subreddit(
                                  subreddit: widget.subreddit, filter: "new"),
                            ));
                            break;
                          case 2:
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Subreddit(
                                  subreddit: widget.subreddit,
                                  filter: "controversial"),
                            ));
                            break;
                          default:
                        }
                      },
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              });
        }
      },
    );
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

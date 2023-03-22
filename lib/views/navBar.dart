import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:redditech/controlers/reddit.dart';
import 'package:redditech/views/subreddit.dart';
import 'package:auto_size_text/auto_size_text.dart';

class navBar extends StatefulWidget implements PreferredSizeWidget {
  const navBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<navBar> createState() => _navBar();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _navBar extends State<navBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu),
        tooltip: 'Navigation menu',
        onPressed: () => _showSettingsPanelNav(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => _showSettingsPanelFilter(),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            )
          },
        ),
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () => _showSettingsPanelUser(),
        ),
      ],
    );
  }

  Future<void> _showSettingsPanelUser() async {
    var user = await RedditProvider.getInfoUser();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController karmaController = TextEditingController();
    TextEditingController coinController = TextEditingController();
    // ignore: use_build_context_synchronously
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            print(user["subreddit"]["public_description"]);
            descriptionController.text =
                user["subreddit"]["public_description"];
            karmaController.text = user["awarder_karma"].toString();
            coinController.text = user["coins"].toString();
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image(
                      image: NetworkImage(
                        user["subreddit"]["icon_img"].split("?")[0] ??
                            "https://picsum.photos/250?image=9",
                      ),
                    ),
                    title: Text(
                      user["name"],
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Divider(),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(Icons.description),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: AutoSizeText(
                          'Description',
                          style: TextStyle(fontSize: 15.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  AutoSizeText(
                    user["subreddit"]["public_description"] ?? '',
                    style: TextStyle(fontSize: 13.0),
                    maxLines: 20,
                  ),
                  SizedBox(height: 16.0),
                  Divider(),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: karmaController,
                    decoration: InputDecoration(
                      labelText: 'Karma',
                      icon: Icon(Icons.textsms_outlined),
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 16.0),
                  Divider(),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: coinController,
                    decoration: InputDecoration(
                      labelText: 'Coin',
                      icon: Icon(Icons.monetization_on_outlined),
                    ),
                    enabled: false,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSettingsPanelNav() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<Map<String, dynamic>>(
          future: RedditProvider.getMySubreddit(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text("Une erreur s'est produite : ${snapshot.error}");
            } else {
              // Afficher la liste des abonnements
              List<dynamic> subredditList = snapshot.data!['data']['children'];
              return ListView.builder(
                itemCount: subredditList.length,
                itemBuilder: (BuildContext context, int index) {
                  String subredditTitle =
                      subredditList[index]['data']['display_name'];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Subreddit(
                            subreddit: subredditTitle, filter: "best"),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 60.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            subredditTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<void> _showSettingsPanelFilter() async {
    bool darkmode = true;
    bool over_18 = true;
    bool showTwitter = true;
    bool emailMessages = true;
    bool emailUserNewFollower = true;
    bool emailUsernameMention = true;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('darkmode'),
                      Switch(
                        value: darkmode,
                        onChanged: (bool value) {
                          setState(() {
                            darkmode = !darkmode; // Inverse la valeur actuelle
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('over_18'),
                      Switch(
                        value: over_18,
                        onChanged: (bool value) {
                          setState(() {
                            over_18 = !over_18;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('showTwitter'),
                      Switch(
                        value: showTwitter,
                        onChanged: (bool value) {
                          setState(() {
                            showTwitter = !showTwitter;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('email_messages'),
                      Switch(
                        value: emailMessages,
                        onChanged: (bool value) {
                          setState(() {
                            emailMessages = !emailMessages;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('email_user_new_follower'),
                      Switch(
                        value: emailUserNewFollower,
                        onChanged: (bool value) {
                          setState(() {
                            emailUserNewFollower = !emailUserNewFollower;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('email_username_mention'),
                      Switch(
                        value: emailUsernameMention,
                        onChanged: (bool value) {
                          setState(() {
                            emailUsernameMention = !emailUsernameMention;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await RedditProvider.updateProfile(
                            darkmode,
                            over_18,
                            showTwitter,
                            emailMessages,
                            emailUserNewFollower,
                            emailUsernameMention);
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [''];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: RedditProvider.searchSubreddit(query),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> sub) {
          if (sub.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: sub.data?.length,
                itemBuilder: (context, index) {
                  var result = sub.data?[index];
                  print(result);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Subreddit(
                            subreddit: result['title'], filter: "best"),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 60.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            result['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:redditech/controlers/auth.dart';
import 'package:redditech/widget/button.dart';

import '../../controlers/reddit.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);
  @override
  _Navbar createState() => _Navbar();
}

class _Navbar extends State<Navbar> {
  Future<void> showSettingsPanelUser() async {
    var user = await RedditProvider.getInfoUser();
    const image =
        'https://b.thumbs.redditmedia.com/E6-lBIXAELKdtcb4HaXUEuSSIKrsF9tOUgjnb5UYFrU.png';
    // ignore: use_build_context_synchronously
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Image(
                    image: NetworkImage(
                      image,
                    ),
                  ),
                ),
                Text(
                  user["name"],
                  style: TextStyle(fontSize: 24.0),
                ),
                Text(
                  user["awarder_karma"],
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 40.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Desciption'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Karma'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Param 5'),
                ),
              ],
            ),
          );
        });
  }

  void _showSettingsPanelNav() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Abonnement',
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Abonnement 1'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Abonnement 2'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Abonnement 3'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Abonnement 4'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Abonnement 5'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Abonnement 6'),
                ),
              ],
            ),
          );
        });
  }

  void _showSettingsPanelFilter() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Filter',
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Filter 1'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Filter 2'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Filter 3'),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Femme',
    'Homme',
  ];
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

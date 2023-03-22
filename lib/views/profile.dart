// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:redditech/controlers/reddit.dart';

// import '../models/user.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _Profile();
// }

// class _Profile extends State<Profile> {
//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<RedditProvider>();
//     print(user.infoOf?["subreddit"]["display_name_prefixed"]);
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text("profile"),
//           ],
//         ),
//       ),
//     );
//   }
// }

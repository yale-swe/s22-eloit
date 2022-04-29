import 'package:eloit/models/category.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/models/vote.dart';
import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/home.dart';
import 'package:eloit/screens/ui_elements.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoteHistoryPage extends StatefulWidget {
  const VoteHistoryPage({Key? key}) : super(key: key);

  @override
  State<VoteHistoryPage> createState() => _VoteHistoryPageState();
}

class _VoteHistoryPageState extends State<VoteHistoryPage> with AutomaticKeepAliveClientMixin {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    DatabaseService _db = DatabaseService();

    return Scaffold(
      appBar: createCustomAppBar(context, "Vote History"),
      body: StreamBuilder<List<Vote>>(
        stream: _db.voteHistory(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Vote> votes = snapshot.data ?? [];
            return ListView.builder(
              controller: ScrollController(),
              padding: const EdgeInsets.all(15.0),
              itemCount: votes.length,
              itemBuilder: (BuildContext context, int index) {
                Vote? vote = votes[index];
                Rivalry rivalry = vote.rivalry;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      //Shows Image1 at start of card
                      backgroundImage:
                          NetworkImage(rivalry.competitors[0].item.avatarURL),
                    ),
                    trailing: CircleAvatar(
                      //Shows Image2 at trail end of card
                      backgroundImage:
                          NetworkImage(rivalry.competitors[1].item.avatarURL),
                    ),
                    title: Center(
                      //Shows Character1 vs Chatacter2 text on card
                      child: Text(
                          '${rivalry.competitors[0].item.name} vs ${rivalry.competitors[1].item.name}'),
                    ),
                    subtitle: Center(
                      child: Text(
                          'You voted for ${rivalry.competitors.where((competitor) => competitor.id == vote.competitorID).first.item.name} on ${DateFormat.yMd().add_jm().format(vote.time)}'),
                    ),
                  ),
                );
              },
            );
          } else {
            return const LinearProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

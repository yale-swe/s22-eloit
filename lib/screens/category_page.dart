import 'package:eloit/models/category.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/screens/auth/auth_widget.dart';
import 'package:eloit/screens/home.dart';
import 'package:eloit/screens/rankings_page.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        actions: [
          TextButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Log Out',
                style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.button?.color),
              ),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Now navigate to the auth page.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthBox(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Rivalry>>(
        //listening for stream of data to update the UI
        stream:
            _db.categoryRivalries(category), //stream where data is coming from
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //if there is data to show...
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(15.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Card(
                          //rounder corner rectangle UI element
                          //This card shows the Elo rankings
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const ListTile(
                                title: Text('RANKINGS:'),
                              ),
                              Flexible(
                                //making wideget flexible lets it resize to its parent
                                child: TopFewRankings(
                                  category: category,
                                  numItems: 3,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RankingsPage(category: category),
                                    ),
                                  );
                                },
                                child: const ListTile(
                                  title:
                                      Center(child: Text('SEE FULL RANKINGS')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(15.0),
                  sliver: SliverList(
                    //Scrollable list of current comparrisons between characters
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Rivalry rivalry = snapshot.data![index];
                        return Card(
                          //Create a card for each comparison, format is below
                          //Image1     Character1 vs Chatacter2     Image2
                          child: ListTile(
                            leading: CircleAvatar(
                              //Shows Image1 at start of card
                              backgroundImage: NetworkImage(
                                  rivalry.competitors[0].item.avatarURL),
                            ),
                            trailing: CircleAvatar(
                              //Shows Image2 at trail end of card
                              backgroundImage: NetworkImage(
                                  rivalry.competitors[1].item.avatarURL),
                            ),
                            title: Center(
                              //Shows Character1 vs Chatacter2 text on card
                              child: Text(
                                  '${rivalry.competitors[0].item.name} vs ${rivalry.competitors[1].item.name}'),
                            ),
                            onTap: () async {
                              //When the compareison card is clicked...
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  //You are rerouted to the vote page
                                  builder: (context) => VotePage(
                                    category: category,
                                    rivalry: rivalry,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: snapshot.data
                          ?.length, //number of comparisons is pulled from database
                    ),
                  ),
                ),
              ],
            );
          } else {
            //show bar with loading status because data has not been fetched
            return const LinearProgressIndicator(
              backgroundColor: Colors.grey,
            );
          }
        },
      ),
    );
  }
}

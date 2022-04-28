import 'package:eloit/models/category.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/screens/create_rivalry.dart';
import 'package:eloit/screens/rankings_page.dart';
import 'package:eloit/screens/ui_elements.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return Scaffold(
      appBar: createCustomAppBar(context, category.name),
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
                  padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
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
                                title: Text('Rankings:'),
                              ),
                              Flexible(
                                //making widget flexible lets it resize to its parent
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
                                      Center(child: Text('See Full Rankings')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Card(
                          child: ListTile(
                            title: const Text('Rivalries'),
                            trailing: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    //You are rerouted to the vote page
                                    builder: (context) => CreateRivalry(
                                      category: category,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Create Rivalry',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                  sliver: SliverList(
                    //Scrollable list of current comparisons between characters
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Rivalry rivalry = snapshot.data![index];
                        return Card(
                          //Create a card for each comparison, format is below
                          //Image1     Character1 vs Chatacter2     Image2
                          child: ListTile(
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: CircleAvatar(
                                //Shows Image1 at start of card
                                backgroundImage: NetworkImage(
                                    rivalry.competitors[0].item.avatarURL),
                              ),
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

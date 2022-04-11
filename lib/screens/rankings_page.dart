import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/screens/home.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';

class RankingsPage extends StatelessWidget {
  const RankingsPage({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BACKGROUND,
      appBar: AppBar(
        title: Text("Rankings for ${category.name}"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    //rounder corner rectangle UI element
                    //This card shows the Elo rankings
                    color: COLOR_BACKGROUND,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          //making wideget flexible lets it resize to its parent
                          child: TopFewRankings(
                            category: category,
                            separateCards: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopFewRankings extends StatelessWidget {
  /// Fetches List tiles of the top 'numItems' elements of a given
  /// category as ranked by their Elo scores. If numItems is -1, returns
  /// all items in decreasing order of Elo scores.
  /// If separateCards is true, each tile is returned in a separate card.
  const TopFewRankings({
    Key? key,
    required this.category,
    this.numItems = -1,
    this.separateCards = false,
  }) : super(key: key);

  final Category category;
  final int numItems;
  final bool separateCards;

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return StreamBuilder<List<Competitor>>(
        stream: _db.rankings(category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              primary:
                  false, //Listview will not use the default scrollController
              shrinkWrap:
                  true, //The ListView only occupies the space it needs (it will still scroll when there more items).
              itemCount: numItems > -1 ? numItems : snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                Competitor competitor = snapshot.data![index];
                if (separateCards) {
                  return Card(
                      child: CompetitorListTile(
                          competitor: competitor, index: index));
                } else {
                  return CompetitorListTile(
                      competitor: competitor, index: index);
                }
              },
            );
          } else {
            //if data stream is not producing data...
            return const LinearProgressIndicator(); //Straight line indicator
          }
        });
  }
}

class CompetitorListTile extends StatelessWidget {
  const CompetitorListTile(
      {Key? key, required this.competitor, required this.index})
      : super(key: key);

  final Competitor competitor;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('${index + 1}'), //Rating number
      title: Text(competitor.item.name), //Character Name
      trailing: FittedBox(
        fit: BoxFit.fill,
        child: Row(
          children: <Widget>[
            Text(competitor.eloScore.toString()),
            const SizedBox(width: 10.0),
            CircleAvatar(
              //trailing makes it so image is at end of the tile
              backgroundImage: NetworkImage(
                  //Get character image from cloud storage
                  competitor.item.avatarURL),
            ),
          ],
        ),
      ),
    );
  }
}

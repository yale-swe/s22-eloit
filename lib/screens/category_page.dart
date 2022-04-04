import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return StreamBuilder<List<Rivalry>>( //listening for stream of data to update the UI
      stream: _db.categoryRivalries(category), //stream where data is coming from
      builder: (context, snapshot) {
        if (snapshot.hasData) { //if there is data to show...
          return Column(
            children: [
              Card( //rounder corner rectangle UI element
              //This card shows the Elo rankings
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      title: Text('RANKINGS:'),
                    ),
                    Flexible( //making wideget flexible lets it resize to its parent
                      child: StreamBuilder<List<Competitor>>(
                          stream: _db.rankings(category),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true, //The ListView only occupies the space it needs (it will still scroll when there more items).
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Competitor competitor = snapshot.data![index];
                                  return ListTile(
                                    leading: Text('${index + 1}'), //Rating number
                                    title: Text(competitor.item.name), //Character Name
                                    trailing: CircleAvatar( //trailing makes it so image is at end of the tile
                                      backgroundImage: NetworkImage( //Get character image from cloud storage
                                          competitor.item.avatarURL),
                                    ),
                                  );
                                },
                              );
                            } else { //if data stream is not producing data...
                              return const LinearProgressIndicator(); //Straight line indicator
                            }
                          }),
                    ),
                  ],
                ),
              ),

              Flexible( //Scrollable list of current comparrisons between characters
                child: ListView.builder(
                  itemCount: snapshot.data?.length, //number of comparisons is pulled from database
                  itemBuilder: (BuildContext context, int index) {
                    Rivalry rivalry = snapshot.data![index];
                    return Card( //Create a card for each comparison, format is below
                    //Image1     Character1 vs Chatacter2     Image2
                      child: ListTile(
                        leading: CircleAvatar( //Shows Image1 at start of card
                          backgroundImage: NetworkImage(
                              rivalry.competitors[0].item.avatarURL),
                        ), 
                        trailing: CircleAvatar( //Shows Image2 at trail end of card
                          backgroundImage: NetworkImage(
                              rivalry.competitors[1].item.avatarURL),
                        ),
                        title: Center( //Shows Character1 vs Chatacter2 text on card
                          child: Text(
                              '${rivalry.competitors[0].item.name} vs ${rivalry.competitors[1].item.name}'),
                        ),

                        onTap: () async { //When the compareison card is clicked...
                          Navigator.of(context).push(
                            MaterialPageRoute( //You are rerouted to the vote page
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
                ),
              ),
            ],
          );
        } else { //show bar with loading status because data has not been fetched
          return const LinearProgressIndicator(backgroundColor: Colors.grey,); 
        }
      },
    );
  }
}

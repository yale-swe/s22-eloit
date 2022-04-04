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

    return StreamBuilder<List<Rivalry>>(
      stream: _db.categoryRivalries(category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      title: Text('Rankings'),
                    ),
                    Flexible(
                      child: StreamBuilder<List<Competitor>>(
                          stream: _db.rankings(category),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Competitor competitor = snapshot.data![index];
                                  return ListTile(
                                    leading: Text('${index + 1}'),
                                    title: Text(competitor.item.name),
                                    trailing: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Row(
                                        children: <Widget>[
                                          Text(competitor.eloScore.toString()),
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
                                },
                              );
                            } else {
                              return const LinearProgressIndicator();
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Rivalry rivalry = snapshot.data![index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              rivalry.competitors[0].item.avatarURL),
                        ),
                        trailing: CircleAvatar(
                          backgroundImage: NetworkImage(
                              rivalry.competitors[1].item.avatarURL),
                        ),
                        title: Center(
                          child: Text(
                              '${rivalry.competitors[0].item.name} vs ${rivalry.competitors[1].item.name}'),
                        ),
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
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
        } else {
          return const LinearProgressIndicator();
        }
      },
    );
  }
}

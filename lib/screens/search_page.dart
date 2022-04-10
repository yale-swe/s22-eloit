import 'package:eloit/models/category.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.grey),
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelText: 'Search',
              ),
              onChanged: (String input) {
                setState(() {
                  searchText = input;
                });
              },
            ),
            Card(
              child: StreamBuilder<List<Category>>(
                stream: _db.searchCategory(searchText),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<Widget> listTiles = snapshot.data!
                        .map(
                          (category) => ListTile(
                            title: Text(category.name),
                            leading: const CircleAvatar(),
                            onTap: () {},
                          ),
                        )
                        .toList();
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                            const ListTile(
                              title: Center(child: Text('Categories')),
                            )
                          ] +
                          listTiles,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Card(
              child: StreamBuilder<List<Rivalry>>(
                stream: _db.searchRivalry(searchText),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<Widget> listTiles = snapshot.data!
                        .map(
                          (rivalry) => ListTile(
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
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     //You are rerouted to the vote page
                              //     builder: (context) => VotePage(
                              //       category: category,
                              //       rivalry: rivalry,
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        )
                        .toList();
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[const Text('Rivalries')] + listTiles,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

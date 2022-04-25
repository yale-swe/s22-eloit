import 'package:eloit/screens/category_page.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category.dart';





class categoryTile extends StatelessWidget {
  final int index;
  final List<Tile> tileList;

  const categoryTile(this.index, this.tileList);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: AspectRatio(
                aspectRatio: 1,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(tileList[index].coverPicURL),
                ),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 10,
              child: Container(
                //padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(tileList[index].name, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        ElevatedButton(       
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                  CategoryPage(
                                    category: Category(
                                      cid: tileList[index].mapId,
                                      name: tileList[index].name,
                                      coverPicURL: tileList[index].coverPicURL,
                                    ),
                                  )
                              ),
                            );
                            print("hee");
                          },
                          child: Text("More Info"))
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}

class Tile { //https://stackoverflow.com/questions/71014768/flutter-how-can-i-print-all-my-data-fields-from-firebase-documents
  final String name;
  final String coverPicURL;
  final String mapId;


  const Tile({
    required this.name,
    required this.coverPicURL,
    required this.mapId,
  });

  factory Tile.fromMap(Map<String, dynamic> map, String mapId2) {
    return Tile(     
      name: map['name'] as String,
      coverPicURL: map['coverPicURL'] as String,
      mapId: mapId2,
    );
  }
}


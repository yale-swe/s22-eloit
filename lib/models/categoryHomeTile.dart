import 'package:eloit/screens/category_page.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';

import 'category.dart';





class CategoryTile extends StatelessWidget {
  final int index;
  final List<Tile> tileList;

  const CategoryTile(this.index, this.tileList);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
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
      ),
      child: Card(
        
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    height: 200,
                    width: 200,
                    //color: Colors.grey.shade200,
                    child: Image.network(
                      tileList[index].coverPicURL,
                      width: 200.0,
                      height: 200.0,
                      //fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(tileList[index].name, style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20,),
                      Text(tileList[index].blurb, style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ]
            ),
          ),
        )
      ),
    );
  }
}

class Tile { //https://stackoverflow.com/questions/71014768/flutter-how-can-i-print-all-my-data-fields-from-firebase-documents
  final String name;
  final String coverPicURL;
  final String mapId;
  final String blurb;


  const Tile({
    required this.name,
    required this.coverPicURL,
    required this.mapId,
    required this.blurb,
  });

  factory Tile.fromMap(Map<String, dynamic> map, String mapId2) {
    return Tile(     
      name: map['name'] as String,
      coverPicURL: map['coverPicURL'] as String,
      mapId: mapId2,
      blurb: map['blurb'] as String,
    );
  }
}


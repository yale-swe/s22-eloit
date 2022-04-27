import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eloit/models/category.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/screens/create_rivalry.dart';
import 'package:eloit/screens/rankings_page.dart';
import 'package:eloit/screens/ui_elements.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';

import '../models/categoryHomeTile.dart';

class FeaturedPage extends StatefulWidget {
   const FeaturedPage({ Key? key }) : super(key: key);
  @override
  FeaturedPageState createState() => FeaturedPageState();
}


class FeaturedPageState extends State<FeaturedPage> {
  //const CategoryPage({Key? key}) : super(key: key);

  //final Category category;

  @override
  Widget build(BuildContext context) {
    DatabaseService _db = DatabaseService();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          appBar: createCustomAppBar(context, "Trending Categories"),
          
          body: SizedBox(
            child: StreamBuilder<List<Tile>>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots()
                  .map((query) =>
                      query.docs.map((map) => Tile.fromMap(map.data(), map.id)).toList()),
              builder: (context, snapshot){                  
                  if (!snapshot.hasData) { // if snapshot has no data this is going to run
                    return Container(
                      alignment: FractionalOffset.center,
                      child: const CircularProgressIndicator());
                  }
                  final tileList = snapshot.data!;

                  return ListView.builder(
                    cacheExtent: 5000,
                    itemExtent: 150,
                    itemCount: tileList.length,
                    itemBuilder: (context, index) {//=> categoryTileImage(index, tileList), 
                      // if (index == 0){
                      //   retyrb =
                      // }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
                        child: CategoryTile(index, tileList),
                      );
                    }
                  );
                }
            ),
          ),
        );
      }
    );
  }
}
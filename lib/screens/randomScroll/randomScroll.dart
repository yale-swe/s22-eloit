// Navigator.of(context).push(
//   MaterialPageRoute(
//     //You are rerouted to the vote page
//     builder: (context) => VotePage(
//       category: category,
//       rivalry: rivalry,
//     ),
//   ),
// ),



import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/screens/create_rivalry.dart';
import 'package:eloit/screens/rankings_page.dart';
import 'package:eloit/screens/ui_elements.dart';
import 'package:eloit/screens/vote_page.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../REVANTvote_page.dart';

class randomScroll extends StatefulWidget {
  const randomScroll({ Key? key }) : super(key: key);

  @override
  State<randomScroll> createState() => _randomScrollState();
}

class _randomScrollState extends State<randomScroll> {
  final DatabaseService _db = DatabaseService();
  final controller = SwipableStackController();
//   Category cate = const Category(
//   cid: "9A7IO38o2kHDRXDgSIhb",
//   name: "Avengers",
//   coverPicURL: "https://firebasestorage.googleapis.com/v0/b/eloit-c4540.appspot.com/o/heroImages%2Favengers.png?alt=media&token=393e5b8d-9e46-4395-841f-251c734897b7",
//   );
//   Rivalry rivalz = Rivalry(rid: "4dWgwPGCuB82e6v3Px0t", cid: "9A7IO38o2kHDRXDgSIhb", itemIDs: ["RGLHK1xZfryvvGumxnrO", 
// "SsgMttyq6lkgYT6jPzLS"], votes: [32, 15], competitors: [
//   Competitor(id: "Hulk", item: item, eloScore: 1200)
// ]
// , name: "iron man vs black widow")

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: createCustomAppBar(context, 'Random Scroll'),
      body: Stack(children: [

        // SwipableStack(
        //   controller: controller,
        //   builder: (context, index){
          
        //     return VotePageRandom(
        //       category: "Avengers",
        //       rivalry: rivalry,
        //     );
            
        //   }
        // ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              onPressed: () => controller.rewind(),
              tooltip: 'Rewind',
              child: Icon(Icons.fast_rewind_outlined),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
                onPressed: () async {
                  print(await _db.docCount());
                  controller.currentIndex = 0;
                },
                tooltip: 'Reset',
                child: Icon(Icons.reset_tv),
            ),
          ),
        )
      ],)
    );
  }
}


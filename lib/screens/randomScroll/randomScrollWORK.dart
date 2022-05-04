// import 'package:eloit/models/category.dart';
// import 'package:eloit/models/rivalry.dart';
// import 'package:eloit/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:swipeable_card_stack/swipeable_card_stack.dart';
// import '../REVANTvote_page.dart';

// class RandomScroll extends StatefulWidget {
//   const RandomScroll({ Key? key }) : super(key: key);

//   @override
//   State<RandomScroll> createState() => _RandomScrollState();
// }

// class _RandomScrollState extends State<RandomScroll> {
//   final DatabaseService _db = DatabaseService();
//   Future<List?> getRandomRiv() async {
//     return await _db.randomRivalry();   
//   }
//   SwipeableCardSectionController _cardController = SwipeableCardSectionController();

//   @override
//   Widget build(BuildContext context) {
 
//     DatabaseService _db = DatabaseService();
//     return Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           SwipeableCardsSection(
//             cardController: _cardController,
//             context: context,
//             //add the first 3 cards (widgets)
//             items: [
//               Card2(), Card2()
//             ],
//             //Get card swipe event callbacks
//             onCardSwiped: (dir, index, widget) {
//               //Add the next card using _cardController
//               _cardController.addItem(Card2());
              
//               //Take action on the swiped widget based on the direction of swipe
//               //Return false to not animate cards
//             },
//             //
//             enableSwipeUp: true,
//             enableSwipeDown: false,
//           ),
//         ],
//     );
//   }
// }



// class Card2 extends StatelessWidget{
//   final DatabaseService _db = DatabaseService();
//   Future<List?> getRandomRiv() async {
//     return await _db.randomRivalry();   
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         //height: MediaQuery.of(context).size.height * 0.8,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: Color.fromARGB(255, 181, 166, 165),
//         ),
//         child: FutureBuilder(
//           future: getRandomRiv(),
//           builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> snapshot) {
//             if (snapshot.data != null){
//               Category category = snapshot.data![0];
//               Rivalry rivalry = snapshot.data![1];
//               return VotePageRandom(category: category, rivalry: rivalry);
//             }
//             else{
//               return Container(
//                 alignment: Alignment.center,
//                 child: const CircularProgressIndicator(),
//               );
//             }
//           },
//         ),

//       );
//   }
// }


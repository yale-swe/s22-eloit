import 'package:eloit/models/category.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/shared/ui_elements.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';
import '../REVANTvote_page.dart';
import 'package:swipable_stack/swipable_stack.dart'; 

class RandomScroll extends StatefulWidget {
  const RandomScroll({ Key? key }) : super(key: key);

  @override
  State<RandomScroll> createState() => _RandomScrollState();
}

class _RandomScrollState extends State<RandomScroll> {
  final DatabaseService _db = DatabaseService();
  List cards = [];
  void getRandomRiv() async {
    for (int i=0; i<10; i++) {
      cards.add(await _db.randomRivalry());
      print(cards[i]);
    }
    setState(() {
      Loading = false;
    });
    
    //return await _db.randomRivalry(); 
  }

  SwipeableCardSectionController _cardController = SwipeableCardSectionController();

  bool Loading = true;
  int index1 = 0;
  @override
  Widget build(BuildContext context) {
    
    DatabaseService _db = DatabaseService();
    if (!Loading) {
      return Scaffold(
        appBar: createCustomAppBar(context, 'Explore'),
        body: Container(
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: SwipableStack(
                    builder: (context, properties) {   
                      return Card3(category: cards[index1][0], rivalry: cards[index1][1]);                   
                    },
                    itemCount: 10,
                    onSwipeCompleted: (index, direction) {
                      index1++;
                      print('$index, $direction');
                      
                    }, 
                  ),
                ),
              ],
          ),
        ),
      );
    }
    else{
      getRandomRiv();
      return Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator()
      );
    }
  }
}

class Card3 extends StatelessWidget{

  final DatabaseService _db = DatabaseService();
  final Category category;
  final Rivalry rivalry;
  Card3({Key? key, required this.category, required this.rivalry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color.fromARGB(255, 181, 166, 165),
        ),
        child: VotePageRandom(category: category, rivalry: rivalry),

      );
  }
}



class Card2 extends StatelessWidget{
  final DatabaseService _db = DatabaseService();

  Card2({Key? key}) : super(key: key);
  Future<List?> getRandomRiv() async {
    print("hey");
    return await _db.randomRivalry();   
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color.fromARGB(255, 181, 166, 165),
        ),
        child: FutureBuilder(
          future: getRandomRiv(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>?> snapshot) {
            if (snapshot.data != null){
              Category category = snapshot.data![0];
              Rivalry rivalry = snapshot.data![1];
              return VotePageRandom(category: category, rivalry: rivalry);
            }
            else{
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),

      );
  }
}


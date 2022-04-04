import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/services/elo.dart';
import 'package:flutter/material.dart';

enum voteState {
  beforeVote,
  afterVote,
}

class VotePage extends StatefulWidget {
  const VotePage({Key? key, required this.category, required this.rivalry})
      : super(key: key);

  final Category category;
  final Rivalry rivalry;

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  voteState voted = voteState.beforeVote;

  @override
  Widget build(BuildContext context) {
    EloService _elo = EloService();
    double pageWidth = MediaQuery.of(context).size.width;
    double avatarRadius = pageWidth / 8;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vote'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: NetworkImage(
                            widget.rivalry.competitors[0].item.avatarURL),
                      ),
                      Text(widget.rivalry.competitors[0].item.name),
                    ],
                  ),
                  onTap: () async {
                    await _elo.vote(widget.category, widget.rivalry,
                        widget.rivalry.competitors[0]);
                    setState(() {
                      voted = voteState.afterVote;
                    });
                  },
                ),
                GestureDetector(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundImage: NetworkImage(
                              widget.rivalry.competitors[1].item.avatarURL),
                        ),
                        Text(widget.rivalry.competitors[1].item.name),
                      ],
                    ),
                    onTap: () async {
                      await _elo.vote(widget.category, widget.rivalry,
                          widget.rivalry.competitors[1]);
                      setState(() {
                        voted = voteState.afterVote;
                      });
                    }),
              ],
            ),
            VoteBar(
              rivalry: widget.rivalry,
              voted: voted,
            ),
          ],
        ));
  }
}

class VoteBar extends StatefulWidget {
  const VoteBar({Key? key, required this.rivalry, required this.voted})
      : super(key: key);

  final Rivalry rivalry;
  final voteState voted;

  @override
  State<VoteBar> createState() => _VoteBarState();
}

class _VoteBarState extends State<VoteBar> {
  double competitor_1_votes = 0.5;
  double competitor_2_votes = 0.5;

  // void addVote() {
  //   setState(() {
  //     currentState = voteState.afterVote;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double barWidth = width / 1.2;
    // double height = MediaQuery.of(context).size.height;
    // double sideLength = (width < height ? width : height);
    return Container(
      width: barWidth,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(barWidth / 20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: width / 8,
            width: (widget.voted == voteState.beforeVote
                ? 0.5 * barWidth
                : competitor_1_votes * barWidth),
            color: widget.voted == voteState.beforeVote
                ? Colors.grey[400]
                : Colors.blue,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: width / 8,
            width: (widget.voted == voteState.beforeVote
                ? 0.5 * barWidth
                : competitor_2_votes * barWidth),
            color: widget.voted == voteState.beforeVote
                ? Colors.grey[600]
                : Colors.red,
          )
        ],
      ),
    );
  }
}

// class VotePage extends StatefulWidget {
//   const VotePage({Key? key, required this.category, required this.rivalry})
//       : super(key: key);

//   final Category category;
//   final Rivalry rivalry;

//   @override
//   State<VotePage> createState() => _VotePageState();
// }

// class _VotePageState extends State<VotePage> {
//   bool voted = false;

//   late Competitor competitorA = widget.rivalry.competitors[0];
//   late Competitor competitorB = widget.rivalry.competitors[1];
//   late int votesA = widget.rivalry.votes[competitorA.id] + 1;
//   late int votesB = widget.rivalry.votes[competitorB.id] + 1;

//   @override
//   Widget build(BuildContext context) {
//     EloService _elo = EloService();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Vote'),
//       ),
//       body: Center(
//         child: Card(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text(competitorA.item.name),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: LayoutBuilder(builder:
//                       (BuildContext context, BoxConstraints constraints) {
//                     return Row(
//                       children: [
//                         GestureDetector(
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             height: 20.0,
//                             width: voted
//                                 ? constraints.minWidth *
//                                     (votesA / (votesA + votesB))
//                                 : constraints.minWidth * 0.5,
//                             color: voted ? Colors.blue : Colors.grey[400],
//                           ),
//                           onTap: () async {
//                             await _elo.vote(
//                                 widget.category, widget.rivalry, competitorA);
//                             setState(() {
//                               votesA++;
//                               voted = true;
//                             });
//                           },
//                         ),
//                         GestureDetector(
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             height: 20.0,
//                             width: voted
//                                 ? constraints.minWidth *
//                                     (votesB / (votesA + votesB))
//                                 : constraints.minWidth * 0.5,
//                             color: voted ? Colors.redAccent : Colors.grey[600],
//                           ),
//                           onTap: () async {
//                             await _elo.vote(
//                                 widget.category, widget.rivalry, competitorB);
//                             setState(() {
//                               votesB++;
//                               voted = true;
//                             });
//                           },
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//                 const SizedBox(width: 10),
//                 Text(competitorB.item.name),
//               ],
//             ),
//           ),
//           margin: const EdgeInsets.all(10.0),
//         ),
//       ),
//     );
//   }
// }

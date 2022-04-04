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
                    if (voted == voteState.beforeVote) {
                      await _elo.vote(widget.category, widget.rivalry,
                          widget.rivalry.competitors[0]);
                      setState(() {
                        voted = voteState.afterVote;
                      });
                    }
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
                      if (voted == voteState.beforeVote) {
                        await _elo.vote(widget.category, widget.rivalry,
                            widget.rivalry.competitors[1]);
                        setState(() {
                          voted = voteState.afterVote;
                        });
                      }
                    }),
              ],
            ),
            const SizedBox(height: 10.0),
            VoteBar(
              category: widget.category,
              rivalry: widget.rivalry,
              voted: voted,
            ),
          ],
        ));
  }
}

class VoteBar extends StatefulWidget {
  const VoteBar(
      {Key? key,
      required this.rivalry,
      required this.voted,
      required this.category})
      : super(key: key);

  final Rivalry rivalry;
  final voteState voted;
  final Category category;

  @override
  State<VoteBar> createState() => _VoteBarState();
}

class _VoteBarState extends State<VoteBar> {
  double competitorOneProportion = 0.5;
  double competitorTwoProportion = 0.5;

  // void addVote() {
  //   setState(() {
  //     currentState = voteState.afterVote;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    EloService _elo = EloService();
    double width = MediaQuery.of(context).size.width;
    double barWidth = width / 1.2;
    // double height = MediaQuery.of(context).size.height;
    // double sideLength = (width < height ? width : height);
    return Container(
      width: barWidth,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(barWidth / 20)),
      child: StreamBuilder<Map<String, int>>(
          stream: _elo.streamRivalryVotes(widget.category, widget.rivalry),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int votes_1 =
                  snapshot.data?[widget.rivalry.competitors[0].id] ?? 1;
              int votes_2 =
                  snapshot.data?[widget.rivalry.competitors[1].id] ?? 1;

              competitorOneProportion =
                  votes_1 + votes_2 > 0 ? votes_1 / (votes_1 + votes_2) : 0.5;
              competitorTwoProportion = 1.0 - competitorOneProportion;
              print("\n\ncompetitor 1 score: $competitorOneProportion\n\n");
              print("competitor 2 score: $competitorTwoProportion\n\n");
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: width / 8,
                  width: (widget.voted == voteState.beforeVote
                      ? 0.5 * barWidth
                      : competitorOneProportion * barWidth),
                  color: widget.voted == voteState.beforeVote
                      ? Colors.grey[400]
                      : Colors.blue,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: width / 8,
                  width: (widget.voted == voteState.beforeVote
                      ? 0.5 * barWidth
                      : competitorTwoProportion * barWidth),
                  color: widget.voted == voteState.beforeVote
                      ? Colors.grey[600]
                      : Colors.red,
                )
              ],
            );
          }),
    );
  }
}

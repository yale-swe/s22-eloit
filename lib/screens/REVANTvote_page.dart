import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/shared/ui_elements.dart';
import 'package:eloit/services/database.dart';
import 'package:eloit/services/elo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum voteState {
  loading,
  beforeVote,
  afterVote,
}

class VotePageRandom extends StatefulWidget {
  const VotePageRandom({Key? key, required this.category, required this.rivalry})
      : super(key: key);

  final Category category;
  final Rivalry rivalry;

  @override
  State<VotePageRandom> createState() => _VotePageStateRANDOM();
}

class _VotePageStateRANDOM extends State<VotePageRandom> {
  voteState voted = voteState.loading;
  final DatabaseService _db = DatabaseService();

  void loadVote() async {
    bool canVote = await _db.canVote(
        FirebaseAuth.instance.currentUser?.uid, widget.rivalry.rid);
    setState(() {
      voted = canVote ? voteState.beforeVote : voteState.afterVote;
    });
  }

  @override
  Widget build(BuildContext context) {
    EloService _elo = EloService();
    double pageWidth = MediaQuery.of(context).size.width;
    double avatarRadius = pageWidth / 8;

    if (voted == voteState.loading) {
      loadVote();
    }

    return Container(
      //appBar: createCustomAppBar(context, 'Vote'),
      child: voted != voteState.loading
          ? Column(
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child:
                                Text(widget.rivalry.competitors[0].item.name),
                          ),
                        ],
                      ),
                      onTap: () async {
                        if (voted == voteState.beforeVote) {
                          await _elo.vote(
                              widget.category,
                              widget.rivalry,
                              widget.rivalry.competitors[0],
                              FirebaseAuth.instance.currentUser?.uid);
                          setState(() {
                            voted = voteState.afterVote;
                          });
                        }
                      },
                    ),
                    Container(
                      height: pageWidth/10,
                      width: pageWidth/10,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'VS',
                          style: TextStyle(
                            fontSize: pageWidth/20,
                            shadows: const [
                              Shadow(
                                blurRadius: 10.0,
                                color: Color.fromARGB(255, 255, 255, 255),
                                offset: Offset(5.0, 5.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 4,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(60))
                      ),
                    ),
                    GestureDetector(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundImage: NetworkImage(
                                  widget.rivalry.competitors[1].item.avatarURL),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child:
                                  Text(widget.rivalry.competitors[1].item.name),
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (voted == voteState.beforeVote) {
                            await _elo.vote(
                                widget.category,
                                widget.rivalry,
                                widget.rivalry.competitors[1],
                                FirebaseAuth.instance.currentUser?.uid);
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
            )
          : const LinearProgressIndicator(),
    );
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
    double width = MediaQuery.of(context).size.width * 0.7;
    double barWidth = width / 1.2;
    // double height = MediaQuery.of(context).size.height;
    // double sideLength = (width < height ? width : height);
    return Container(
      width: barWidth,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(barWidth / 20)),
      child: StreamBuilder<Map>(
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
                  decoration: BoxDecoration(
                    borderRadius: competitorOneProportion < 1.0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )
                        : const BorderRadius.all(Radius.circular(20)),
                    color: widget.voted == voteState.beforeVote
                        ? Colors.grey[400]
                        : Colors.blue,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: width / 8,
                  width: (widget.voted == voteState.beforeVote
                      ? 0.5 * barWidth
                      : competitorTwoProportion * barWidth),
                  decoration: BoxDecoration(
                    borderRadius: competitorTwoProportion < 1.0
                        ? const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )
                        : const BorderRadius.all(Radius.circular(20)),
                    color: widget.voted == voteState.beforeVote
                        ? Colors.grey[600]
                        : Colors.red,
                  ),
                )
              ],
            );
          }),
    );
  }
}
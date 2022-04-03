import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/services/database.dart';
import 'package:eloit/services/elo.dart';
import 'package:flutter/material.dart';

class VotePage extends StatefulWidget {
  const VotePage({Key? key, required this.category, required this.rivalry})
      : super(key: key);

  final Category category;
  final Rivalry rivalry;

  @override
  State<VotePage> createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  bool voted = false;

  late Competitor competitorA = widget.rivalry.competitors[0];
  late Competitor competitorB = widget.rivalry.competitors[1];
  late int votesA = widget.rivalry.votes[competitorA.id] + 1;
  late int votesB = widget.rivalry.votes[competitorB.id] + 1;

  @override
  Widget build(BuildContext context) {
    EloService _elo = EloService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(competitorA.item.name),
                const SizedBox(width: 10),
                Expanded(
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      children: [
                        GestureDetector(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 20.0,
                            width: voted
                                ? constraints.minWidth *
                                    (votesA / (votesA + votesB))
                                : constraints.minWidth * 0.5,
                            color: voted ? Colors.blue : Colors.grey[400],
                          ),
                          onTap: () async {
                            await _elo.vote(
                                widget.category, widget.rivalry, competitorA);
                            setState(() {
                              votesA++;
                              voted = true;
                            });
                          },
                        ),
                        GestureDetector(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 20.0,
                            width: voted
                                ? constraints.minWidth *
                                    (votesB / (votesA + votesB))
                                : constraints.minWidth * 0.5,
                            color: voted ? Colors.redAccent : Colors.grey[600],
                          ),
                          onTap: () async {
                            await _elo.vote(
                                widget.category, widget.rivalry, competitorB);
                            setState(() {
                              votesB++;
                              voted = true;
                            });
                          },
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(width: 10),
                Text(competitorB.item.name),
              ],
            ),
          ),
          margin: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}

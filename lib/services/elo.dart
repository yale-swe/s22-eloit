/* 

usage
_elo = EloService()

_elo.vote(Compeitor, Rivalry, Winner)


 */

import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/services/database.dart';
import 'dart:math';

class EloService {
  final DatabaseService _db = DatabaseService();
  final K = 32;

  // assume A is the wining party
  int updateDelta(int winnerRating, int loserRating) {
    double expectation = 1 / (1 + pow(10, (loserRating - winnerRating) / 400));

    return (K * (1 - expectation)).round();
  }

  Future vote(Category category, Rivalry rivalry, Competitor winner) async {
    assert(rivalry.competitors.contains(winner));
    var loser = rivalry.competitors[0] == winner
        ? rivalry.competitors[1]
        : rivalry.competitors[0];

    int delta = updateDelta(winner.eloScore, loser.eloScore);
    // print("delta ${winner.eloScore} ${loser.eloScore} $delta");

    await _db.voteResult(category, rivalry, winner, loser, delta);
  }

  Stream<Map> streamRivalryVotes(Category category, Rivalry rivalry) {
    return _db.streamRivalryVotes(category, rivalry);
  }
}

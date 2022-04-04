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
    double pa = 1 / (1 + pow(10, (winnerRating - loserRating) / 400));

    return (K * (1 - pa)).round();
  }

  Future vote(Category category, Rivalry rivalry, Competitor winner) async {
    var loser = rivalry.competitors[0] == winner
        ? rivalry.competitors[1]
        : rivalry.competitors[0];

    int delta = updateDelta(winner.eloScore, loser.eloScore);

    await _db.voteResult(category, rivalry, winner, loser, delta);
  }

  Stream<Map<String, int>> streamRivalryVotes(
      Category category, Rivalry rivalry) {
    return _db.streamRivalryVotes(category, rivalry);
  }
}

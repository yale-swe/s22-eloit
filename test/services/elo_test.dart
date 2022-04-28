import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:eloit/services/elo.dart';

import 'package:eloit/setup_firestore.dart';

const uid = "abc";

void main() {
  group('local calculation test', () {
    test('basic', () {
      setupKiwi();
      final _elo = EloService();
      int delta = _elo.updateDelta(1400, 1400);
      expect(delta, 16);
      cleanupKiwi();
    });

    test('upset', () {
      setupKiwi();
      final _elo = EloService();
      int delta = _elo.updateDelta(1000, 1400);
      expect(delta, 29);
      cleanupKiwi();
    });
  });

  group('mock db', () {
    test('basic', () async {
      final instance = setupKiwi();
      final _db = DatabaseService();
      final _elo = EloService();
      final rivalryDocRef = await generateRivalry();
      final categoryDocRef = await getCategoryDoc();
      final category =
          Category.fromDocumentSnapshot(await categoryDocRef.get());

      final rivalrySnapshot = await rivalryDocRef.get();
      // print("rivalry ${rivalrySnapshot.data()}");

      final rivalry = await _db.getRivalry(category, rivalrySnapshot);
      final winner = rivalry.competitors[0];
      expect(winner.eloScore, 1400);
      await _elo.vote(category, rivalry, winner);

      Competitor updated = await _db.getCompetitor(category, winner.id);
      expect(updated.eloScore, 1416);

      for (var i = 0; i < 10; i++) {
        final rivalrySnapshot = await rivalryDocRef.get();
        final rivalry = await _db.getRivalry(category, rivalrySnapshot);
        // print("rivalry $rivalry");
        final winner = rivalry.competitors[0];
        await _elo.vote(category, rivalry, winner);
      }
      updated = await _db.getCompetitor(category, winner.id);
      expect(updated.eloScore, 1517);

      cleanupKiwi();
    });
  });
}

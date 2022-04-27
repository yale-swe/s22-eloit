import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:eloit/services/elo.dart';

import '../setup_firestore.dart';

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

    test('upset2', () {
      setupKiwi();
      final _elo = EloService();
      int delta = _elo.updateDelta(2400, 2000);
      expect(delta, 3);
      cleanupKiwi();
    });
    test('negative elo ratings', () {
      setupKiwi();
      final _elo = EloService();
      int delta = _elo.updateDelta(-100, -100);
      expect(delta, 16);
      cleanupKiwi();
    });
    test('large difference elo ratings', () {
      setupKiwi();
      final _elo = EloService();
      int delta = _elo.updateDelta(2400, 0);
      expect(delta, 0);
      cleanupKiwi();
    });
    test('positive, negative ratings', () {
      setupKiwi();
      final _elo = EloService();
      int delta = _elo.updateDelta(10, -10);
      expect(delta, 15);
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

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';

import 'package:eloit/setup_firestore.dart';

void main() {
  group('fake firestore functionalities', () {
    test('add a collection', () async {
      // final DatabaseService db = DatabaseService();
      setupKiwi();
      final id = await generateCategory();
      final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
      var snapshot = await instance.collection('categories').snapshots().first;
      var doc = snapshot.docs.first;
      expect(doc.id, id);
      cleanupKiwi();
    });

    test('add competitors', () async {
      setupKiwi();
      var l = await generateCompetitors();

      final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
      final doc = await getCategoryDoc();
      var ironmanCompetitor = doc.collection('competitors').doc(l[0].id);
      var x = await ironmanCompetitor.get();
      final competitor = Competitor.fromDocumentSnapshot(x);
      final url = competitor.item.avatarURL;
      final ironmanItemFromCompetitor = x.get("item");

      var ironmanFromItemSnapshot = await instance
          .collection('items')
          .where("name", isEqualTo: "ironman")
          .get();
      var ironmanItem = ironmanFromItemSnapshot.docs.first;

      expect(ironmanItemFromCompetitor["iid"], ironmanItem.id);
      expect(url, ironmanItem.data()["avatarURL"]);
      await dropCategories();
      var snapshot = await instance.collection('categories').get();
      expect(snapshot.docs.isEmpty, true);
      await dropItems();
      snapshot = await instance.collection('items').get();
      expect(snapshot.docs.isEmpty, true);
      cleanupKiwi();
    });

    test('add rivalry', () async {
      setupKiwi();
      final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
      final docRef = await generateRivalry();
      var doc = await docRef.get();
      final competitorIds = doc.get("itemIDs");
      var snapshot = await instance.collection('categories').get();
      var avengersRef = snapshot.docs.first.reference;
      var competitor0 = Competitor.fromDocumentSnapshot(await avengersRef
          .collection('competitors')
          .doc(competitorIds[0])
          .get());
      expect(competitor0.item.name, "ironman");
      cleanupKiwi();
    });
  });

  group('test rankings', () {
    test('under updates', () async {
      final instance = setupKiwi();
      final rivalryRef = await generateRivalry();
      final rivalrySnapshot = await rivalryRef.get();
      final catDocRef = await getCategoryDoc();
      final competitor0DocRef = catDocRef
          .collection('competitors')
          .doc(rivalrySnapshot.get('itemIDs')[0]);
      Competitor competitor0 =
          Competitor.fromDocumentSnapshot(await competitor0DocRef.get());

      expect(competitor0.eloScore, 1400);

      final db = DatabaseService();
      final Category category =
          Category.fromDocumentSnapshot(await catDocRef.get());
      await competitor0DocRef.update({"eloScore": 1500});
      final stream = db.rankings(category);
      // stream.listen((event) {
      //   print("length ${event.length}");
      //   for (var c in event) {
      //     print("c $c");
      //   }
      // });
      expect(
          stream,
          emitsInOrder([
            predicate<List<Competitor>>((competitors) {
              final flag1 = competitors[0].id == competitor0.id;
              final flag2 = competitors[0].eloScore == 1500;
              return flag1 && flag2;
            }),
            predicate<List<Competitor>>((competitors) {
              final flag1 = competitors[1].id == competitor0.id;
              final flag2 = competitors[1].eloScore == 1300;
              return flag1 && flag2;
            }),
          ]));

      competitor0DocRef.update({"eloScore": 1300});

      cleanupKiwi();
    });
  });
}

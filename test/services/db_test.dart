import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';

import '../setup_firestore.dart';

void main() {
  setupFakeFirestore();
  test('add a collection', () async {
    // final DatabaseService db = DatabaseService();

    final id = await generateCategory();
    final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
    var snapshot = await instance.collection('categories').snapshots().first;
    var doc = snapshot.docs.first;
    expect(doc.id, id);
    await instance.collection('categories').doc(id).delete();
  });

  test('add competitors', () async {
    var l = await generateCompetitors();

    final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
    var snapshot = await instance.collection('categories').snapshots().first;

    var doc = snapshot.docs.first.reference;
    var ironmanCompetitor = doc.collection('competitors').doc(l[0].id);
    var x = await ironmanCompetitor.get();
    DocumentReference ironmanItemFromCompetitor = x.get("item");

    var ironmanFromItemSnapshot = await instance
        .collection('items')
        .where("name", isEqualTo: "ironman")
        .get();
    var ironmanItem = ironmanFromItemSnapshot.docs.first.reference;

    expect(ironmanItemFromCompetitor.id, ironmanItem.id);
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/item.dart';
import 'package:eloit/models/rivalry.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  DatabaseService();

  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection('items');
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Competitor>> rankings(Category category) {
    return categoryCollection
        .doc(category.cid)
        .collection('competitors')
        .orderBy('eloScore', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Competitor.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<Rivalry>> categoryRivalries(Category category) {
    return categoryCollection
        .doc(category.cid)
        .collection('rivalries')
        .snapshots()
        .asyncMap(
          (event) => Future.wait([
            for (DocumentSnapshot doc in event.docs) getRivalry(category, doc)
          ]),
        );
  }

  Future<Rivalry> getRivalry(Category category, DocumentSnapshot doc) async {
    List itemIDs = doc.get('itemIDs');
    List<Future<Competitor>> competitorFutures =
        itemIDs.map((cid) => getCompetitor(category, cid)).toList();
    Future<List<Competitor>> futureCompetitors = Future.wait(competitorFutures);
    List<Competitor> competitorList = await futureCompetitors;

    return Rivalry.fromDocumentSnapshot(doc, competitorList);
  }

  Future<Competitor> getCompetitor(Category category, String cid) async {
    DocumentSnapshot doc = await categoryCollection
        .doc(category.cid)
        .collection('competitors')
        .doc(cid)
        .snapshots()
        .first;

    return Competitor.fromDocumentSnapshot(doc);
  }

  Future vote(Category category, Rivalry rivalry, Competitor competitor) async {
    await categoryCollection
        .doc(category.cid)
        .collection('competitors')
        .doc(competitor.id)
        .update({
      'eloScore': FieldValue.increment(1),
    });

    return await categoryCollection
        .doc(category.cid)
        .collection('rivalries')
        .doc(rivalry.rid)
        .update({
      'votes.${competitor.id}': FieldValue.increment(1),
    });
  }
}

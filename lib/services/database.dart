import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/item.dart';
import 'package:eloit/models/user.dart';

import 'package:eloit/models/rivalry.dart';
import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DatabaseService {
  DatabaseService();

  final CollectionReference itemCollection = KiwiContainer()
      .resolve<FirebaseFirestore>('firebase')
      .collection('items');
  final CollectionReference categoryCollection = KiwiContainer()
      .resolve<FirebaseFirestore>('firebase')
      .collection('categories');
  final CollectionReference userCollection = KiwiContainer()
      .resolve<FirebaseFirestore>('firebase')
      .collection('users');
  final CollectionReference voteCollection = KiwiContainer()
      .resolve<FirebaseFirestore>('firebase')
      .collection('votes');

  // needed to get the current user

  Stream<List<Category>> searchCategory(String searchText, {int limit = 3}) {
    return categoryCollection
        .where('name', isGreaterThanOrEqualTo: searchText)
        .where('name', isLessThanOrEqualTo: searchText + '\uf7ff')
        .limit(limit)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Category.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<Rivalry>> searchRivalry(String searchText, {int limit = 3}) {
    return FirebaseFirestore.instance
        .collectionGroup('rivalries')
        .where('name', isGreaterThanOrEqualTo: searchText)
        .where('name', isLessThanOrEqualTo: searchText + '\uf7ff')
        .limit(limit)
        .snapshots()
        .asyncMap(
          (event) => Future.wait([
            for (DocumentSnapshot doc in event.docs)
              getRivalryString(doc.reference.parent.parent!.id, doc)
          ]),
        );
  }

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

  Stream<Map> streamRivalryVotes(Category category, Rivalry rivalry) {
    return categoryCollection
        .doc(category.cid)
        .collection('rivalries')
        .doc(rivalry.rid)
        .snapshots()
        .map((event) => event.get('votes'));
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

  Future<Rivalry> getRivalryString(
      String categoryID, DocumentSnapshot doc) async {
    List itemIDs = doc.get('itemIDs');
    List<Future<Competitor>> competitorFutures =
        itemIDs.map((cid) => getCompetitorString(categoryID, cid)).toList();
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

  Future<Category> getCategory(String cid) async {
    DocumentSnapshot doc = await categoryCollection.doc(cid).snapshots().first;

    return Category.fromDocumentSnapshot(doc);
  }

  Future<Competitor> getCompetitorString(String categoryID, String cid) async {
    DocumentSnapshot doc = await categoryCollection
        .doc(categoryID)
        .collection('competitors')
        .doc(cid)
        .snapshots()
        .first;

    return Competitor.fromDocumentSnapshot(doc);
  }

  Future voteResult(Category category, Rivalry rivalry, Competitor winner,
      Competitor loser, int increase, [String? uid]) async{
    WriteBatch batch =
        KiwiContainer().resolve<FirebaseFirestore>('firebase').batch();

    var competitors =
        categoryCollection.doc(category.cid).collection('competitors');

    batch.update(competitors.doc(winner.id),
        {'eloScore': FieldValue.increment(increase)});
    batch.update(competitors.doc(loser.id),
        {'eloScore': FieldValue.increment(-increase)});

    var docRivalry = categoryCollection
        .doc(category.cid)
        .collection('rivalries')
        .doc(rivalry.rid);

    batch.update(docRivalry, {
      'votes.${winner.id}': FieldValue.increment(1),
    });

    DocumentReference voteRef = voteCollection.doc();
    batch.set(voteRef, {
      'userID': uid,
      'categoryID': category.cid,
      'rivalryID': rivalry.rid,
      'competitorID': winner.id,
    });

    return batch.commit();
  }

  Future addUser(String uid, String email) async {
    await userCollection.doc(uid).set({"email": email});
  }
}

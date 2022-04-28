import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eloit/models/category.dart';
import 'package:eloit/models/competitor.dart';
import 'package:eloit/models/item.dart';
import 'package:eloit/models/user.dart';

import 'package:eloit/models/rivalry.dart';
import 'package:eloit/models/vote.dart';
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
  // final CollectionReference rivalryCollection = KiwiContainer()
  //     .resolve<FirebaseFirestore>('firebase')
  //     .collection('rivalries');

  Stream<List<Category>> searchCategory(String searchText, {int limit = 3}) {
    return categoryCollection
        .where('searchKey', isGreaterThanOrEqualTo: searchText.toLowerCase())
        .where('searchKey',
            isLessThanOrEqualTo: searchText.toLowerCase() + '\uf7ff')
        .limit(limit)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Category.fromDocumentSnapshot(doc))
            .toList());
  }

  Stream<List<Rivalry>> searchRivalry(String searchText, {int limit = 3}) {
    return FirebaseFirestore.instance
        .collectionGroup('rivalries')
        .where('name', isGreaterThanOrEqualTo: searchText.toLowerCase())
        .where('name', isLessThanOrEqualTo: searchText.toLowerCase() + '\uf7ff')
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

  Stream<List<Vote>> voteHistory(String? userID) {
    return voteCollection
        .where('userID', isEqualTo: userID)
        .orderBy('time', descending: true)
        .snapshots()
        .asyncMap(
          (event) => Future.wait(
            [for (DocumentSnapshot doc in event.docs) getVote(doc)],
          ),
        );
  }

  Future<bool> canVote(String? userID, String rivalryID) async {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(
        now.year, now.month, now.day - 1, now.hour, now.minute, now.second);
    QuerySnapshot query = await voteCollection
        .where('userID', isEqualTo: userID)
        .where('rivalryID', isEqualTo: rivalryID)
        .where('time', isGreaterThan: yesterday)
        .get();
    return query.docs.isEmpty;
  }

  Future<Vote> getVote(DocumentSnapshot doc) async {
    DocumentSnapshot rivalryDoc = await categoryCollection
        .doc(doc.get('categoryID'))
        .collection('rivalries')
        .doc(doc.get('rivalryID'))
        .get();
    Rivalry rivalry = await getRivalryString(doc.get('categoryID'), rivalryDoc);
    return Vote.fromDocumentSnapshot(doc, rivalry);
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
      Competitor loser, int increase,
      [String? uid]) async {
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
      'time': FieldValue.serverTimestamp(),
    });

    return batch.commit();
  }

  Future addUser(String? uid, String? email) async {
    await userCollection.doc(uid).set({"email": email});
  }

  Future<Rivalry> createRivalry(
      String cid, Competitor competitor1, Competitor competitor2) async {
    // DocumentReference p1Ref = itemCollection.doc(
    //     iid1); // could also make it get the data from competitors subcollection
    // DocumentSnapshot p1Snap = await p1Ref.get();
    // Item p1 = Item.fromDocumentSnapshot(p1Snap);
    //
    // DocumentReference p2Ref = itemCollection.doc(
    //     iid2); // could also make it get the data from competitors subcollection
    // DocumentSnapshot p2Snap = await p2Ref.get();
    // Item p2 = Item.fromDocumentSnapshot(p2Snap);

    QuerySnapshot currentRivOptions = await categoryCollection
        .doc(cid)
        .collection('rivalries')
        .where('itemIDs', arrayContains: competitor1.id)
        .get();
    List<DocumentSnapshot> rivDocs = currentRivOptions.docs
        .where((doc) => doc.get('itemIDs').contains(competitor2.id))
        .toList();
    if (rivDocs.isNotEmpty) {
      return Rivalry.fromDocumentSnapshot(
          rivDocs.first, [competitor1, competitor2]);
    } else {
      DocumentReference newRivRef =
          await categoryCollection.doc(cid).collection('rivalries').add({
        'cid': cid,
        'itemIDs': [competitor1.id, competitor2.id],
        'name': competitor1.item.name.toLowerCase() +
            " vs " +
            competitor2.item.name.toLowerCase(),
        'votes': {competitor1.id: 0, competitor2.id: 0},
      });
      DocumentSnapshot doc = await newRivRef.get();
      return Rivalry.fromDocumentSnapshot(doc, [competitor1, competitor2]);
    }

    // DocumentReference rivDocRef = categoryCollection.doc();
    // await rivDocRef.set({
    //   'cid': cid,
    //   'itemIDs': [p1.iid, p2.iid],
    //   'name': p1.name + " vs " + p2.name,
    //   'votes': {p1.iid: 0, p2.iid: 0},
    // });
  }

  Future<List<Competitor>> getCompetitors(Category category) async {
    QuerySnapshot snapshot = await categoryCollection
        .doc(category.cid)
        .collection('competitors')
        .get();

    return snapshot.docs
        .map((doc) => Competitor.fromDocumentSnapshot(doc))
        .toList();
  }

  Future<void> addUserFeedback(String feedback, String category) async {
    // QuerySnapshot feedbackUpload = await categoryCollection
    //     .col("userFeedback")
    await FirebaseFirestore.instance.collection('userFeedback').add({
      'category': category,
      'feedback': feedback,
      'date': DateTime.now(),
    });
  }

  Future<int> docCount() async {
    var querySize = await FirebaseFirestore.instance
        .collection("categories")
        .get(); // will return the collection size only for less than 100 roughly
    return querySize.size;
  }

  Future<Category> randomCategory() async {
    // Arbitrary random document name to check to the "left" and "right" of
    String randIndex = FirebaseFirestore.instance.collection('tmp').doc().id;
    // 0 represents less than and 1 represents greater than
    int randType = Random().nextInt(2);

    // Get a QuerySnapshot with a single random category
    QuerySnapshot snapshot;
    randType == 1
        ? snapshot = await categoryCollection
            .where('__name__', isGreaterThanOrEqualTo: randIndex)
            .orderBy('__name__')
            .limit(1)
            .get()
        : snapshot = await categoryCollection
            .where('__name__', isLessThanOrEqualTo: randIndex)
            .orderBy('__name__')
            .limit(1)
            .get();

    // Return a Category from the QuerySnapshot
    return Category.fromDocumentSnapshot(snapshot.docs.first);
  }

  Future<Rivalry> randomRivalry() async {
    // Get a random category to select the rivalry from
    Category randomCat = await randomCategory();

    // Arbitrary random document name to check to the "left" and "right" of
    String randIndex = FirebaseFirestore.instance.collection('tmp').doc().id;
    // 0 represents less than and 1 represents greater than
    int randType = Random().nextInt(2);

    // Get a QuerySnapshot with a single random rivalry from the category
    QuerySnapshot snapshot;
    randType == 1
        ? snapshot = await categoryCollection
            .doc(randomCat.cid)
            .collection('rivalries')
            .where('__name__', isGreaterThanOrEqualTo: randIndex)
            .orderBy('__name__')
            .limit(1)
            .get()
        : snapshot = await categoryCollection
            .doc(randomCat.cid)
            .collection('rivalries')
            .where('__name__', isLessThanOrEqualTo: randIndex)
            .orderBy('__name__')
            .limit(1)
            .get();

    // Return a Category from the QuerySnapshot
    return getRivalry(randomCat, snapshot.docs.first);
  }
}

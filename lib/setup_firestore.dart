import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';

FakeFirebaseFirestore setupKiwi() {
  final instance = FakeFirebaseFirestore();
  KiwiContainer container = KiwiContainer();
  container.registerInstance<FirebaseFirestore>(instance, name: 'firebase');
  container.registerInstance<FakeFirebaseFirestore>(instance,
      name: 'fakefirebase');
  return instance;
}

void cleanupKiwi() {
  KiwiContainer container = KiwiContainer();
  container.clear();
}

void dumpInstance(label) {
  var x = KiwiContainer().resolve<FakeFirebaseFirestore>('fakefirebase');
  print('$label: ${x.dump()}');
}

Future<String> generateCategory() async {
  KiwiContainer container = KiwiContainer();
  final instance = container.resolve<FirebaseFirestore>('firebase');
  final CollectionReference categoryCollection =
      instance.collection('categories');
  var doc = await categoryCollection
      .add({"name": "Avengers", "coverPicURL": "https://www.google.com"});
  var id = doc.id;
  return id;
}

Future<String> createUser() async {
  KiwiContainer container = KiwiContainer();
  final instance = container.resolve<FirebaseFirestore>('firebase');

  final CollectionReference users = instance.collection('users');
  var doc = await users
      .add({"email": "test@test.com"});
  var id = doc.id;
  return id;
}

Future<DocumentReference> getCategoryDoc() async {
  final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
  var snapshot = await instance.collection('categories').snapshots().first;
  return snapshot.docs.first.reference;
}

Future<List<DocumentReference>> generateItems() async {
  final CollectionReference itemCollection = KiwiContainer()
      .resolve<FirebaseFirestore>('firebase')
      .collection('items');

  var ironman = await itemCollection.add(
      {"name": "ironman", "avatarURL": "ironmanItem.png", "categoryIDs": []});
  var hulk = await itemCollection
      .add({"name": "hulk", "avatarURL": "hulkItem.png", "categoryIDs": []});
  return [ironman, hulk];
}

Future<List<DocumentReference>> generateCompetitors() async {
  var catId = await generateCategory();
  var l = await generateItems();
  final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
  final competitorCollection =
      instance.collection('categories').doc(catId).collection('competitors');
  final itemCollection = instance.collection('items');
  final objectList = await Future.wait(l.map((e) async => await e.get()));

  final data = objectList.map((e) {
    final m = Map<String, dynamic>.from(e.data() as Map<dynamic, dynamic>);
    m.addAll({"iid": e.id});
    return m;
  }).toList();

  final ironman = await competitorCollection.add({
    "eloScore": 1400,
    "item": data[0],
  });

  await itemCollection.doc(l[0].id).update({
    "categoryIDs": FieldValue.arrayUnion([catId])
  });

  final hulk = await competitorCollection.add({
    "eloScore": 1400,
    "item": data[1],
  });
  await itemCollection.doc(l[1].id).update({
    "categoryIDs": FieldValue.arrayUnion([catId])
  });
  // dumpInstance("after generateCompetitors");
  return [ironman, hulk];
}

Future<DocumentReference> generateRivalry() async {
  final l = await generateCompetitors();
  final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
  final rivalryCollection = await instance
      .collection('categories')
      .get()
      .then((value) => value.docs.first.reference.collection('rivalries'));
  final categoryDocRef = await getCategoryDoc();

  return await rivalryCollection.add({
    'itemIDs': [l[0].id, l[1].id],
    'votes': {
      l[0].id: 0,
      l[1].id: 0,
    },
    'cid': categoryDocRef.id
  });
}

Future dropCollection(CollectionReference collection) async {
  var snapshot = await collection.get();
  final futures = snapshot.docs.map((e) => e.reference.delete());
  await Future.wait(futures);
}

Future dropCategories() async {
  final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
  var snapshot = await instance.collection('categories').get();
  var futures = snapshot.docs.map((e) {
    return dropCollection(e.reference.collection('competitors'));
  });
  await Future.wait(futures);

  futures = snapshot.docs.map((e) => e.reference.delete());
  await Future.wait(futures);
}

Future dropItems() async {
  final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
  await dropCollection(instance.collection('items'));
}

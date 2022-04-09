import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';

void setupFakeFirestore() {
  final instance = FakeFirebaseFirestore();
  KiwiContainer container = KiwiContainer();
  container.registerInstance<FirebaseFirestore>(instance, name: 'firebase');
  container.registerInstance<FakeFirebaseFirestore>(instance,
      name: 'fakefirebase');
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

Future<List<DocumentReference>> generateItems() async {
  final CollectionReference itemCollection = KiwiContainer()
      .resolve<FirebaseFirestore>('firebase')
      .collection('items');

  var ironman = await itemCollection
      .add({"name": "ironman", "avartarURL": "", "categoryIDs": []});
  var hulk = await itemCollection
      .add({"name": "hulk", "avartarURL": "", "categoryIDs": []});
  return [ironman, hulk];
}

Future<List<DocumentReference>> generateCompetitors() async {
  var catId = await generateCategory();
  var l = await generateItems();
  final instance = KiwiContainer().resolve<FirebaseFirestore>('firebase');
  final competitorCollection =
      instance.collection('categories').doc(catId).collection('competitors');
  final itemCollection = instance.collection('items');

  final ironman = await competitorCollection.add({
    "eloScore": 1400,
    "item": l[0],
  });

  await itemCollection.doc(l[0].id).update({
    "categoryIds": FieldValue.arrayUnion([catId])
  });

  final hulk = await competitorCollection.add({
    "eloScore": 1400,
    "item": l[1],
  });
  await itemCollection.doc(l[1].id).update({
    "categoryIds": FieldValue.arrayUnion([catId])
  });
  return [ironman, hulk];
}

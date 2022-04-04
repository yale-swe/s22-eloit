import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eloit/services/database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cloud_firestore_mock.dart';

void main() {
  setupCloudFirestoreMocks();

  test('Sets data for a document within a collection', () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').doc(uid).set({
      'name': 'Bob',
    });
    expect(instance.dump(), equals(expectedDumpAfterset));
  });
}

import 'package:test/test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

const uid = "abc";

void main() {
  const expectedDumpAfterset = '''{
  "users": {
    "abc": {
      "name": "Bob"
    }
  }
}''';

  test('Sets data for a document within a collection', () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').doc(uid).set({
      'name': 'Bob',
    });
    expect(instance.dump(), equals(expectedDumpAfterset));
  });
}

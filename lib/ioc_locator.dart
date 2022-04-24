import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiwi/kiwi.dart';

void iocLocator() {
  KiwiContainer container = KiwiContainer();

  container.registerInstance(FirebaseFirestore.instance, name: 'firebase');
}

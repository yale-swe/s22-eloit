import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Rivalry extends Equatable {
  final String rid;
  final String item1ID;
  final String item2ID;
  final int votes1;
  final int votes2;

  const Rivalry({
    required this.rid,
    required this.item1ID,
    required this.item2ID,
    this.votes1 = 0,
    this.votes2 = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'item1ID': item1ID,
      'item2ID': item2ID,
      'votes1': votes1,
      'votes2': votes2,
    };
  }

  @override
  List<Object> get props {
    return [rid, item1ID, item2ID, votes1, votes2];
  }

  @override
  bool get stringify => true;

  Rivalry.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : rid = doc.id,
        item1ID = doc.get("item1ID"),
        item2ID = doc.get("item2ID"),
        votes1 = doc.get("votes1"),
        votes2 = doc.get("votes2");
}

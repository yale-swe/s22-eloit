import 'package:eloit/models/item.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Competitor extends Equatable {
  final String id;
  final Item item;
  final int eloScore;

  const Competitor(
      {required this.id, required this.item, required this.eloScore});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'item': item.toMap(),
      'eloScore': eloScore,
    };
  }

  @override
  List<Object> get props {
    return [id, item, eloScore];
  }

  @override
  bool get stringify => true;

  Competitor.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        item = Item.fromMap(doc.get("item")),
        eloScore = (doc.get("eloScore")).toInt();
}

import 'package:eloit/models/rivalry.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Vote extends Equatable {
  final String vid;
  final String categoryID;
  final String rivalryID;
  final String competitorID;
  final DateTime time;
  final Rivalry rivalry;

  const Vote({
    required this.vid,
    required this.categoryID,
    required this.rivalryID,
    required this.competitorID,
    required this.time,
    required this.rivalry,
  });

  Map<String, dynamic> toMap() {
    return {
      'vid': vid,
      'categoryID': categoryID,
      'rivalryID': rivalryID,
      'competitorID': competitorID,
      'time': time,
      'rivalry': rivalry,
    };
  }

  @override
  List<Object> get props {
    return [vid, categoryID, rivalryID, competitorID, time, rivalry];
  }

  @override
  bool get stringify => true;

  Vote.fromDocumentSnapshot(DocumentSnapshot doc, this.rivalry)
      : vid = doc.id,
        categoryID = doc.get("categoryID"),
        rivalryID = doc.get("rivalryID"),
        competitorID = doc.get("competitorID"),
        time = doc.get("time").toDate();
}

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Vote extends Equatable {
  final String vid;
  final String categoryID;
  final String rivalryID;
  final String competitorID;
  final DateTime time;

  const Vote({
    required this.vid,
    required this.categoryID,
    required this.rivalryID,
    required this.competitorID,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'vid': vid,
      'categoryID': categoryID,
      'rivalryID': rivalryID,
      'competitorID': competitorID,
      'time': time,
    };
  }

  @override
  List<Object> get props {
    return [vid, categoryID, rivalryID, competitorID, time];
  }

  @override
  bool get stringify => true;

  Vote.fromDocumentSnapshot(DocumentSnapshot doc)
      : vid = doc.id,
        categoryID = doc.get("categoryID"),
        rivalryID = doc.get("rivalryID"),
        competitorID = doc.get("competitorID"),
        time = doc.get("time");
}

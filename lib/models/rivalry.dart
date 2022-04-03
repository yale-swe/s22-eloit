import 'package:eloit/models/competitor.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Rivalry extends Equatable {
  final String rid;
  final List itemIDs;
  final Map votes;
  final List<Competitor> competitors;

  const Rivalry({
    required this.rid,
    required this.itemIDs,
    required this.votes,
    required this.competitors,
  });

  Map<String, dynamic> toMap() {
    return {
      'rid': rid,
      'itemIDs': itemIDs,
      'votes': votes,
    };
  }

  @override
  List<Object> get props {
    return [rid, itemIDs, votes];
  }

  @override
  bool get stringify => true;

  Rivalry.fromDocumentSnapshot(
      DocumentSnapshot doc, List<Competitor> competitorList)
      : rid = doc.id,
        itemIDs = doc.get("itemIDs"),
        votes = doc.get("votes"),
        competitors = competitorList;
}

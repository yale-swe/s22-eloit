import 'package:eloit/models/competitor.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Rivalry extends Equatable {
  final String rid;
  final String cid;
  final List itemIDs;
  final Map votes;
  final List<Competitor> competitors; // feels unnecessary now
  final String name;

  const Rivalry({
    required this.rid,
    required this.cid,
    required this.itemIDs,
    required this.votes,
    required this.competitors,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'rid': rid,
      'cid': cid,
      'itemIDs': itemIDs,
      'votes': votes,
      'name': name,
    };
  }

  @override
  List<Object> get props {
    return [rid, cid, itemIDs, votes, name];
  }

  @override
  bool get stringify => true;

  Rivalry.fromDocumentSnapshot(
      DocumentSnapshot doc, List<Competitor> competitorList)
      : rid = doc.id,
        cid = doc.get("cid"),
        itemIDs = doc.get("itemIDs"),
        votes = doc.get("votes"),
        name = doc.get("name"),
        competitors = competitorList;
}

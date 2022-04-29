import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category extends Equatable {
  final String cid;
  final String name;
  final String coverPicURL;
  int totalVotes;

  Category(
      {required this.cid, required this.name, required this.coverPicURL, this.totalVotes=0});

  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'name': name,
      'coverPicURL': coverPicURL,
      'totalVotes': totalVotes,
    };
  }

  @override
  List<Object> get props {
    return [cid, name, coverPicURL, totalVotes];
  }

  @override
  bool get stringify => true;

  Category.fromDocumentSnapshot(DocumentSnapshot doc)
      : cid = doc.id,
        name = doc.get("name"),
        coverPicURL = doc.get("coverPicURL"),
        totalVotes = doc.get("totalVotes");
}

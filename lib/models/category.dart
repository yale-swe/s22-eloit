import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category extends Equatable {
  final String cid;
  final String name;
  final String coverPicURL;

  const Category(
      {required this.cid, required this.name, required this.coverPicURL});

  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'name': name,
      'coverPicURL': coverPicURL,
    };
  }

  @override
  List<Object> get props {
    return [cid, name, coverPicURL];
  }

  @override
  bool get stringify => true;

  Category.fromDocumentSnapshot(DocumentSnapshot doc)
      : cid = doc.id,
        name = doc.get("name"),
        coverPicURL = doc.get("coverPicURL");
}

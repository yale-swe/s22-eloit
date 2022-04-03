import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item extends Equatable {
  final String iid;
  final String name;
  final String avatarURL;
  final List categoryIDs; // We add a category ID every time we construct a Competitor class

  const Item({
    required this.iid,
    required this.name,
    required this.avatarURL,
    required this.categoryIDs,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': iid,
      'name': name,
      'avatarURL': avatarURL,
      'categoryIDs': categoryIDs,
    };
  }

  @override
  List<Object> get props {
    return [iid, name, avatarURL, categoryIDs];
  }

  @override
  bool get stringify => true;

  Item.fromMap(Map<String, dynamic> itemMap)
      : iid = itemMap["iid"],
        name = itemMap["name"],
        avatarURL = itemMap["avatarURL"],
        categoryIDs = itemMap["categoryIDs"];

  Item.fromDocumentSnapshot(DocumentSnapshot doc)
      : iid = doc.id,
        name = doc.get("name"),
        avatarURL = doc.get("avatarURL"),
        categoryIDs = doc.get("categoryIDs");
}

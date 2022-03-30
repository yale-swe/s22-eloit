import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser extends Equatable {
  final String uid;
  final String username;
  final String email;
  final String phone;
  final DateTime joined;
  final String photoURL;

  const CustomUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    required this.joined,
    required this.photoURL,
  });

  @override
  String toString() {
    return 'CustomUser: {uid: $uid, username: $username, email: $email, phone: $phone, joined: $joined, photoURL: $photoURL}';
  }

  @override
  List<Object> get props {
    return [uid, username, email, phone, joined, photoURL];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'joined': joined,
      'photoURL': photoURL,
    };
  }

  CustomUser.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        username = doc.get('username'),
        email = doc.get('email'),
        phone = doc.get('phone'),
        joined = doc.get('joined'),
        photoURL = doc.get('photoURL');
}

class Category extends Equatable {
  final String cid;
  final String name;
  final String coverPicURL;

  const Category({
    required this.cid,
    required this.name,
    required this.coverPicURL
  });

  Map<String, dynamic> toMap() {
    return {
      'cid' : cid,
      'name': name,
      'coverPicURL': coverPicURL,
    };
  }

  @override
  List<Object> get props {
    return [cid, name, coverPicURL];
  }

  Category.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : cid = doc.id,
        name = doc.get("name"),
        coverPicURL = doc.get("coverPicURL");
}


class Item extends Equatable {
  final String iid;
  final String name;
  final String avatarURL;
  List<String> categoryIDs; // We add a category ID every time we construct a Competitor class

  Item({
    required this.iid,
    required this.name,
    required this.avatarURL,
  }) : categoryIDs = <String>[];

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

  Item.fromMap(Map<String, dynamic> itemMap)
      : iid = itemMap["iid"],
        name = itemMap["name"],
        avatarURL = itemMap["avatarURL"],
        categoryIDs = itemMap["categoryIDs"];

  Item.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : iid = doc.id,
        name = doc.get("name"),
        avatarURL = doc.get("avatarURL"),
        categoryIDs = doc.get("categoryIDs") ?? null;
}


class Competitor extends Equatable {
  final String id;
  final Item item;
  int eloScore;

  Competitor({required this.id, required this.item, required String cid, this.eloScore = 0}) {
    item.categoryIDs.add(cid);
  }

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

  Competitor.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        item = Item.fromMap(doc.get("item")),
        eloScore = doc.get("eloScore");
}


class Rivalry extends Equatable {
  final String rid;
  final String item1ID;
  final String item2ID;
  int votes1;
  int votes2;

  Rivalry({
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

  Rivalry.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : rid = doc.id,
        item1ID = doc.get("item1ID"),
        item2ID = doc.get("item2ID"),
        votes1 = doc.get("votes1"),
        votes2 = doc.get("votes2");
}


class Vote extends Equatable{
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

  Vote.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : vid = doc.id,
        categoryID = doc.get("categoryID"),
        rivalryID = doc.get("rivalryID"),
        competitorID = doc.get("competitorID"),
        time = doc.get("time");
}
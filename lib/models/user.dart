import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser extends Equatable {
  final String uid;
  final String username;
  final DateTime joined;
  final String photoURL;

  const CustomUser({
    required this.uid,
    required this.username,
    required this.joined,
    required this.photoURL,
  });

  @override
  String toString() {
    return 'CustomUser: {uid: $uid, username: $username, joined: $joined, photoURL: $photoURL}';
  }

  @override
  List<Object> get props {
    return [uid, username, joined, photoURL];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'joined': joined,
      'photoURL': photoURL,
    };
  }

  CustomUser.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        username = doc.get('username'),
        joined = doc.get('joined'),
        photoURL = doc.get('photoURL');
}

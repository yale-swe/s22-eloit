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
  List<Object> get props {
    return [uid, username, email, phone, joined, photoURL];
  }

  @override
  bool get stringify => true;

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

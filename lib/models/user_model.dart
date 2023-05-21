import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String email;
  final String name;
  final String uid;
  final Userrole role;
  // final List followers;
  // final List following;

  UserModel(
      {required this.email,
      required this.name,
      required this.uid,
      this.role = Userrole.customer,
      // required this.followers,
      // required this.following
      });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "name": name,
        "role": role.toString(),
        // "followers": followers,
        // "following": following,
      };

  static UserModel? fromSnap (DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      name: snapshot['name'],
      role: snapshot['role'] == 'Userrole.admin' ? Userrole.admin :Userrole.customer,
      // following: snapshot['following'],
      // followers: snapshot['followers'],
      email: snapshot['email'],
    );
  }
}
enum Userrole{
  admin,
  customer
}
class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool online;
  final String lastSeen;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.online,
    required this.lastSeen,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "online": online,
      "lastSeen": lastSeen,
    };
  }

  factory UserModel.fromJson(
      Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
      online: json["online"],
      lastSeen: json["lastSeen"],
    );
  }
}
class UserProfile {
  final String uid;
  final String email;
  final String? displayName;

  UserProfile({required this.uid, required this.email, this.displayName});

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
      };

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        uid: m['uid'],
        email: m['email'],
        displayName: m['displayName'],
      );
}

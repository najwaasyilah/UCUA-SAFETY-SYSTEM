class UserProfile {
  String name;
  String email;
  String department;
  String profilePicture;

  UserProfile({
    required this.name,
    required this.email,
    required this.department,
    this.profilePicture = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'department': department,
      'profilePicture': profilePicture,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      department: json['department'],
      profilePicture: json['profilePicture'],
    );
  }
}

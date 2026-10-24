/// Model representing a community user or authenticated user
class UserModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String image;
  final String companyName;
  final String? token;

  const UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.username = '',
    this.image = '',
    this.companyName = 'Community member',
    this.token,
  });

  /// Full formatted name
  String get fullName => '$firstName $lastName'.trim().isEmpty
      ? (username.isNotEmpty ? username : 'FoodLoop User')
      : '$firstName $lastName'.trim();

  /// User avatar initials fallback
  String get initial {
    if (firstName.isNotEmpty) return firstName[0].toUpperCase();
    if (username.isNotEmpty) return username[0].toUpperCase();
    return 'U';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String parsedCompany = 'Community member';
    if (json['company'] is Map) {
      parsedCompany = (json['company']['name'] ?? 'Community member')
          .toString();
    } else if (json['company'] != null) {
      parsedCompany = json['company'].toString();
    }

    return UserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      companyName: parsedCompany,
      token: (json['token'] ?? json['accessToken'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'image': image,
      'company': {'name': companyName},
      if (token != null) 'token': token,
    };
  }
}

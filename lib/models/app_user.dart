class AppUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  AppUser({  // <-- Change the constructor name to AppUser
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  // Factory method to create an AppUser object from a map (e.g., from Firebase)
  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
    );
  }

  // Method to convert an AppUser object into a map (e.g., for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String zone;
  final String availableDays;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.zone,
    required this.availableDays,
    required this.createdAt,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'zone': zone,
      'availableDays': availableDays,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Crear desde Map de Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      zone: map['zone'] ?? '',
      availableDays: map['availableDays'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Nombre completo
  String get fullName => '$firstName $lastName';
}

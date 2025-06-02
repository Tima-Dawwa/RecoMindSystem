class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? dateOfBirth;
  final String? countryCode;
  final String? number;

  UserModel({
    required this.countryCode,
    required this.number,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
  });

  factory UserModel.fromJson(jsonData) {
    return UserModel(
      email: jsonData['email'],
      firstName: jsonData['first_name'],
      lastName: jsonData['last_name'],
      gender: jsonData['gender'],
      dateOfBirth: jsonData['date_of_birth'],
      countryCode: jsonData['phone']['country_code'],
      number: jsonData['phone']['number'],
    );
  }
}

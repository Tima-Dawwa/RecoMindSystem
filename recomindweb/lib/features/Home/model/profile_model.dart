import 'package:recomindweb/features/Home/model/location_model.dart';
import 'package:recomindweb/features/Home/model/name_model.dart';
import 'package:recomindweb/features/Home/model/number_model.dart';

class ProfileModel {
  final NameModel name;
  final NumberModel number;
  final LocationModel? location;
  final String gender;
  final String email;
  final String birthdate;
  final String? picture;

  ProfileModel({
    required this.name,
    required this.number,
    required this.location,
    required this.gender,
    required this.email,
    required this.birthdate,
    required this.picture,
  });

  factory ProfileModel.fromJson(jsonData) {
    return ProfileModel(
      name: NameModel.fromJson(jsonData['name']),
      location: LocationModel.fromJson(jsonData['location']),
      number: NumberModel.fromJson(jsonData['phone_number']),
      gender: jsonData['gender'],
      email: jsonData['email'],
      picture: jsonData['profile_pic'],
      birthdate: jsonData['date_of_birth'],
    );
  }
}

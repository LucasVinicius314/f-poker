import 'package:f_poker/utils/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class User {
  final int id;
  final String email;
  final String username;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
  });

  static Future<User> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    return User.fromJson(await Api.post(
      'user/login',
      {
        'email': email,
        'password': password,
      },
      context: context,
    ));
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// @JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
// class LoginResponse implements BaseResponse {
//   final String? message;
//   final User? data;

//   LoginResponse({
//     required this.message,
//     required this.data,
//   });

//   factory LoginResponse.fromJson(Map<String, dynamic> json) =>
//       _$LoginResponseFromJson(json);

//   Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
// }

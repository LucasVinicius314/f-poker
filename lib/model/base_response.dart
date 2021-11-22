import 'package:f_poker/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none, explicitToJson: true)
class BaseResponse {
  final String? message;

  BaseResponse({required this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}

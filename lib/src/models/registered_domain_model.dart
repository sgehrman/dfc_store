import 'package:json_annotation/json_annotation.dart';

part 'registered_domain_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class RegisteredDomainModel {
  const RegisteredDomainModel({
    this.id = '',
    this.licKeyId = '',
    this.licKey = '',
    this.registeredDomain = '',
    this.itemReference = '',
  });

  factory RegisteredDomainModel.fromJson(Map<String, dynamic> json) =>
      _$RegisteredDomainModelFromJson(json);

  final String id;
  final String licKeyId;
  final String licKey;
  final String registeredDomain;
  final String itemReference;

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => _$RegisteredDomainModelToJson(this);
}

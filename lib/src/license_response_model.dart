import 'package:json_annotation/json_annotation.dart';

part 'license_response_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class LicenseResponseModel {
  const LicenseResponseModel({
    required this.result,
    required this.message,
    this.errorCode = 0,
  });

  factory LicenseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LicenseResponseModelFromJson(json);

  factory LicenseResponseModel.error() {
    return const LicenseResponseModel(
      message: 'Error',
      result: 'error',
      errorCode: 69,
    );
  }

  final String result; // 'success', 'error'
  final int errorCode;
  final String
      message; // 'License key details retrieved', 'Invalid license key'

  bool get isSuccess => result == 'success';
  bool get isError => result == 'error';

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => _$LicenseResponseModelToJson(this);
}

import 'package:freezed_annotation/freezed_annotation.dart';


part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required String firstName,
    required String lastName,
    required String address,
    required String city,
    required String mobileNumber,
    String? additionalInformation,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

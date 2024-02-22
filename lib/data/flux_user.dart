import 'package:equatable/equatable.dart';

abstract class FluxUser extends Equatable implements FluxUserImpl {
  U deepCopy<U extends FluxUser>();

  const FluxUser();

  bool hasPhoto() => photo != null && photo!.isNotEmpty;

  @override
  String toString() {
    return 'FluxUser(id: $id,\n email: $email,\n password: $password,\n mobile: $mobile,\n photo: $photo,\n otp: $otp,\n active: $active)';
  }
}

abstract class FluxUserImpl {
  Object? get id;
  String? get email;
  set email(String? email);
  String? get password;
  set password(String? password);
  String? get mobile;
  set mobile(String? mobile);
  String? get photo;
  set photo(String? photo);
  bool get otp;
  set otp(bool otp);
  bool get active;
  set active(bool active);
}

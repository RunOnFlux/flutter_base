import 'package:equatable/equatable.dart';

class FluxUser extends Equatable {
  const FluxUser({
    required this.active,
    required this.email,
    required this.mobile,
    required this.otp,
    required this.photo,
    required this.uid,
    this.password,
  });

  bool hasPhoto() => photo != null && photo!.isNotEmpty;

  @override
  String toString() {
    return 'FluxUser(email: $email,\n mobile: $mobile,\n photo: $photo,\n otp: $otp,\n active: $active, \n UID: $uid)';
  }

  @override
  List<Object?> get props => [
        email,
        mobile,
        photo,
        otp,
        active,
        uid,
        password,
      ];

  final bool active;
  final String? email;
  final String? mobile;
  final bool otp;
  final String uid;
  final String? photo;
  final String? password;

  FluxUser copyWith({required String? password}) {
    return FluxUser(
      active: active,
      email: email,
      mobile: mobile,
      otp: otp,
      uid: uid,
      photo: photo,
      password: password ?? this.password,
    );
  }
}

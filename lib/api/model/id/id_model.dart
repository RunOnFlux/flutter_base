import 'package:flutter_base/api/api.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'id_model.g.dart';

@JsonSerializable()
class Session {
  String zelid;
  String loginPhrase;
  String createdAt;
  String expireAt;

  Session({
    required this.zelid,
    required this.loginPhrase,
    required this.createdAt,
    required this.expireAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable()
class CheckPrivilege {
  @JsonKey(name: 'message', fromJson: ApiUtils.stringToPrivilegeLevel)
  PrivilegeLevel? privilege;

  CheckPrivilege({
    required this.privilege,
  });

  factory CheckPrivilege.fromJson(Map<String, dynamic> json) => _$CheckPrivilegeFromJson(json);
  Map<String, dynamic> toJson() => _$CheckPrivilegeToJson(this);
}

@JsonSerializable()
class LoginPhrase {
  @JsonKey(name: 'data')
  String loginPhrase;

  LoginPhrase({
    required this.loginPhrase,
  });

  factory LoginPhrase.fromJson(Map<String, dynamic> json) => _$LoginPhraseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginPhraseToJson(this);
}

@JsonSerializable()
class LogoutCurrentSession {
  @JsonKey(name: 'data')
  Map<String, dynamic> data;
  String get message => data['message'];

  LogoutCurrentSession({
    required this.data,
  });

  factory LogoutCurrentSession.fromJson(Map<String, dynamic> json) => _$LogoutCurrentSessionFromJson(json);
  Map<String, dynamic> toJson() => _$LogoutCurrentSessionToJson(this);
}

@JsonSerializable()
class VerifyLogin {
  @JsonKey(name: 'data')
  Map<String, dynamic> data;
  String get message => data['message'];
  String get zelid => data['zelid'];
  String get loginPhrase => data['loginPhrase'];
  String get signature => data['signature'];
  String get privilege => data['privilage'];

  VerifyLogin({
    required this.data,
  });

  factory VerifyLogin.fromJson(Map<String, dynamic> json) => _$VerifyLoginFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyLoginToJson(this);
}

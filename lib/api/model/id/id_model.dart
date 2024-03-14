import 'package:flutter_base/api/api.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
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
class FluxLogin {
  @JsonKey(name: 'data')
  Map<String, dynamic> data;
  String get message => data['message'];
  String get zelid => data['zelid'];
  String get loginPhrase => data['loginPhrase'];
  String get signature => data['signature'];
  String get privilege => data['privilage'];
  set privilege(String p) {
    data['privilage'] = p;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  PrivilegeLevel privilegeLevel = PrivilegeLevel.none;

  FluxLogin({
    required this.data,
  });

  factory FluxLogin.fromJson(Map<String, dynamic> json) => _$FluxLoginFromJson(json);
  Map<String, dynamic> toJson() => _$FluxLoginToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    return other is FluxLogin &&
        other.message == message &&
        other.zelid == zelid &&
        other.loginPhrase == loginPhrase &&
        other.signature == signature &&
        other.privilege == privilege;
  }

  @override
  int get hashCode => Object.hash(
        message,
        zelid,
        loginPhrase,
        signature,
        privilege,
      );
}

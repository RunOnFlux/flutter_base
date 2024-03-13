// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      zelid: json['zelid'] as String,
      loginPhrase: json['loginPhrase'] as String,
      createdAt: json['createdAt'] as String,
      expireAt: json['expireAt'] as String,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'zelid': instance.zelid,
      'loginPhrase': instance.loginPhrase,
      'createdAt': instance.createdAt,
      'expireAt': instance.expireAt,
    };

CheckPrivilege _$CheckPrivilegeFromJson(Map<String, dynamic> json) => CheckPrivilege(
      privilege: $enumDecodeNullable(_$PrivilegeLevelEnumMap, json['message']),
    );

Map<String, dynamic> _$CheckPrivilegeToJson(CheckPrivilege instance) => <String, dynamic>{
      'message': _$PrivilegeLevelEnumMap[instance.privilege],
    };

const _$PrivilegeLevelEnumMap = {
  PrivilegeLevel.none: 'none',
  PrivilegeLevel.user: 'user',
  PrivilegeLevel.admin: 'admin',
  PrivilegeLevel.fluxteam: 'fluxteam',
};

LoginPhrase _$LoginPhraseFromJson(Map<String, dynamic> json) => LoginPhrase(
      loginPhrase: json['data'] as String,
    );

Map<String, dynamic> _$LoginPhraseToJson(LoginPhrase instance) => <String, dynamic>{
      'data': instance.loginPhrase,
    };

LogoutCurrentSession _$LogoutCurrentSessionFromJson(Map<String, dynamic> json) => LogoutCurrentSession(
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$LogoutCurrentSessionToJson(LogoutCurrentSession instance) => <String, dynamic>{
      'data': instance.data,
    };

FluxLogin _$FluxLoginFromJson(Map<String, dynamic> json) => FluxLogin(
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$FluxLoginToJson(FluxLogin instance) => <String, dynamic>{
      'data': instance.data,
    };

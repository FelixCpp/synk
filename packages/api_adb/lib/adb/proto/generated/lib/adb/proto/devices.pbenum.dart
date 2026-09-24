// This is a generated file - do not edit.
//
// Generated from lib/adb/proto/devices.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ConnectionState extends $pb.ProtobufEnum {
  static const ConnectionState ANY =
      ConnectionState._(0, _omitEnumNames ? '' : 'ANY');
  static const ConnectionState CONNECTING =
      ConnectionState._(1, _omitEnumNames ? '' : 'CONNECTING');
  static const ConnectionState AUTHORIZING =
      ConnectionState._(2, _omitEnumNames ? '' : 'AUTHORIZING');
  static const ConnectionState UNAUTHORIZED =
      ConnectionState._(3, _omitEnumNames ? '' : 'UNAUTHORIZED');
  static const ConnectionState NOPERMISSION =
      ConnectionState._(4, _omitEnumNames ? '' : 'NOPERMISSION');
  static const ConnectionState DETACHED =
      ConnectionState._(5, _omitEnumNames ? '' : 'DETACHED');
  static const ConnectionState OFFLINE =
      ConnectionState._(6, _omitEnumNames ? '' : 'OFFLINE');
  static const ConnectionState BOOTLOADER =
      ConnectionState._(7, _omitEnumNames ? '' : 'BOOTLOADER');
  static const ConnectionState DEVICE =
      ConnectionState._(8, _omitEnumNames ? '' : 'DEVICE');
  static const ConnectionState HOST =
      ConnectionState._(9, _omitEnumNames ? '' : 'HOST');
  static const ConnectionState RECOVERY =
      ConnectionState._(10, _omitEnumNames ? '' : 'RECOVERY');
  static const ConnectionState SIDELOAD =
      ConnectionState._(11, _omitEnumNames ? '' : 'SIDELOAD');
  static const ConnectionState RESCUE =
      ConnectionState._(12, _omitEnumNames ? '' : 'RESCUE');

  static const $core.List<ConnectionState> values = <ConnectionState>[
    ANY,
    CONNECTING,
    AUTHORIZING,
    UNAUTHORIZED,
    NOPERMISSION,
    DETACHED,
    OFFLINE,
    BOOTLOADER,
    DEVICE,
    HOST,
    RECOVERY,
    SIDELOAD,
    RESCUE,
  ];

  static final $core.List<ConnectionState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 12);
  static ConnectionState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConnectionState._(super.value, super.name);
}

class ConnectionType extends $pb.ProtobufEnum {
  static const ConnectionType UNKNOWN =
      ConnectionType._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const ConnectionType USB =
      ConnectionType._(1, _omitEnumNames ? '' : 'USB');
  static const ConnectionType SOCKET =
      ConnectionType._(2, _omitEnumNames ? '' : 'SOCKET');

  static const $core.List<ConnectionType> values = <ConnectionType>[
    UNKNOWN,
    USB,
    SOCKET,
  ];

  static final $core.List<ConnectionType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ConnectionType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConnectionType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

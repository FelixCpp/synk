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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'devices.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'devices.pbenum.dart';

class Device extends $pb.GeneratedMessage {
  factory Device({
    $core.String? serial,
    ConnectionState? state,
    $core.String? busAddress,
    $core.String? product,
    $core.String? model,
    $core.String? device,
    ConnectionType? connectionType,
    $fixnum.Int64? negotiatedSpeed,
    $fixnum.Int64? maxSpeed,
    $fixnum.Int64? transportId,
  }) {
    final result = Device._();
    if (serial != null) result.serial = serial;
    if (state != null) result.state = state;
    if (busAddress != null) result.busAddress = busAddress;
    if (product != null) result.product = product;
    if (model != null) result.model = model;
    if (device != null) result.device = device;
    if (connectionType != null) result.connectionType = connectionType;
    if (negotiatedSpeed != null) result.negotiatedSpeed = negotiatedSpeed;
    if (maxSpeed != null) result.maxSpeed = maxSpeed;
    if (transportId != null) result.transportId = transportId;
    return result;
  }

  Device._();

  factory Device.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Device()..mergeFromBuffer(data, registry);
  factory Device.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Device()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Device',
      createEmptyInstance: Device.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'serial')
    ..aE<ConnectionState>(2, _omitFieldNames ? '' : 'state',
        enumValues: ConnectionState.values)
    ..aOS(3, _omitFieldNames ? '' : 'busAddress')
    ..aOS(4, _omitFieldNames ? '' : 'product')
    ..aOS(5, _omitFieldNames ? '' : 'model')
    ..aOS(6, _omitFieldNames ? '' : 'device')
    ..aE<ConnectionType>(7, _omitFieldNames ? '' : 'connectionType',
        enumValues: ConnectionType.values)
    ..aInt64(8, _omitFieldNames ? '' : 'negotiatedSpeed')
    ..aInt64(9, _omitFieldNames ? '' : 'maxSpeed')
    ..aInt64(10, _omitFieldNames ? '' : 'transportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device copyWith(void Function(Device) updates) =>
      super.copyWith((message) => updates(message as Device)) as Device;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Device() / Device.new instead')
  static Device create() => Device._();
  static $pb.GeneratedMessage $_createMessage() => Device._();
  @$core.override
  Device createEmptyInstance() => Device._();
  @$core.pragma('dart2js:noInline')
  static Device getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Device>(Device.$_createMessage);
  static Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serial => $_getSZ(0);
  @$pb.TagNumber(1)
  set serial($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSerial() => $_has(0);
  @$pb.TagNumber(1)
  void clearSerial() => $_clearField(1);

  @$pb.TagNumber(2)
  ConnectionState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(ConnectionState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get busAddress => $_getSZ(2);
  @$pb.TagNumber(3)
  set busAddress($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBusAddress() => $_has(2);
  @$pb.TagNumber(3)
  void clearBusAddress() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get product => $_getSZ(3);
  @$pb.TagNumber(4)
  set product($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProduct() => $_has(3);
  @$pb.TagNumber(4)
  void clearProduct() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get model => $_getSZ(4);
  @$pb.TagNumber(5)
  set model($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModel() => $_has(4);
  @$pb.TagNumber(5)
  void clearModel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get device => $_getSZ(5);
  @$pb.TagNumber(6)
  set device($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDevice() => $_has(5);
  @$pb.TagNumber(6)
  void clearDevice() => $_clearField(6);

  @$pb.TagNumber(7)
  ConnectionType get connectionType => $_getN(6);
  @$pb.TagNumber(7)
  set connectionType(ConnectionType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasConnectionType() => $_has(6);
  @$pb.TagNumber(7)
  void clearConnectionType() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get negotiatedSpeed => $_getI64(7);
  @$pb.TagNumber(8)
  set negotiatedSpeed($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNegotiatedSpeed() => $_has(7);
  @$pb.TagNumber(8)
  void clearNegotiatedSpeed() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get maxSpeed => $_getI64(8);
  @$pb.TagNumber(9)
  set maxSpeed($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMaxSpeed() => $_has(8);
  @$pb.TagNumber(9)
  void clearMaxSpeed() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get transportId => $_getI64(9);
  @$pb.TagNumber(10)
  set transportId($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTransportId() => $_has(9);
  @$pb.TagNumber(10)
  void clearTransportId() => $_clearField(10);
}

class Devices extends $pb.GeneratedMessage {
  factory Devices({
    $core.Iterable<Device>? device,
  }) {
    final result = Devices._();
    if (device != null) result.device.addAll(device);
    return result;
  }

  Devices._();

  factory Devices.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Devices()..mergeFromBuffer(data, registry);
  factory Devices.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Devices()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Devices',
      createEmptyInstance: Devices.$_createMessage)
    ..pPM<Device>(1, _omitFieldNames ? '' : 'device',
        subBuilder: Device.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Devices clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Devices copyWith(void Function(Devices) updates) =>
      super.copyWith((message) => updates(message as Devices)) as Devices;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Devices() / Devices.new instead')
  static Devices create() => Devices._();
  static $pb.GeneratedMessage $_createMessage() => Devices._();
  @$core.override
  Devices createEmptyInstance() => Devices._();
  @$core.pragma('dart2js:noInline')
  static Devices getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Devices>(Devices.$_createMessage);
  static Devices? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Device> get device => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

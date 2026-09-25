// This is a generated file - do not edit.
//
// Generated from device_agent.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetInfoRequest extends $pb.GeneratedMessage {
  factory GetInfoRequest() => GetInfoRequest._();

  GetInfoRequest._();

  factory GetInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInfoRequest()..mergeFromBuffer(data, registry);
  factory GetInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInfoRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: GetInfoRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInfoRequest copyWith(void Function(GetInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetInfoRequest))
          as GetInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetInfoRequest() / GetInfoRequest.new instead')
  static GetInfoRequest create() => GetInfoRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetInfoRequest._();
  @$core.override
  GetInfoRequest createEmptyInstance() => GetInfoRequest._();
  @$core.pragma('dart2js:noInline')
  static GetInfoRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetInfoRequest>(
          GetInfoRequest.$_createMessage);
  static GetInfoRequest? _defaultInstance;
}

class GetInfoResponse extends $pb.GeneratedMessage {
  factory GetInfoResponse({
    $core.String? model,
    $core.String? manufacturer,
    $core.String? androidVersion,
    $core.int? sdkVersion,
  }) {
    final result = GetInfoResponse._();
    if (model != null) result.model = model;
    if (manufacturer != null) result.manufacturer = manufacturer;
    if (androidVersion != null) result.androidVersion = androidVersion;
    if (sdkVersion != null) result.sdkVersion = sdkVersion;
    return result;
  }

  GetInfoResponse._();

  factory GetInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInfoResponse()..mergeFromBuffer(data, registry);
  factory GetInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInfoResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: GetInfoResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..aOS(2, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(3, _omitFieldNames ? '' : 'androidVersion')
    ..aI(4, _omitFieldNames ? '' : 'sdkVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInfoResponse copyWith(void Function(GetInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetInfoResponse))
          as GetInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetInfoResponse() / GetInfoResponse.new instead')
  static GetInfoResponse create() => GetInfoResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetInfoResponse._();
  @$core.override
  GetInfoResponse createEmptyInstance() => GetInfoResponse._();
  @$core.pragma('dart2js:noInline')
  static GetInfoResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetInfoResponse>(
          GetInfoResponse.$_createMessage);
  static GetInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get manufacturer => $_getSZ(1);
  @$pb.TagNumber(2)
  set manufacturer($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasManufacturer() => $_has(1);
  @$pb.TagNumber(2)
  void clearManufacturer() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get androidVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set androidVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAndroidVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearAndroidVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get sdkVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set sdkVersion($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSdkVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearSdkVersion() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

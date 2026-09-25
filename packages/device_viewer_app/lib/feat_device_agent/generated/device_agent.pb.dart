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

class CaptureScreenshotRequest extends $pb.GeneratedMessage {
  factory CaptureScreenshotRequest() => CaptureScreenshotRequest._();

  CaptureScreenshotRequest._();

  factory CaptureScreenshotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CaptureScreenshotRequest()..mergeFromBuffer(data, registry);
  factory CaptureScreenshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CaptureScreenshotRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CaptureScreenshotRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: CaptureScreenshotRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaptureScreenshotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaptureScreenshotRequest copyWith(
          void Function(CaptureScreenshotRequest) updates) =>
      super.copyWith((message) => updates(message as CaptureScreenshotRequest))
          as CaptureScreenshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CaptureScreenshotRequest() / CaptureScreenshotRequest.new instead')
  static CaptureScreenshotRequest create() => CaptureScreenshotRequest._();
  static $pb.GeneratedMessage $_createMessage() => CaptureScreenshotRequest._();
  @$core.override
  CaptureScreenshotRequest createEmptyInstance() =>
      CaptureScreenshotRequest._();
  @$core.pragma('dart2js:noInline')
  static CaptureScreenshotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CaptureScreenshotRequest>(
          CaptureScreenshotRequest.$_createMessage);
  static CaptureScreenshotRequest? _defaultInstance;
}

class CaptureScreenshotResponse extends $pb.GeneratedMessage {
  factory CaptureScreenshotResponse({
    $core.List<$core.int>? png,
  }) {
    final result = CaptureScreenshotResponse._();
    if (png != null) result.png = png;
    return result;
  }

  CaptureScreenshotResponse._();

  factory CaptureScreenshotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CaptureScreenshotResponse()..mergeFromBuffer(data, registry);
  factory CaptureScreenshotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CaptureScreenshotResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CaptureScreenshotResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: CaptureScreenshotResponse.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'png', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaptureScreenshotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CaptureScreenshotResponse copyWith(
          void Function(CaptureScreenshotResponse) updates) =>
      super.copyWith((message) => updates(message as CaptureScreenshotResponse))
          as CaptureScreenshotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CaptureScreenshotResponse() / CaptureScreenshotResponse.new instead')
  static CaptureScreenshotResponse create() => CaptureScreenshotResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CaptureScreenshotResponse._();
  @$core.override
  CaptureScreenshotResponse createEmptyInstance() =>
      CaptureScreenshotResponse._();
  @$core.pragma('dart2js:noInline')
  static CaptureScreenshotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CaptureScreenshotResponse>(
          CaptureScreenshotResponse.$_createMessage);
  static CaptureScreenshotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get png => $_getN(0);
  @$pb.TagNumber(1)
  set png($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPng() => $_has(0);
  @$pb.TagNumber(1)
  void clearPng() => $_clearField(1);
}

/// Starts mirroring the device screen. The agent opens a second, dedicated
/// TCP socket carrying a raw H.264 Annex-B elementary stream (no framing, no
/// protobuf envelope per frame) and reports the port to connect to here.
class StartScreenStreamRequest extends $pb.GeneratedMessage {
  factory StartScreenStreamRequest() => StartScreenStreamRequest._();

  StartScreenStreamRequest._();

  factory StartScreenStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartScreenStreamRequest()..mergeFromBuffer(data, registry);
  factory StartScreenStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartScreenStreamRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartScreenStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: StartScreenStreamRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartScreenStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartScreenStreamRequest copyWith(
          void Function(StartScreenStreamRequest) updates) =>
      super.copyWith((message) => updates(message as StartScreenStreamRequest))
          as StartScreenStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StartScreenStreamRequest() / StartScreenStreamRequest.new instead')
  static StartScreenStreamRequest create() => StartScreenStreamRequest._();
  static $pb.GeneratedMessage $_createMessage() => StartScreenStreamRequest._();
  @$core.override
  StartScreenStreamRequest createEmptyInstance() =>
      StartScreenStreamRequest._();
  @$core.pragma('dart2js:noInline')
  static StartScreenStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartScreenStreamRequest>(
          StartScreenStreamRequest.$_createMessage);
  static StartScreenStreamRequest? _defaultInstance;
}

class StartScreenStreamResponse extends $pb.GeneratedMessage {
  factory StartScreenStreamResponse({
    $core.int? videoPort,
  }) {
    final result = StartScreenStreamResponse._();
    if (videoPort != null) result.videoPort = videoPort;
    return result;
  }

  StartScreenStreamResponse._();

  factory StartScreenStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartScreenStreamResponse()..mergeFromBuffer(data, registry);
  factory StartScreenStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StartScreenStreamResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartScreenStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: StartScreenStreamResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'videoPort')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartScreenStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartScreenStreamResponse copyWith(
          void Function(StartScreenStreamResponse) updates) =>
      super.copyWith((message) => updates(message as StartScreenStreamResponse))
          as StartScreenStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StartScreenStreamResponse() / StartScreenStreamResponse.new instead')
  static StartScreenStreamResponse create() => StartScreenStreamResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StartScreenStreamResponse._();
  @$core.override
  StartScreenStreamResponse createEmptyInstance() =>
      StartScreenStreamResponse._();
  @$core.pragma('dart2js:noInline')
  static StartScreenStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartScreenStreamResponse>(
          StartScreenStreamResponse.$_createMessage);
  static StartScreenStreamResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get videoPort => $_getIZ(0);
  @$pb.TagNumber(1)
  set videoPort($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVideoPort() => $_has(0);
  @$pb.TagNumber(1)
  void clearVideoPort() => $_clearField(1);
}

/// Stops the screen mirror started by StartScreenStreamRequest and tears down
/// the video socket on the agent side.
class StopScreenStreamRequest extends $pb.GeneratedMessage {
  factory StopScreenStreamRequest() => StopScreenStreamRequest._();

  StopScreenStreamRequest._();

  factory StopScreenStreamRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopScreenStreamRequest()..mergeFromBuffer(data, registry);
  factory StopScreenStreamRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopScreenStreamRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopScreenStreamRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: StopScreenStreamRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopScreenStreamRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopScreenStreamRequest copyWith(
          void Function(StopScreenStreamRequest) updates) =>
      super.copyWith((message) => updates(message as StopScreenStreamRequest))
          as StopScreenStreamRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StopScreenStreamRequest() / StopScreenStreamRequest.new instead')
  static StopScreenStreamRequest create() => StopScreenStreamRequest._();
  static $pb.GeneratedMessage $_createMessage() => StopScreenStreamRequest._();
  @$core.override
  StopScreenStreamRequest createEmptyInstance() => StopScreenStreamRequest._();
  @$core.pragma('dart2js:noInline')
  static StopScreenStreamRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopScreenStreamRequest>(
          StopScreenStreamRequest.$_createMessage);
  static StopScreenStreamRequest? _defaultInstance;
}

class StopScreenStreamResponse extends $pb.GeneratedMessage {
  factory StopScreenStreamResponse() => StopScreenStreamResponse._();

  StopScreenStreamResponse._();

  factory StopScreenStreamResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopScreenStreamResponse()..mergeFromBuffer(data, registry);
  factory StopScreenStreamResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StopScreenStreamResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StopScreenStreamResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: StopScreenStreamResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopScreenStreamResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StopScreenStreamResponse copyWith(
          void Function(StopScreenStreamResponse) updates) =>
      super.copyWith((message) => updates(message as StopScreenStreamResponse))
          as StopScreenStreamResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StopScreenStreamResponse() / StopScreenStreamResponse.new instead')
  static StopScreenStreamResponse create() => StopScreenStreamResponse._();
  static $pb.GeneratedMessage $_createMessage() => StopScreenStreamResponse._();
  @$core.override
  StopScreenStreamResponse createEmptyInstance() =>
      StopScreenStreamResponse._();
  @$core.pragma('dart2js:noInline')
  static StopScreenStreamResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StopScreenStreamResponse>(
          StopScreenStreamResponse.$_createMessage);
  static StopScreenStreamResponse? _defaultInstance;
}

class AgentError extends $pb.GeneratedMessage {
  factory AgentError({
    $core.String? message,
  }) {
    final result = AgentError._();
    if (message != null) result.message = message;
    return result;
  }

  AgentError._();

  factory AgentError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentError()..mergeFromBuffer(data, registry);
  factory AgentError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentError()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: AgentError.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentError copyWith(void Function(AgentError) updates) =>
      super.copyWith((message) => updates(message as AgentError)) as AgentError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentError() / AgentError.new instead')
  static AgentError create() => AgentError._();
  static $pb.GeneratedMessage $_createMessage() => AgentError._();
  @$core.override
  AgentError createEmptyInstance() => AgentError._();
  @$core.pragma('dart2js:noInline')
  static AgentError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentError>(AgentError.$_createMessage);
  static AgentError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

enum AgentRequest_Payload {
  getInfo,
  captureScreenshot,
  startScreenStream,
  stopScreenStream,
  notSet
}

class AgentRequest extends $pb.GeneratedMessage {
  factory AgentRequest({
    GetInfoRequest? getInfo,
    CaptureScreenshotRequest? captureScreenshot,
    StartScreenStreamRequest? startScreenStream,
    StopScreenStreamRequest? stopScreenStream,
  }) {
    final result = AgentRequest._();
    if (getInfo != null) result.getInfo = getInfo;
    if (captureScreenshot != null) result.captureScreenshot = captureScreenshot;
    if (startScreenStream != null) result.startScreenStream = startScreenStream;
    if (stopScreenStream != null) result.stopScreenStream = stopScreenStream;
    return result;
  }

  AgentRequest._();

  factory AgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentRequest()..mergeFromBuffer(data, registry);
  factory AgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentRequest()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AgentRequest_Payload>
      _AgentRequest_PayloadByTag = {
    1: AgentRequest_Payload.getInfo,
    2: AgentRequest_Payload.captureScreenshot,
    3: AgentRequest_Payload.startScreenStream,
    4: AgentRequest_Payload.stopScreenStream,
    0: AgentRequest_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: AgentRequest.$_createMessage)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<GetInfoRequest>(1, _omitFieldNames ? '' : 'getInfo',
        subBuilder: GetInfoRequest.$_createMessage)
    ..aOM<CaptureScreenshotRequest>(
        2, _omitFieldNames ? '' : 'captureScreenshot',
        subBuilder: CaptureScreenshotRequest.$_createMessage)
    ..aOM<StartScreenStreamRequest>(
        3, _omitFieldNames ? '' : 'startScreenStream',
        subBuilder: StartScreenStreamRequest.$_createMessage)
    ..aOM<StopScreenStreamRequest>(4, _omitFieldNames ? '' : 'stopScreenStream',
        subBuilder: StopScreenStreamRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentRequest copyWith(void Function(AgentRequest) updates) =>
      super.copyWith((message) => updates(message as AgentRequest))
          as AgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentRequest() / AgentRequest.new instead')
  static AgentRequest create() => AgentRequest._();
  static $pb.GeneratedMessage $_createMessage() => AgentRequest._();
  @$core.override
  AgentRequest createEmptyInstance() => AgentRequest._();
  @$core.pragma('dart2js:noInline')
  static AgentRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentRequest>(
          AgentRequest.$_createMessage);
  static AgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  AgentRequest_Payload whichPayload() =>
      _AgentRequest_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  GetInfoRequest get getInfo => $_getN(0);
  @$pb.TagNumber(1)
  set getInfo(GetInfoRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGetInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearGetInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  GetInfoRequest ensureGetInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  CaptureScreenshotRequest get captureScreenshot => $_getN(1);
  @$pb.TagNumber(2)
  set captureScreenshot(CaptureScreenshotRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCaptureScreenshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaptureScreenshot() => $_clearField(2);
  @$pb.TagNumber(2)
  CaptureScreenshotRequest ensureCaptureScreenshot() => $_ensure(1);

  @$pb.TagNumber(3)
  StartScreenStreamRequest get startScreenStream => $_getN(2);
  @$pb.TagNumber(3)
  set startScreenStream(StartScreenStreamRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartScreenStream() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartScreenStream() => $_clearField(3);
  @$pb.TagNumber(3)
  StartScreenStreamRequest ensureStartScreenStream() => $_ensure(2);

  @$pb.TagNumber(4)
  StopScreenStreamRequest get stopScreenStream => $_getN(3);
  @$pb.TagNumber(4)
  set stopScreenStream(StopScreenStreamRequest value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStopScreenStream() => $_has(3);
  @$pb.TagNumber(4)
  void clearStopScreenStream() => $_clearField(4);
  @$pb.TagNumber(4)
  StopScreenStreamRequest ensureStopScreenStream() => $_ensure(3);
}

enum AgentResponse_Payload {
  getInfo,
  captureScreenshot,
  error,
  startScreenStream,
  stopScreenStream,
  notSet
}

class AgentResponse extends $pb.GeneratedMessage {
  factory AgentResponse({
    GetInfoResponse? getInfo,
    CaptureScreenshotResponse? captureScreenshot,
    AgentError? error,
    StartScreenStreamResponse? startScreenStream,
    StopScreenStreamResponse? stopScreenStream,
  }) {
    final result = AgentResponse._();
    if (getInfo != null) result.getInfo = getInfo;
    if (captureScreenshot != null) result.captureScreenshot = captureScreenshot;
    if (error != null) result.error = error;
    if (startScreenStream != null) result.startScreenStream = startScreenStream;
    if (stopScreenStream != null) result.stopScreenStream = stopScreenStream;
    return result;
  }

  AgentResponse._();

  factory AgentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentResponse()..mergeFromBuffer(data, registry);
  factory AgentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentResponse()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, AgentResponse_Payload>
      _AgentResponse_PayloadByTag = {
    1: AgentResponse_Payload.getInfo,
    2: AgentResponse_Payload.captureScreenshot,
    3: AgentResponse_Payload.error,
    4: AgentResponse_Payload.startScreenStream,
    5: AgentResponse_Payload.stopScreenStream,
    0: AgentResponse_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'device_agent'),
      createEmptyInstance: AgentResponse.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<GetInfoResponse>(1, _omitFieldNames ? '' : 'getInfo',
        subBuilder: GetInfoResponse.$_createMessage)
    ..aOM<CaptureScreenshotResponse>(
        2, _omitFieldNames ? '' : 'captureScreenshot',
        subBuilder: CaptureScreenshotResponse.$_createMessage)
    ..aOM<AgentError>(3, _omitFieldNames ? '' : 'error',
        subBuilder: AgentError.$_createMessage)
    ..aOM<StartScreenStreamResponse>(
        4, _omitFieldNames ? '' : 'startScreenStream',
        subBuilder: StartScreenStreamResponse.$_createMessage)
    ..aOM<StopScreenStreamResponse>(
        5, _omitFieldNames ? '' : 'stopScreenStream',
        subBuilder: StopScreenStreamResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentResponse copyWith(void Function(AgentResponse) updates) =>
      super.copyWith((message) => updates(message as AgentResponse))
          as AgentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentResponse() / AgentResponse.new instead')
  static AgentResponse create() => AgentResponse._();
  static $pb.GeneratedMessage $_createMessage() => AgentResponse._();
  @$core.override
  AgentResponse createEmptyInstance() => AgentResponse._();
  @$core.pragma('dart2js:noInline')
  static AgentResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentResponse>(
          AgentResponse.$_createMessage);
  static AgentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  AgentResponse_Payload whichPayload() =>
      _AgentResponse_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  GetInfoResponse get getInfo => $_getN(0);
  @$pb.TagNumber(1)
  set getInfo(GetInfoResponse value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGetInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearGetInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  GetInfoResponse ensureGetInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  CaptureScreenshotResponse get captureScreenshot => $_getN(1);
  @$pb.TagNumber(2)
  set captureScreenshot(CaptureScreenshotResponse value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCaptureScreenshot() => $_has(1);
  @$pb.TagNumber(2)
  void clearCaptureScreenshot() => $_clearField(2);
  @$pb.TagNumber(2)
  CaptureScreenshotResponse ensureCaptureScreenshot() => $_ensure(1);

  @$pb.TagNumber(3)
  AgentError get error => $_getN(2);
  @$pb.TagNumber(3)
  set error(AgentError value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
  @$pb.TagNumber(3)
  AgentError ensureError() => $_ensure(2);

  @$pb.TagNumber(4)
  StartScreenStreamResponse get startScreenStream => $_getN(3);
  @$pb.TagNumber(4)
  set startScreenStream(StartScreenStreamResponse value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStartScreenStream() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartScreenStream() => $_clearField(4);
  @$pb.TagNumber(4)
  StartScreenStreamResponse ensureStartScreenStream() => $_ensure(3);

  @$pb.TagNumber(5)
  StopScreenStreamResponse get stopScreenStream => $_getN(4);
  @$pb.TagNumber(5)
  set stopScreenStream(StopScreenStreamResponse value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStopScreenStream() => $_has(4);
  @$pb.TagNumber(5)
  void clearStopScreenStream() => $_clearField(5);
  @$pb.TagNumber(5)
  StopScreenStreamResponse ensureStopScreenStream() => $_ensure(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

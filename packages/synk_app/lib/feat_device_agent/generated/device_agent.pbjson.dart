// This is a generated file - do not edit.
//
// Generated from device_agent.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getInfoRequestDescriptor instead')
const GetInfoRequest$json = {
  '1': 'GetInfoRequest',
};

/// Descriptor for `GetInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInfoRequestDescriptor =
    $convert.base64Decode('Cg5HZXRJbmZvUmVxdWVzdA==');

@$core.Deprecated('Use getInfoResponseDescriptor instead')
const GetInfoResponse$json = {
  '1': 'GetInfoResponse',
  '2': [
    {'1': 'model', '3': 1, '4': 1, '5': 9, '10': 'model'},
    {'1': 'manufacturer', '3': 2, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'android_version', '3': 3, '4': 1, '5': 9, '10': 'androidVersion'},
    {'1': 'sdk_version', '3': 4, '4': 1, '5': 5, '10': 'sdkVersion'},
  ],
};

/// Descriptor for `GetInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInfoResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRJbmZvUmVzcG9uc2USFAoFbW9kZWwYASABKAlSBW1vZGVsEiIKDG1hbnVmYWN0dXJlch'
    'gCIAEoCVIMbWFudWZhY3R1cmVyEicKD2FuZHJvaWRfdmVyc2lvbhgDIAEoCVIOYW5kcm9pZFZl'
    'cnNpb24SHwoLc2RrX3ZlcnNpb24YBCABKAVSCnNka1ZlcnNpb24=');

@$core.Deprecated('Use captureScreenshotRequestDescriptor instead')
const CaptureScreenshotRequest$json = {
  '1': 'CaptureScreenshotRequest',
};

/// Descriptor for `CaptureScreenshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List captureScreenshotRequestDescriptor =
    $convert.base64Decode('ChhDYXB0dXJlU2NyZWVuc2hvdFJlcXVlc3Q=');

@$core.Deprecated('Use captureScreenshotResponseDescriptor instead')
const CaptureScreenshotResponse$json = {
  '1': 'CaptureScreenshotResponse',
  '2': [
    {'1': 'png', '3': 1, '4': 1, '5': 12, '10': 'png'},
  ],
};

/// Descriptor for `CaptureScreenshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List captureScreenshotResponseDescriptor =
    $convert.base64Decode(
        'ChlDYXB0dXJlU2NyZWVuc2hvdFJlc3BvbnNlEhAKA3BuZxgBIAEoDFIDcG5n');

@$core.Deprecated('Use agentErrorDescriptor instead')
const AgentError$json = {
  '1': 'AgentError',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AgentError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentErrorDescriptor = $convert
    .base64Decode('CgpBZ2VudEVycm9yEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use agentRequestDescriptor instead')
const AgentRequest$json = {
  '1': 'AgentRequest',
  '2': [
    {
      '1': 'get_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.device_agent.GetInfoRequest',
      '9': 0,
      '10': 'getInfo'
    },
    {
      '1': 'capture_screenshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.device_agent.CaptureScreenshotRequest',
      '9': 0,
      '10': 'captureScreenshot'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `AgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentRequestDescriptor = $convert.base64Decode(
    'CgxBZ2VudFJlcXVlc3QSOQoIZ2V0X2luZm8YASABKAsyHC5kZXZpY2VfYWdlbnQuR2V0SW5mb1'
    'JlcXVlc3RIAFIHZ2V0SW5mbxJXChJjYXB0dXJlX3NjcmVlbnNob3QYAiABKAsyJi5kZXZpY2Vf'
    'YWdlbnQuQ2FwdHVyZVNjcmVlbnNob3RSZXF1ZXN0SABSEWNhcHR1cmVTY3JlZW5zaG90QgkKB3'
    'BheWxvYWQ=');

@$core.Deprecated('Use agentResponseDescriptor instead')
const AgentResponse$json = {
  '1': 'AgentResponse',
  '2': [
    {
      '1': 'get_info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.device_agent.GetInfoResponse',
      '9': 0,
      '10': 'getInfo'
    },
    {
      '1': 'capture_screenshot',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.device_agent.CaptureScreenshotResponse',
      '9': 0,
      '10': 'captureScreenshot'
    },
    {
      '1': 'error',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.device_agent.AgentError',
      '9': 0,
      '10': 'error'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `AgentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentResponseDescriptor = $convert.base64Decode(
    'Cg1BZ2VudFJlc3BvbnNlEjoKCGdldF9pbmZvGAEgASgLMh0uZGV2aWNlX2FnZW50LkdldEluZm'
    '9SZXNwb25zZUgAUgdnZXRJbmZvElgKEmNhcHR1cmVfc2NyZWVuc2hvdBgCIAEoCzInLmRldmlj'
    'ZV9hZ2VudC5DYXB0dXJlU2NyZWVuc2hvdFJlc3BvbnNlSABSEWNhcHR1cmVTY3JlZW5zaG90Ej'
    'AKBWVycm9yGAMgASgLMhguZGV2aWNlX2FnZW50LkFnZW50RXJyb3JIAFIFZXJyb3JCCQoHcGF5'
    'bG9hZA==');

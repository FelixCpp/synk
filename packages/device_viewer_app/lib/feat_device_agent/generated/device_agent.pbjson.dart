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

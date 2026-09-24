// This is a generated file - do not edit.
//
// Generated from lib/adb/proto/devices.proto.

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

@$core.Deprecated('Use connectionStateDescriptor instead')
const ConnectionState$json = {
  '1': 'ConnectionState',
  '2': [
    {'1': 'ANY', '2': 0},
    {'1': 'CONNECTING', '2': 1},
    {'1': 'AUTHORIZING', '2': 2},
    {'1': 'UNAUTHORIZED', '2': 3},
    {'1': 'NOPERMISSION', '2': 4},
    {'1': 'DETACHED', '2': 5},
    {'1': 'OFFLINE', '2': 6},
    {'1': 'BOOTLOADER', '2': 7},
    {'1': 'DEVICE', '2': 8},
    {'1': 'HOST', '2': 9},
    {'1': 'RECOVERY', '2': 10},
    {'1': 'SIDELOAD', '2': 11},
    {'1': 'RESCUE', '2': 12},
  ],
};

/// Descriptor for `ConnectionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionStateDescriptor = $convert.base64Decode(
    'Cg9Db25uZWN0aW9uU3RhdGUSBwoDQU5ZEAASDgoKQ09OTkVDVElORxABEg8KC0FVVEhPUklaSU'
    '5HEAISEAoMVU5BVVRIT1JJWkVEEAMSEAoMTk9QRVJNSVNTSU9OEAQSDAoIREVUQUNIRUQQBRIL'
    'CgdPRkZMSU5FEAYSDgoKQk9PVExPQURFUhAHEgoKBkRFVklDRRAIEggKBEhPU1QQCRIMCghSRU'
    'NPVkVSWRAKEgwKCFNJREVMT0FEEAsSCgoGUkVTQ1VFEAw=');

@$core.Deprecated('Use connectionTypeDescriptor instead')
const ConnectionType$json = {
  '1': 'ConnectionType',
  '2': [
    {'1': 'UNKNOWN', '2': 0},
    {'1': 'USB', '2': 1},
    {'1': 'SOCKET', '2': 2},
  ],
};

/// Descriptor for `ConnectionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List connectionTypeDescriptor = $convert.base64Decode(
    'Cg5Db25uZWN0aW9uVHlwZRILCgdVTktOT1dOEAASBwoDVVNCEAESCgoGU09DS0VUEAI=');

@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = {
  '1': 'Device',
  '2': [
    {'1': 'serial', '3': 1, '4': 1, '5': 9, '10': 'serial'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.ConnectionState',
      '10': 'state'
    },
    {'1': 'bus_address', '3': 3, '4': 1, '5': 9, '10': 'busAddress'},
    {'1': 'product', '3': 4, '4': 1, '5': 9, '10': 'product'},
    {'1': 'model', '3': 5, '4': 1, '5': 9, '10': 'model'},
    {'1': 'device', '3': 6, '4': 1, '5': 9, '10': 'device'},
    {
      '1': 'connection_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.ConnectionType',
      '10': 'connectionType'
    },
    {'1': 'negotiated_speed', '3': 8, '4': 1, '5': 3, '10': 'negotiatedSpeed'},
    {'1': 'max_speed', '3': 9, '4': 1, '5': 3, '10': 'maxSpeed'},
    {'1': 'transport_id', '3': 10, '4': 1, '5': 3, '10': 'transportId'},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode(
    'CgZEZXZpY2USFgoGc2VyaWFsGAEgASgJUgZzZXJpYWwSJgoFc3RhdGUYAiABKA4yEC5Db25uZW'
    'N0aW9uU3RhdGVSBXN0YXRlEh8KC2J1c19hZGRyZXNzGAMgASgJUgpidXNBZGRyZXNzEhgKB3By'
    'b2R1Y3QYBCABKAlSB3Byb2R1Y3QSFAoFbW9kZWwYBSABKAlSBW1vZGVsEhYKBmRldmljZRgGIA'
    'EoCVIGZGV2aWNlEjgKD2Nvbm5lY3Rpb25fdHlwZRgHIAEoDjIPLkNvbm5lY3Rpb25UeXBlUg5j'
    'b25uZWN0aW9uVHlwZRIpChBuZWdvdGlhdGVkX3NwZWVkGAggASgDUg9uZWdvdGlhdGVkU3BlZW'
    'QSGwoJbWF4X3NwZWVkGAkgASgDUghtYXhTcGVlZBIhCgx0cmFuc3BvcnRfaWQYCiABKANSC3Ry'
    'YW5zcG9ydElk');

@$core.Deprecated('Use devicesDescriptor instead')
const Devices$json = {
  '1': 'Devices',
  '2': [
    {'1': 'device', '3': 1, '4': 3, '5': 11, '6': '.Device', '10': 'device'},
  ],
};

/// Descriptor for `Devices`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List devicesDescriptor = $convert
    .base64Decode('CgdEZXZpY2VzEh8KBmRldmljZRgBIAMoCzIHLkRldmljZVIGZGV2aWNl');

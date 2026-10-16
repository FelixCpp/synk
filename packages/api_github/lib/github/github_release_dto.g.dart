// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_release_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GitHubReleaseDto _$GitHubReleaseDtoFromJson(Map<String, dynamic> json) =>
    _GitHubReleaseDto(
      tagName: json['tag_name'] as String,
      htmlUrl: Uri.parse(json['html_url'] as String),
      assets: (json['assets'] as List<dynamic>)
          .map((e) => GitHubAssetDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

_GitHubAssetDto _$GitHubAssetDtoFromJson(Map<String, dynamic> json) =>
    _GitHubAssetDto(
      name: json['name'] as String,
      downloadUrl: Uri.parse(json['browser_download_url'] as String),
    );

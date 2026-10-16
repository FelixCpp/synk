import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_release_dto.freezed.dart';
part 'github_release_dto.g.dart';

@Freezed(toJson: false)
sealed class GitHubReleaseDto with _$GitHubReleaseDto {
  const factory GitHubReleaseDto({
    @JsonKey(name: 'tag_name') required String tagName,
    @JsonKey(name: 'html_url', fromJson: Uri.parse) required Uri htmlUrl,
    @JsonKey(name: 'assets') required List<GitHubAssetDto> assets,
  }) = _GitHubReleaseDto;

  factory GitHubReleaseDto.fromJson(Map<String, dynamic> json) =>
      _$GitHubReleaseDtoFromJson(json);
}

@Freezed(toJson: false)
sealed class GitHubAssetDto with _$GitHubAssetDto {
  const factory GitHubAssetDto({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'browser_download_url', fromJson: Uri.parse)
    required Uri downloadUrl,
  }) = _GitHubAssetDto;

  factory GitHubAssetDto.fromJson(Map<String, dynamic> json) =>
      _$GitHubAssetDtoFromJson(json);
}

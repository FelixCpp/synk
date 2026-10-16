import 'package:api_github/github/github_release_dto.dart';
import 'package:dio/dio.dart';

class const GitHubReleasesApi({
  required final String owner,
  required final String repository,
  required final Dio dio,
}) {
  Future<GitHubReleaseDto> fetchLatestRelease() async {
    final response = await dio.getUri<Map<String, dynamic>>(
      Uri.https('api.github.com', '/repos/$owner/$repository/releases/latest'),
      options: Options(
        headers: const {'Accept': 'application/vnd.github+json'},
      ),
    );

    return GitHubReleaseDto.fromJson(response.data!);
  }

  Future<void> downloadAsset(
    GitHubAssetDto asset,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    await dio.downloadUri(
      asset.downloadUrl,
      savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

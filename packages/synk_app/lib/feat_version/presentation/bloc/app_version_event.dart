part of 'app_version_bloc.dart';

@freezed
sealed class AppVersionEvent with _$AppVersionEvent {
  const factory AppVersionEvent.onCheckForUpdates() = _OnCheckForUpdates;
  const factory AppVersionEvent.onUpdate() = _OnUpdate;
}

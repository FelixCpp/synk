part of 'sidebar_bloc.dart';

@freezed
sealed class SidebarEvent with _$SidebarEvent {
  const factory SidebarEvent.onSetup() = _OnSetup;
  const factory SidebarEvent.onConnectRequested(PluggedDevice device) =
      _OnConnectRequested;
  const factory SidebarEvent.onDisconnectRequested(PluggedDevice device) =
      _OnDisconnectRequested;
  const factory SidebarEvent.onOpenCameraPrivacySettings() =
      _OnOpenCameraPrivacySettings;
}

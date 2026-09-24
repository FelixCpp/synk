part of 'sidebar_bloc.dart';

@freezed
sealed class SidebarEvent with _$SidebarEvent {
  const factory SidebarEvent.onSetup() = _OnSetup;
}

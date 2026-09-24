part of 'sidebar_bloc.dart';

@freezed
sealed class SidebarState with _$SidebarState {
  const factory SidebarState({
    required List<SidebarDevice> devices,
  }) = _SidebarState;

  factory SidebarState.initial() {
    return const SidebarState(
      devices: [],
    );
  }
}

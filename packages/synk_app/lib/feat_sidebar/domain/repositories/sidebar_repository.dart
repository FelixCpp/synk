import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';

abstract interface class SidebarRepository {
  Stream<List<SidebarDevice>> observeDevices();
}

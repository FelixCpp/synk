# Plattform-Abstraktion: Plan für neue Gerätetypen

> Interne Planungsnotiz (Deutsch). Stand: 2026-10-13. Siehe [ROADMAP.md](ROADMAP.md) für den
> Feature-Fahrplan und die [README](../README.md) für die Außensicht.

## Ziel

Neue Gerätetypen sollen nicht mehr Änderungen quer durch die App erzwingen. Zielzustand: **eine
Plattform = ein Verzeichnis + eine Zeile in einer Registry.** Die gemeinsame App-Schicht kennt keine
Plattformen, nur Fähigkeiten.

### Auslöser und wichtige Einordnung

Der Auslöser war der Wunsch, später iPads und Samsung-Tablets zu spiegeln. **Das sind keine neuen
Plattformen:** ein iPad läuft über denselben `usbmuxd`/CoreDevice-Pfad wie ein iPhone, ein
Samsung-Tablet über dasselbe ADB/scrcpy-Setup wie ein Galaxy-Handy. Beide tauchen heute schon in der
Sidebar auf und sollten spiegeln — nur ungetestet.

Insbesondere ist das Layout **nicht** betroffen: `SynkTheme.deviceFrameSizeFor`
(`synk_theme.dart:81`) hält die Spiegelfläche konstant und variiert nur das Seitenverhältnis, das aus
der Live-`DeviceScreenSize` kommt (`device_frame.dart:389`). Ein 4:3-Tablet bekommt dadurch
automatisch eine korrekt geformte Kachel gleicher Fläche. `deviceFrameWidth`/`deviceFrameHeight`
werden außerhalb von Tests nicht mehr verwendet.

Dieser Plan ist deshalb **keine Voraussetzung für iPads/Tablets**, sondern Vorbereitung für den Fall,
dass ein echt neues Backend dazukommt (Android TV, Emulator, Wear OS, ein zweiter Mac) — und
Aufräumarbeit, die sich unabhängig davon lohnt.

## Ausgangslage

### Was schon trägt

- **Die Capability-Interfaces existieren bereits:** `ScreenCaptureAgent`, `ClipboardAgent`,
  `InteractionAgent`, `AudioAgent` in `feat_device_agent/domain/models/`. Beide Agents
  (`AndroidDeviceAgent`, `IosDeviceAgent`) implementieren alle vier.
- **Die UI ist flag-getrieben**, nicht plattform-getrieben: `DeviceFrame` und die Toolbar entscheiden
  über `supportsInteraction` / `supportsDeviceActions` / `supportsAudio`, nicht über einen
  Plattform-Switch.
- **Geräte-Rotation** läuft generisch über `ScreenCaptureAgent.screenSizeChanges`.

Der Umbau muss die UI-Schicht also kaum anfassen. Er betrifft die Daten- und Domänenschicht.

### Was blockiert

„Genau zwei Plattformen" ist an diesen Stellen hart verdrahtet:

| Stelle | Problem |
| --- | --- |
| `feat_device_connections/data/repositories/device_connections_repository_impl.dart` | zwei parallele Agent-Maps, zwei `_connectX`/`_disconnectX`-Paare, `Rx.combineLatest3/4` über genau zwei Discovery-Repos, iOS-Sonderfälle in `getAudioAgent`/`getInteractionAgent` (`:258-278`) |
| `feat_sidebar/data/repositories/sidebar_repository_impl.dart:18` | `Rx.combineLatest3` über genau zwei Discovery-Repos |
| `feat_plugged_devices/domain/models/plugged_device.dart` | sealed Union mit `switch`-Gettern (`isAuthorized`, `supportsDeviceActions`) — die Exhaustiveness-Prüfung erzwingt Edits an jeder Switch-Stelle |
| `feat_device_connections/domain/models/device_connection.dart` | `.android`/`.ios`-Varianten, deren einziger Unterschied das `AndroidDeviceInfo`-Feld ist |
| `feat_device_agent/domain/repositories/device_agent_repository.dart` vs. `ios_device_agent_repository.dart` | zwei Interfaces mit unterschiedlichen Rückgabetypen, obwohl beide Agents dieselben Capability-Interfaces erfüllen |
| `main.dart:97-135` | Wiring mit einem festen Feld pro Plattform |
| `feat_device_frame/data/repositories/device_frame_repository_impl.dart:222` | greift für Drag & Drop über `getAndroidDeviceAgent()` auf den **konkreten** Android-Typ zu — das einzige echte Leck im Capability-Modell |
| `feat_sidebar/presentation/synk_sidebar.dart:80` | der „Wireless-Gerät verbinden"-Button ist unbedingt sichtbar, obwohl `adb pair` Android-spezifisch ist |
| `feat_plugged_devices/.../unavailable_plugged_adb_devices_repository.dart`, `feat_device_agent/.../unavailable_device_agent_repository.dart` | Null-Object-Stubs, nur weil `ToolAvailability` Tool-Verfügbarkeit plattformweise kennt |

## Zielbild

### Zwei Ebenen, nicht eine

Ein einziges fettes Interface pro Plattform funktioniert **nicht**: die Features sind ungleich
verteilt (APK-Install und Keyboard-Input nur Android, Wireless-Pairing nur Android, Audio auf iOS nur
im CoreDevice-Pfad). Ein `DevicePlatform` mit allen Methoden zwingt iOS zu einem Dutzend
`UnsupportedError`-Stubs, und die App müsste trotzdem fragen „kann das Gerät das?" — die Switches
wären nur umbenannt.

Deshalb zwei Ebenen:

1. **`DevicePlatform`** — eine pro Plattform, der einzige Registrierungspunkt. Pflicht: Tools,
   Discovery, Agent-Fabrik. Optional: Pairing.
2. **`DeviceAgent`** — einer pro verbundenem Gerät. Pflicht ist nur Mirroring; alles andere ist
   opt-in über die bestehenden Capability-Interfaces.

### Code-Skizze

```dart
/// Eine Datei pro Plattform. Der einzige Registrierungspunkt.
abstract interface class DevicePlatform {
  PlatformId get id;
  Set<ExternalTool> get requiredTools;       // adb / devicectl

  Stream<List<PluggedDevice>> observeDevices();
  Future<DeviceAgent> connect(DeviceId id);
  Future<void> disconnect(DeviceId id);
  Future<void> dispose();

  PlatformPairing? get pairing => null;      // opt-in, Android: adb pair
}

/// Einer pro verbundenem Gerät. Pflicht ist nur Mirroring.
abstract interface class DeviceAgent {
  ScreenCaptureAgent get screen;
  T? capability<T extends Object>();
  Future<void> dispose();
}

/// Default-Auflösung über den statischen Typ.
mixin ResolvesCapabilities implements DeviceAgent {
  @override
  T? capability<T extends Object>() => this is T ? this as T : null;
}
```

### Warum `capability<T>()` und nicht `agent is T`

Weil manche Fähigkeiten **Laufzeitfakten** sind, keine Typfakten:

- `supportsInteraction` auf iOS hängt davon ab, ob die HID-Vorbereitung geklappt hat
  (`ios_device_agent_repository_impl.dart:49`); ohne Usage-Assertion fällt HID komplett aus.
- `supportsAudio` auf iOS hängt am gewählten Transport — der `AVFoundation`-Rückfall ist stumm.

Beides steht heute als iOS-Sonderfall mitten im gemeinsamen Repository
(`device_connections_repository_impl.dart:258-278`). Mit der Methode gated sich die Plattform selbst:

```dart
// ios_device_agent.dart
@override
T? capability<T extends Object>() {
  if (T == InteractionAgent && !supportsInteraction) return null;
  if (T == AudioAgent && !transport.supportsAudio) return null;
  return super.capability<T>();
}
```

Das ist der eigentliche Gewinn des Umbaus: **Plattformwissen steht nur noch in Plattformdateien.**

## Getroffene Entscheidungen

| Frage | Entscheidung | Begründung |
| --- | --- | --- |
| `AndroidDeviceInfo` | **behalten** | Wird aktuell von keiner UI gelesen, soll aber für später bleiben. Lebt künftig als Feld auf `AndroidDeviceAgent`, gefüllt in `AndroidPlatform.connect()`. |
| `AndroidDeviceConnection` (usb/wifi) | **behalten** | Wird ebenfalls nirgends gelesen. Wandert nach `AndroidDeviceDetails`. |
| `AndroidDeviceState` | behalten, aber gekapselt | Dient nur `isAuthorized`; das wird ein einfaches `bool`-Feld, das die Android-Konvertierung setzt. |
| `PluggedDevice` entsealen | **ja** | Siehe Risiken — der Exhaustiveness-Schutz sichert heute nur zwei Switch-Stellen, die der Umbau ohnehin löscht. |
| Fetch von `AndroidDeviceInfo` beim Connect | **bleibt eager** | Der Call ist faktisch ein Handshake-Probe: schlägt er fehl, wird die Verbindung gekappt (`device_connections_repository_impl.dart:169-176`). Diese Semantik darf nicht verloren gehen — sie zieht nur aus dem gemeinsamen Repository in `AndroidPlatform.connect()`. |

## Schrittfolge

Stufen 0 und 1 sind unabhängig und jederzeit einzeln lieferbar. Stufen 2–5 bauen aufeinander auf und
sollten in dieser Reihenfolge laufen.

### Stufe 0 — `DeviceForm` (klein, kosmetisch)

Nutzen: Sidebar zeigt für jedes Gerät hart `CupertinoIcons.device_phone_portrait`
(`synk_sidebar.dart:138,191`). **Kein Layout-Effekt** — die Kachelgröße ist schon
seitenverhältnis-getrieben.

- Neu: `feat_plugged_devices/domain/models/device_form.dart` — `enum DeviceForm { phone, tablet, unknown }`
- iOS: Ableitung aus dem `productType`-Prefix (`iPad*` vs. `iPhone*`) in `ios/data/models/ios_device_dto.dart`
- Android: `adb shell getprop ro.build.characteristics` (enthält `tablet`) in `conversions/adb_device_dto.dart`
  bzw. `adb/data/datasources/adb_devices_datasource.dart`.
  **Achtung:** Discovery kommt aus `adb track-devices` und hat keine Props. Ein zusätzlicher
  `shell`-Call pro Gerät ist nötig — pro Serial cachen, sonst läuft er bei jedem Stream-Event.
  Fällt der Call aus, `unknown` liefern, nie blockieren.
- Konsumenten: Sidebar-Icon, Empty-State-Text („Android- oder iOS-Gerät")
- Tests: `test/feat_plugged_devices/plugged_device_test.dart`

### Stufe 1 — `FileTransferAgent` extrahieren

Schließt das einzige Capability-Leck.

- Neu: `feat_device_agent/domain/models/file_transfer_agent.dart` — `pushFile`, `installApk`
- `AndroidDeviceAgent implements FileTransferAgent` (Methoden existieren bereits)
- `getAndroidDeviceAgent` aus `DeviceConnectionsRepository` entfernen;
  `device_frame_repository_impl.dart:222` holt stattdessen den `FileTransferAgent`
- Tests: `test/feat_device_connections/device_connections_repository_impl_test.dart`

### Stufe 2 — `DeviceAgent` + `capability<T>()`

- Neu: `feat_device_agent/domain/models/device_agent.dart` — `DeviceAgent`,
  `ResolvesCapabilities`, `enum DeviceCapability`
- Beide Agents implementieren `DeviceAgent`; der iOS-Agent überschreibt `capability<T>()` mit den
  beiden Laufzeit-Gates (siehe oben)
- `DeviceConnectionsRepository`: die fünf `getXAgent`-Getter werden zu einem
  `T? capability<T>(DeviceId)`; die iOS-Sonderfälle in der Implementierung entfallen
- Tests: `device_connections_repository_impl_test.dart`

### Stufe 3 — `DevicePlatform` + Registry

Der eigentliche Umbau, ~8 Dateien.

- Neu: `feat_device_platforms/` mit `device_platform.dart`, `platform_id.dart`,
  `device_platform_registry.dart`
- `AndroidPlatform` kapselt `PluggedAdbDevicesRepositoryImpl` + `AndroidDeviceAgentRepositoryImpl`;
  `IosPlatform` analog. Die bestehenden Repos bleiben als Interna erhalten — kein Rewrite ihrer Logik.
- `requiredTools` + `ToolAvailability` ⇒ die Registry filtert Plattformen ohne Tools heraus.
  **Löscht `UnavailablePluggedAdbDevicesRepository` und `UnavailableDeviceAgentRepository`.**
- `DeviceConnectionsRepositoryImpl`: eine `Map<DeviceId, DeviceAgent>`, ein `_connect`, ein
  `_disconnect`, `Rx.combineLatestList` statt `combineLatest3/4`
- `SidebarRepositoryImpl`: dito
- `main.dart`: Wiring kollabiert auf eine Registry-Liste
- `PlatformPairing?` ⇒ der Wireless-Button in der Sidebar wird bedingt
- Tests: `device_connections_repository_impl_test.dart` (316 Zeilen),
  `sidebar_repository_impl_test.dart` (214 Zeilen) — beide brauchen neue Fakes auf
  `DevicePlatform`-Ebene statt je zwei Repo-Fakes. Das ist der größte Testaufwand des Plans.

### Stufe 4 — `PluggedDevice` entsealen

```dart
class PluggedDevice {
  final DeviceId id;
  final PlatformId platform;
  final String modelName;
  final DeviceForm form;
  final bool isAuthorized;
  final PlatformDeviceDetails? details;   // AndroidDeviceDetails(state, connection)
}
```

- `PlatformDeviceDetails` ist ein leeres Marker-Interface; `AndroidDeviceDetails` hält
  `AndroidDeviceState` + `AndroidDeviceConnection` (beide laut Entscheidung behalten)
- `isAuthorized` wird vom Android-Mapping gesetzt (`state == AndroidDeviceState.device`), iOS setzt
  `true` (Pairing passiert außerhalb von synk)
- Der Getter `supportsDeviceActions` entfällt — ersetzt durch Capabilities (Stufe 5)
- Tests: `plugged_device_test.dart` wird umgeschrieben; die Aussagen wandern in die
  Plattform-Mappings

### Stufe 5 — `DeviceConnection` vereinheitlichen

- Eine Klasse statt zwei Varianten. Das `AndroidDeviceInfo`-Feld entfällt hier (es lebt laut
  Entscheidung auf dem Agent), damit fällt der letzte Grund für die Aufspaltung weg.
- Die drei Bools werden **ein** `Set<DeviceCapability> capabilities`, abgeleitet im generischen
  Repository durch Probing:

```dart
Set<DeviceCapability> _capabilitiesOf(DeviceAgent agent) => {
  if (agent.capability<InteractionAgent>() != null) DeviceCapability.interaction,
  if (agent.capability<ClipboardAgent>() != null) DeviceCapability.clipboard,
  if (agent.capability<AudioAgent>() != null) DeviceCapability.audio,
  if (agent.capability<FileTransferAgent>() != null) DeviceCapability.fileTransfer,
};
```

- Durchzureichen durch: `CanvasDevice`, `MaximizedDevice`, `DeviceFrame`, `DeviceFrameToolBar`.
  Spart die heute vierfach weitergegebenen Bools und skaliert auf neue Fähigkeiten, ohne vier
  Modelle anzufassen.
- Tests: `device_canvas_repository_impl_test.dart`, `maximized_device`-Pfad, `device_frame_test.dart`

### Stufe 6 (optional, Verhaltensänderung) — `DeviceControlAgent`

Beim Prüfen aufgefallen: **`supportsDeviceActions` ist überladen.** Es gated gleichzeitig

- Drop-Target, APK-Install, „Datei senden" (`device_frame.dart:73`, `device_frame_tool_bar.dart:176`) und
- die Back-/AppSwitch-Buttons der Controls-Bar (`device_frame.dart:115,121`),

ist aber für iOS pauschal `false`. Dabei beherrscht der iOS-Agent **alle vier**
`DeviceControlAction`s bereits: `iosSwipeForControlAction` liefert Gesten für `home`, `appSwitch`
*und* `back` (`ios_touch_gesture.dart:46-68`), `iosButtonForControlAction` den `standby`-Knopf über
Consumer-HID. Auf iOS sind Back und AppSwitch also implementiert, aber durch das überladene Flag
ausgeblendet.

Nach Stufe 5 trennt sich das sauber in `.fileTransfer` und `.deviceControl` — womit iOS diese Buttons
bekäme. Das ist eine **sichtbare Verhaltensänderung** und daher eine eigene Stufe mit eigener
Entscheidung. Sauberste Form, falls gewünscht:

```dart
abstract interface class DeviceControlAgent {
  Set<DeviceControlAction> get supportedActions;
  Future<void> simulateControlAction(DeviceControlAction action);
}
```

Dann rendert die Toolbar pro Action statt pro Pauschal-Flag.

## Risiken

- **Verlust der freezed-Exhaustiveness bei `PluggedDevice` (Stufe 4).** Heute erzwingt der Compiler
  bei einer neuen Variante Edits an allen `switch`-Stellen. Das ist genau die Eigenschaft, die der
  Umbau loswerden soll — aber es ist auch ein Sicherheitsnetz. Bewertung: es sichert derzeit nur zwei
  Switches (`isAuthorized`, `supportsDeviceActions`), und beide verschwinden. `DeviceConnectionState`,
  `SidebarDeviceState` und die Capability-Enums bleiben sealed bzw. exhaustiv — die
  Zustandslogik behält ihr Netz. Entscheidung: akzeptabel.
- **Stufe 3 ist ein Big-Bang.** `main.dart`, beide Discovery-Repos, beide Agent-Repos und das
  Connections-Repo ändern sich zusammen; dazwischen compiliert es nicht. Mitigation: Stufen 0–2
  vorher einzeln commiten, Stufe 3 in einem Branch, Tests vor dem Umbau grün ziehen.
- **Test-Churn.** Vier Testdateien (~700 Zeilen) brauchen neue Fakes. Vorschlag: einen
  `FakeDevicePlatform` zentral in `test/support/` anlegen, bevor Stufe 3 beginnt.
- **Stufe 0 auf Android kostet einen Shell-Call pro Gerät** im Discovery-Pfad. Nicht blockierend
  implementieren, Ergebnis pro Serial cachen.

## Was eine neue Plattform danach kostet

- **iPad, Samsung-Tablet:** null Zeilen Plattformcode — laufen über die bestehenden Plattformen.
  Nur `DeviceForm` für Icon und Texte (Stufe 0).
- **Echtes neues Backend** (Android TV, Emulator, Wear OS, zweiter Mac): ein Verzeichnis
  `feat_platform_x/` mit einer `DevicePlatform`-Implementierung plus einer Zeile in der Registry.
  Die App-Schicht bleibt unberührt, solange das Backend die bestehenden Capability-Interfaces
  bedient.

## Offene Fragen

- Soll `AndroidDeviceInfo` irgendwann in der UI auftauchen? Falls ja, lohnt ein generisches
  `DeviceInfoAgent`-Capability (Label/Wert-Paare), damit iOS seine Version über `devicectl`
  beisteuern kann, statt den Android-Typ in die UI zu lassen.
- Stufe 6 umsetzen, also iOS Back/AppSwitch-Buttons geben? (Vorher am Gerät verifizieren — die
  distanzabhängige Wisch-Physik ist noch nicht am Gerät nachgefühlt.)
- Brauchen `DeviceForm.foldable` / `.tv` schon jetzt einen Platz im Enum, oder erst bei Bedarf?

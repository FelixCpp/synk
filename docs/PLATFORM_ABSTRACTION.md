# Plattform-Abstraktion

> Interne Notiz (Deutsch). Stand: 2026-10-13. Siehe [ROADMAP.md](ROADMAP.md) für den
> Feature-Fahrplan und die [README](../README.md) für die Außensicht.
>
> Diese Notiz beschreibt den umgesetzten Stand. Der ursprüngliche Plan (`capability<T>()`,
> Registry, Stufen 0–6) wurde durch eine flachere Variante ersetzt; was davon offen bleibt, steht
> unter [Offene Punkte](#offene-punkte).

## Ziel

Ein neuer Gerätetyp soll keine Änderungen quer durch die App erzwingen. **Eine Plattform ist ein
Verzeichnis plus eine Zeile in `main.dart`.** Die gemeinsame App-Schicht kennt keine Plattformen,
nur Fähigkeiten.

iPads und Samsung-Tablets sind dabei **keine neuen Plattformen**: ein iPad läuft über denselben Pfad
wie ein iPhone, ein Samsung-Tablet über dasselbe ADB/scrcpy-Setup wie ein Galaxy-Handy. Die
Abstraktion ist Vorbereitung für ein echt neues Backend (Android TV, Emulator, Wear OS).

## Zwei Ebenen

```dart
/// Eine pro Plattform.
abstract interface class DevicePlatform {
  Set<ExternalTool> getToolRequirements();
  Stream<List<PluggedDevice>> observeDevices();

  /// Der Agent besitzt die Verbindung; dispose() trennt sie.
  Future<DeviceAgent> connect(DeviceId deviceId);
  Future<void> dispose();
}

/// Einer pro verbundenem Gerät.
abstract interface class DeviceAgent {
  NativeTextureId get textureId;
  DeviceScreenSize get screenSize;
  Stream<DeviceScreenSize> get screenSizeChanges;

  AudioDeviceAgent? get audio;
  ClipboardDeviceAgent? get clipboard;
  ScreenCaptureDeviceAgent? get screenCapture;
  InteractionDeviceAgent? get interaction;
  FileTransferDeviceAgent? get fileTransfer;

  Future<void> dispose();
}
```

- **Fähigkeiten sind nullable Getter.** Was ein Gerät nicht kann, ist `null`; der Compiler erzwingt
  die Prüfung beim Aufrufer (`agent.interaction?.simulateKeyEvent(...)`).
- **Laufzeitfakten entscheidet die Plattform beim Verbinden.** iOS liefert `interaction` nur, wenn
  die HID-Session vorbereitet werden konnte, und `audio` nur, wenn der CoreDevice-Audiostream neben
  der Capture-Session läuft. Die App-Schicht enthält dafür keine Sonderfälle mehr.
- **Der Agent implementiert die Fähigkeiten nicht selbst.** Er setzt Teile zusammen, die je ein
  Interface erfüllen, und kümmert sich um Bildschirmgröße und `dispose()`.
- **Die Plattform führt keine Agent-Liste.** `connect()` baut die Ressourcen und räumt bei einem
  Fehlschlag auf; danach gehört die Verbindung dem Agent.
- **`PluggedDevice` ist ein Interface** (`id`, `modelName`, `isAuthorized`). Jede Plattform bringt
  ihren eigenen Typ mit (`AndroidDevice`, `IosDevice`) und kann dort eigene Felder halten.
- **Navigation und Power-Knopf sind getrennt:** `navigate(DeviceNavigation)` für Back, Home und
  App-Switch, `pressPowerButton()` für den Hardware-Knopf.
- **Welche Navigationen ein Gerät anbietet, sagt es selbst:**
  `InteractionDeviceAgent.supportedNavigations`. Android meldet alle drei, iOS nur Home.

## Verzeichnisse

```
feat_device_platform/           Interfaces und gemeinsame Modelle
  application/                  DevicePlatform, DeviceAgent, agents/ (Fähigkeits-Interfaces)
  domain/models/                DeviceId, PluggedDevice, DeviceScreenSize, NativeTextureId,
                                DeviceKeyEvent, DevicePointerEvent, PinchEvent, DeviceNavigation

feat_device_platform_android/
  android_device_platform.dart  connect(), observeDevices()
  android_device_agent.dart
  android_screen_capture_device_agent.dart
  discovery/                    AndroidDevice, Zustand/Verbindungsart, DTO-Umwandlung
  scrcpy/                       Server-Start, Session/Channel, Interaktion, Audio, Key-/Pointer-Modelle
  device_agent/                 eigener Agent (dex): Start, Client, Protobuf, AndroidDeviceInfo
  adb/                          Dateitransfer

feat_device_platform_ios/
  ios_device_platform.dart
  ios_device_agent.dart
  ios_screen_capture_device_agent.dart
  discovery/                    IosDevice, Discovery-Channel, DTO
  mirror/                       Capture-Session, Media-Stream, Transport, Audio
  hid/                          HID-Channel, Touch-/Key-/Button-Modelle, Interaktion
  devicectl/                    Zwischenablage
```

Innerhalb einer Plattform ist nach Backend gruppiert, nicht nach Schicht.

## Wie die App die Plattformen benutzt

- **`main.dart`** baut die Plattformliste und lässt nur die durch, deren `getToolRequirements()`
  die `ToolAvailability` erfüllt.
- **`DeviceConnectionsRepositoryImpl`** bekommt diese Liste. Es führt die Geräte aller Plattformen
  zusammen, merkt sich, welche Plattform welches Gerät gemeldet hat, und hält eine einzige
  `Map<DeviceId, DeviceAgent>`. Verbinden läuft über die meldende Plattform, Trennen über
  `agent.dispose()`.
- **`DeviceConnection`** ist das eine Modell für ein verbundenes Gerät. Canvas, maximierte Ansicht
  und `DeviceFrame` benutzen es direkt; `supportsInteraction`, `navigations`, `supportsFileTransfer`
  und `supportsAudio` leiten sich aus den Fähigkeiten des Agents ab. Die Navigationsleiste zeigt
  genau die Buttons aus `navigations`; `supportsFileTransfer` schaltet Drop-Ziel, APK-Installation
  und „Datei senden".
- **`DeviceFrameRepository`** holt sich den Agent über `getAgent(deviceId)` und ruft die
  Fähigkeiten auf.

## Eine neue Plattform hinzufügen

1. Verzeichnis `feat_device_platform_x/` mit einer `DevicePlatform`-Implementierung, einem
   `DeviceAgent` und einem `PluggedDevice`-Typ anlegen.
2. Die Plattform in die Liste in `main.dart` eintragen.

Solange das Backend die bestehenden Fähigkeits-Interfaces bedient, bleibt die App-Schicht unberührt.

## Getroffene Entscheidungen

| Frage | Entscheidung |
| --- | --- |
| Form der Fähigkeiten | Nullable Getter statt `capability<T>()`; kein Enum, kein Mapping. |
| `AndroidDeviceInfo` | Bleibt. Wird in `AndroidDevicePlatform.connect()` als Handshake-Probe geholt und liegt als Feld auf `AndroidDeviceAgent`; gelesen wird es bisher nirgends. |
| `AndroidDeviceState`, `AndroidDeviceConnection` | Bleiben als Felder von `AndroidDevice`. `state` bestimmt `isAuthorized`. |
| iOS und devicectl | `IosDevicePlatform` verlangt kein Tool. devicectl steckt nur hinter Zwischenablage und bevorzugtem Screenshot-Weg; beide fallen ohne es weich aus. |
| Interactors | Bleiben. Sie sind das Idiom von `use_in_case` und unabhängig von der Plattformfrage. |

## Offene Punkte

- **Am Gerät prüfen.** Der Umbau ist durch Tests abgedeckt, aber noch nicht mit einem Android- und
  einem iOS-Gerät durchgespielt.
- **iOS bietet nur Home an.** Die Wischgesten für Back und App-Switch existieren in
  `iosSwipeForNavigation`, ihre distanzabhängige Physik ist aber noch nicht am Gerät nachgefühlt.
  Freigeben heißt, sie in `IosInteractionDeviceAgent.supportedNavigations` aufzunehmen.
- **`ConnectionFailure.connectionRefused` wird nicht mehr erzeugt.** Jeder Fehlschlag ist `unknown`.
- **`IosMediaStreamTransport` ist unbenutzt.** Im Einsatz ist nur `IosCaptureSessionTransport`.
- **`DeviceForm` (Telefon/Tablet)** für Sidebar-Icon und Texte ist nicht umgesetzt.
- **Repository-Interfaces** mit nur einer Implementierung gibt es noch für Connections, Pairing,
  Tool-Validierung und Theme-Mode. Das von Connections dient den Tests als Naht.
- **`device_frame_test`** („hides interaction-only controls for a non-interactive device") schlägt
  schon vor dem Umbau fehl.

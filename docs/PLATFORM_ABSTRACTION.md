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

  /// Die Session besitzt die Verbindung; dispose() trennt sie.
  Future<DeviceSession> connect(DeviceId deviceId);
  Future<void> dispose();
}

/// Eine pro verbundenem Gerät.
abstract interface class DeviceSession {
  NativeTextureId get textureId;
  DeviceScreenSize get screenSize;
  Stream<DeviceScreenSize> get screenSizeChanges;

  DeviceAudio? get audio;
  DeviceClipboard? get clipboard;
  DeviceScreenCapture? get screenCapture;
  DeviceInteraction? get interaction;
  DeviceFileTransfer? get fileTransfer;

  Future<void> dispose();
}
```

- **Fähigkeiten sind nullable Getter.** Was ein Gerät nicht kann, ist `null`; der Compiler erzwingt
  die Prüfung beim Aufrufer (`session.interaction?.simulateKeyEvent(...)`).
- **Laufzeitfakten entscheidet die Plattform beim Verbinden.** iOS liefert `interaction` nur, wenn
  die HID-Session vorbereitet werden konnte, und `audio` nur, wenn der CoreDevice-Audiostream neben
  der Capture-Session läuft. Die App-Schicht enthält dafür keine Sonderfälle mehr.
- **Die Session implementiert die Fähigkeiten nicht selbst.** Sie setzt Teile zusammen, die je ein
  Interface erfüllen, und kümmert sich um Bildschirmgröße und `dispose()`.
- **Die Plattform führt keine Session-Liste.** `connect()` baut die Ressourcen und räumt bei einem
  Fehlschlag auf; danach gehört die Verbindung der Session.
- **`PluggedDevice` ist ein Interface** (`id`, `modelName`, `isAuthorized`). Jede Plattform bringt
  ihren eigenen Typ mit (`AndroidDevice`, `IosDevice`) und kann dort eigene Felder halten.
- **Navigation und Power-Knopf sind getrennt:** `navigate(DeviceNavigation)` für Back, Home und
  App-Switch, `pressPowerButton()` für den Hardware-Knopf.
- **Welche Navigationen ein Gerät anbietet, sagt es selbst:**
  `DeviceInteraction.supportedNavigations`. Android meldet alle drei, iOS nur Home.

## Begriffe

- **Session** (`DeviceSession`): ein verbundenes Gerät.
- **Fähigkeit** (`DeviceInteraction`, `DeviceAudio`, …): was eine Session kann.
- **Agent**: ausschließlich der eigene dex-Prozess auf dem Android-Gerät
  (`DeviceAgentLauncher`, `AndroidDeviceAgentCommunicator`).

## Verzeichnisse

```
feat_device_platform/           Interfaces und gemeinsame Modelle
  application/                  device_platform.dart, device_session.dart (Session, Fähigkeiten,
                                NativeTextureId)
  domain/models/                plugged_device.dart (mit DeviceId), device_input.dart (Key-,
                                Pointer-, Pinch-Events, DeviceNavigation), device_screen_size.dart

feat_device_platform_android/
  android_device_platform.dart  connect(), observeDevices()
  android_device_session.dart
  android_screen_capture.dart
  discovery/                    AndroidDevice, Zustand/Verbindungsart, DTO-Umwandlung
  scrcpy/                       Server-Start, ScrcpyMirror/Channel, Interaktion, Audio, Key-/Pointer-Modelle
  device_agent/                 eigener Agent (dex): Start, Client, Protobuf, AndroidDeviceInfo
  adb/                          Dateitransfer

feat_device_platform_ios/
  ios_device_platform.dart
  ios_device_session.dart
  ios_screen_capture.dart
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
  `Map<DeviceId, DeviceSession>`. Verbinden läuft über die meldende Plattform, Trennen über
  `session.dispose()`.
- **`DeviceConnection`** ist das eine Modell für ein verbundenes Gerät: `device`, `session` und
  `screenSize`. `textureId`, `supportsInteraction`, `navigations`, `supportsFileTransfer` und
  `supportsAudio` sind Getter, die die Session fragen. Canvas, maximierte Ansicht und `DeviceFrame`
  bekommen die Verbindung als ein Objekt.
- **`DeviceFrameRepository`** wird pro Frame mit der Session der Verbindung gebaut. Jede Aktion
  läuft weiter über View → Bloc → Interactor → Repository; durchgereicht wird nur noch die
  Nutzlast, keine `deviceId`.

## Eine neue Plattform hinzufügen

1. Verzeichnis `feat_device_platform_x/` mit einer `DevicePlatform`-Implementierung, einer
   `DeviceSession` und einem `PluggedDevice`-Typ anlegen.
2. Die Plattform in die Liste in `main.dart` eintragen.

Solange das Backend die bestehenden Fähigkeits-Interfaces bedient, bleibt die App-Schicht unberührt.

## Getroffene Entscheidungen

| Frage | Entscheidung |
| --- | --- |
| Form der Fähigkeiten | Nullable Getter statt `capability<T>()`; kein Enum, kein Mapping. |
| `AndroidDeviceInfo` | Bleibt. Wird in `AndroidDevicePlatform.connect()` als Handshake-Probe geholt und liegt als Feld auf `AndroidDeviceSession`; gelesen wird es bisher nirgends. |
| `AndroidDeviceState`, `AndroidDeviceConnection` | Bleiben als Felder von `AndroidDevice`. `state` bestimmt `isAuthorized`. |
| iOS und devicectl | `IosDevicePlatform` verlangt kein Tool. devicectl steckt nur hinter Zwischenablage und bevorzugtem Screenshot-Weg; beide fallen ohne es weich aus. |
| Interactors | Bleiben. Sie sind das Idiom von `use_in_case` und unabhängig von der Plattformfrage. |

## Offene Punkte

- **Am Gerät prüfen.** Der Umbau ist durch Tests abgedeckt, aber noch nicht mit einem Android- und
  einem iOS-Gerät durchgespielt.
- **iOS bietet nur Home an.** Die Wischgesten für Back und App-Switch existieren in
  `iosSwipeForNavigation`, ihre distanzabhängige Physik ist aber noch nicht am Gerät nachgefühlt.
  Freigeben heißt, sie in `IosInteraction.supportedNavigations` aufzunehmen.
- **`ConnectionFailure.connectionRefused` wird nicht mehr erzeugt.** Jeder Fehlschlag ist `unknown`.
- **`IosMediaStreamTransport` ist unbenutzt.** Im Einsatz ist nur `IosCaptureSessionTransport`.
- **`DeviceForm` (Telefon/Tablet)** für Sidebar-Icon und Texte ist nicht umgesetzt.
- **Repository-Interfaces** mit nur einer Implementierung gibt es noch für Connections, Pairing,
  Tool-Validierung und Theme-Mode. Das von Connections dient den Tests als Naht.
- **`device_frame_test`** („hides interaction-only controls for a non-interactive device") schlägt
  schon vor dem Umbau fehl.

# device-viewer
A Vysor-Clone but having modern design written in Dart using Flutter

## Roadmap: Vysor-Feature-Parität

Stand: 2026-09-29. Aktuell basiert das Screen-Mirroring auf scrcpy (USB/ADB) mit Maus-/Tastatur-Input, Screenshot, Fenster-Maximieren und Live-Status-Anzeige. Um als echte Vysor-Alternative zu gelten, fehlen noch folgende Punkte.

### Bare-Minimum-Lücken

- **Recording** – Aufnahme-Button ist nur ein Platzhalter (`feat_device_frame/presentation/widgets/device_frame_tool_bar.dart`), Aufnahme des gespiegelten Streams in eine Datei ist nicht implementiert.
- **Audio** – Server wird mit `audio=false` gestartet (`feat_device_agent/data/datasources/scrcpy_server_launcher.dart`). scrcpy unterstützt Audio-Forwarding seit v2.0, fehlt hier nur Flag + Playback-Handling.
- **Kabelloses Pairing (WLAN)** – kein `adb pair`/`adb connect`/TCP-IP-Handling vorhanden, aktuell nur USB-Geräte über `adb devices`.
- **Clipboard-Sync** – kein Copy/Paste zwischen Mac und Gerät.
- **Datei-/APK-Übertragung** – kein Drag&Drop, kein „APK installieren“, kein Dateibrowser.
- **Hardware-Buttons** – Back/Home/Recent-Apps, Power, Volume fehlen in der Toolbar (aktuell nur Screenshot, Maximieren, Schließen).
- **Bildqualitäts-/Bitrate-Einstellungen** – Bitrate (8 Mbit/s), FPS (60), Codec sind hart codiert, keine UI zum Anpassen.
- **Settings-Screen** – es gibt aktuell keinerlei Einstellungsoberfläche.

### Kleinere Lücken

- Keine Geräte-Rotation-Kontrolle (nur was das Gerät selbst sendet).
- Kein „Always on Top“ fürs Fenster.
- Kein Multi-Geräte-Broadcast (gleiche Eingabe an mehrere Geräte gleichzeitig senden).

### Priorisierungsvorschlag

1. Wireless-Pairing und Recording (größter wahrgenommener Vysor-Abstand, Audio ist z. B. nur ein Flag-Flip auf dem bestehenden scrcpy-Unterbau).
2. Datei-/APK-Transfer und Clipboard-Sync.
3. Hardware-Buttons in der Toolbar (Interaktionspipeline in `android_interaction_transmission.dart` existiert bereits, müsste nur um weitere Key-Events erweitert werden).

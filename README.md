# synk

A Vysor-Clone but having modern design written in Dart using Flutter

## Roadmap: Vysor-Feature-Parität

Stand: 2026-09-29. Aktuell basiert das Screen-Mirroring auf scrcpy (USB/ADB) mit Maus-/Tastatur-Input, Screenshot, Fenster-Maximieren und Live-Status-Anzeige. Um als echte Vysor-Alternative zu gelten, fehlen noch folgende Punkte.

### Bare-Minimum-Lücken

- [x] **Recording** – Aufnahme des gespiegelten Streams per `AVAssetWriter` (`ScreenMirrorPlugin.swift`), zapft dieselben CMSampleBuffer ab, die auch an VideoToolbox zum Decodieren gehen.
- [x] **Audio** – Audio-Forwarding über einen dritten scrcpy-Socket (`audio_codec=raw`), Playback via `AVAudioEngine` in `ScreenMirrorPlugin.swift`. Standardmäßig stummgeschaltet, Mute-Button in der Toolbar.
- [x] **Kabelloses Pairing (WLAN)** – `adb pair`/`adb connect` über `WirelessPairingDialog` und `connect_wirelessly_interactor.dart`.
- [x] **Clipboard-Sync** – kein Copy/Paste zwischen Mac und Gerät.
- [x] **Datei-/APK-Übertragung** – kein Drag&Drop, kein „APK installieren“, kein Dateibrowser.
- [x] **Hardware-Buttons** – Back/Home/Recent-Apps, Power, Volume fehlen in der Toolbar (aktuell nur Screenshot, Maximieren, Schließen).
- [ ] **Bildqualitäts-/Bitrate-Einstellungen** – Bitrate (8 Mbit/s), FPS (60), Codec sind hart codiert, keine UI zum Anpassen.
- [ ] **Settings-Screen** – es gibt aktuell keinerlei Einstellungsoberfläche.

### Kleinere Lücken

- Keine Geräte-Rotation-Kontrolle (nur was das Gerät selbst sendet).
- Kein „Always on Top“ fürs Fenster.
- Kein Multi-Geräte-Broadcast (gleiche Eingabe an mehrere Geräte gleichzeitig senden).

### Vertagte Ideen

- **Freier Drag-Space statt Grid** – Geräte frei im Canvas positionieren (Pan/Zoom, Z-Order, persistierte Positionen) statt Auto-Layout im `ReflowGrid`. Stand 2026-10-05 bewusst verschoben: der Auslöser war die unbrauchbare Landscape-Darstellung, die aber nicht am Grid lag, sondern an fixer Zellgröße – gelöst über `SynkTheme.deviceFrameSizeFor`, das die Kachel nach Geräte-Seitenverhältnis bei konstanter Fläche bemisst (ein gedrehtes Gerät behält seine Kachel, nur hochkant/quer getauscht). Kosten eines Drag-Space: der Nutzer muss Layout selbst pflegen, Reflow-Animation und Hero-Maximieren müssten neu gedacht werden. Alternative mit mehr Hebel für denselben Zweck: pro Gerät ein eigenes, resizebares macOS-Fenster (der Weg von Vysor und scrcpy).

### Priorisierungsvorschlag

1. Wireless-Pairing und Recording (größter wahrgenommener Vysor-Abstand, Audio ist z. B. nur ein Flag-Flip auf dem bestehenden scrcpy-Unterbau).
2. Datei-/APK-Transfer und Clipboard-Sync.
3. Hardware-Buttons in der Toolbar (Interaktionspipeline in `android_interaction_transmission.dart` existiert bereits, müsste nur um weitere Key-Events erweitert werden).

## Roadmap: iOS-Unterstützung

Stand: 2026-09-30. Die Android-Pipeline basiert darauf, per ADB eine eigene Server-JAR aufs Gerät zu pushen (`ScrcpyServerLauncher`) und dort mit erhöhten Rechten laufen zu lassen – das erlaubt rohen H264-Stream, Input-Injection per `InputManager`-Reflection und Clipboard-Zugriff über ein eigenes Socket-Protokoll (`android_interaction_transmission.dart`). Diese Tür gibt es bei iOS grundsätzlich nicht – Apple lässt keine eigene Binary mit Systemrechten auf dem Gerät laufen. Der Aufwand ist deshalb keine reine Fleißarbeit wie bei Android, sondern durch Plattformgrenzen strukturell größer, und manche Features sind ohne Jailbreak gar nicht sauber erreichbar.

### Vergleich Android (Ist-Zustand) vs. iOS (realistisch)

| Feature              | Android (jetzt)                            | iOS (realistisch)                                                                                                                                                                                                      |
| -------------------- | ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Geräte-Discovery     | `adb track-devices`                        | kein ADB-Äquivalent; `usbmuxd`-Protokoll (z. B. über `libimobiledevice`)                                                                                                                                               |
| Bildschirm-Mirroring | eigener Server streamt H264 über Socket    | `AVFoundation`/`CoreMediaIO` captured Gerät als Kamera (wie QuickTime „Movie Recording"), liefert fertige `CMSampleBuffer` – kein eigener H264-Decoder nötig                                                           |
| Touch-/Key-Injection | InputManager-Reflection im eigenen Server  | keine offizielle Möglichkeit; einzig praktikabler Weg ist `WebDriverAgent`/XCTest-UI-Automation über eine signierte, auf dem Gerät installierte Companion-App – fragil, braucht Dev-Account + Codesigning/Provisioning |
| Clipboard-Sync       | Custom-Protokoll im eigenen Server         | kein Public API; nur über denselben WDA-Umweg oder gar nicht                                                                                                                                                           |
| Datei-Transfer       | `adb push`                                 | AFC-Protokoll (libimobiledevice), stark sandboxed                                                                                                                                                                      |
| App-Install          | `pm install`                               | braucht gültig signierte/provisionierte IPA, kein freies Sideloading                                                                                                                                                   |
| Screenshot           | RPC an eigenen Server                      | benötigt gemountetes Developer-Disk-Image, wechselt mit jeder iOS-Version                                                                                                                                              |
| Recording            | `AVAssetWriter` zapft den Decode-Stream ab | bei AVCaptureSession-Ansatz eher einfacher als bei Android, da Sample Buffer direkt vorliegen                                                                                                                          |

### Priorisierungsvorschlag

1. **View-only-Mirroring** (Screen sehen, ggf. aufnehmen) – via `AVCaptureSession`/`CoreMediaIO`, technisch überschaubar und eher weniger Aufwand als der bestehende Android-Videopfad, da kein eigener NAL-Parser/Decoder nötig ist.
2. **Interaktion** (Touch, Keys, Clipboard, App-Install) als separates, deutlich riskanteres Folgeprojekt über `WebDriverAgent`/XCTest – eigenständige Infrastruktur (Code-Signing, Provisioning, Test-Runner-App pro Zielgerät), kein Feature-Zusatz auf der bestehenden Pipeline.

Diese zwei Stufen nicht als ein „iOS-Support"-Ticket planen, sondern getrennt bewerten.

## Visuelles Konzept: Fragment-Shader

Stand: 2026-09-29. Sammlung aus einer Konzeptsession – nichts davon ist implementiert. Ziel ist eine UI, die sich flüssig anfühlt und visuell trägt, ohne dass Effekte zum Selbstzweck werden. Leitlinie: Effekte hängen an echten Events (Frame kommt an, Tap geht raus, Fokus wechselt, Verbindung bricht) und bleiben unterhalb der Wahrnehmungsschwelle, solange nichts passiert.

### Architektur-Vorfrage: Zugriff auf die Mirror-Pixel

Der gespiegelte Screen ist ein `Texture`-Widget, gefüttert aus VideoToolbox über `CVPixelBuffer` (`macos/Runner/ScreenMirrorPlugin.swift`). Der resultierende TextureLayer landet **nicht** in einer aufgezeichneten `Picture`, d. h. `AnimatedSampler`/`toImageSync` (der übliche „Shader auf Widget-Subtree"-Weg) sieht dort schwarz. Vier Wege an die Pixel:

1. **Overlay-only** – Shader malt über/hinter der Texture, sampelt sie nie. Immer sicher, deckt die meisten Effekte ab.
2. **`ImageFilter.shader`** – in Flutter 3.47 vorhanden, Impeller-only, arbeitet auf Layer-Ebene statt auf Picture-Snapshots und erfasst daher vermutlich auch den TextureLayer. **Experiment 0**: Passthrough-Shader per `ImageFiltered` um `Texture` legen und auf Rot multiplizieren. Klappt das, gibt es Pixelzugriff ohne eine Zeile Swift. 15 Minuten Aufwand, höchster Informationsgewinn – vor allem anderen zu klären.
3. **Thumbnail-Seitenkanal** – native rechnet pro Frame ein 4×8-Blockraster aus Luma-/Chroma-Plane und schickt ~96 Floats bei 10 Hz. Basis für Ambilight.
4. **Freeze-Frame-Handoff** – `MirrorTextureSession.latestPixelBuffer` hält den letzten Frame bereits vor; ein `grabStill`-Call (~20 Zeilen Swift) liefert ein echtes `ui.Image`. An Transition-Grenzen (Close, Maximize, Disconnect) live gegen still tauschen, dann ist in diesen 300 ms alles möglich.

### Ideen nach UI-Bereich

- **Canvas-Hintergrund** – gedithertes Ambient-Gradient statt flacher `canvasColor`: Dither (±0.5/255) killt das Banding großer dunkler Flächen, dazu langsam driftende fbm-Wolken (~30 s Periode, ≤7 % Tint-Anteil), Vignette und Grain. Tint aus `macosTheme.primaryColor`, damit der Hintergrund die System-Akzentfarbe aufnimmt.
- **Ambilight je Device-Frame** – Blockfarben aus Weg 3 als weicher Lichtschein hinter dem Frame; ersetzt den statischen `BoxShadow` in `_frameDecoration`. Bestes Wow/Aufwand-Verhältnis. Ausbau: dieselben Lichter tönen den Canvas-Hintergrund an den Gridpositionen („Device Wall").
- **Frame-Chrome und Fokus** – SDF-Fokusring mit Verlauf entlang des Umfangs statt zweier `BoxShadow`s; Fokus-Ripple vom Klickpunkt; per SDF abgerundete Geräteecken plus optionalem Punch-Hole, damit die Spiegelung wie Hardware aussieht; dezenter Glass-Sheen unter dem Mauszeiger.
- **Connecting bis erster Frame** – Rauschfeld statt Pulse im Wartezustand, danach Noise-Dissolve über der Texture statt hartem Cut. Trigger ist der `textureId == null → id?`-Switch in `device_screen_mirror.dart`, kein Timer.
- **Interaktions-Feedback** – Tap-Ripples aus den bereits normalisierten Pointer-Koordinaten in `_PointerListener` (bis zu 8 als `vec3`-Array), Kometenschweif bei Drags, Glow-Impuls an der Rahmenkante pro gesendeter Taste. Funktional wertvoll: man sieht, dass die Eingabe rausging, bevor das Gerät reagiert.
- **Screenshot** – SDF-Iris-Shutter mit Bloom, leichter chromatischer Aberration und diagonalem Specular-Streak statt weißem Fade.
- **Verbindungsqualität** – Stale-Frame-Veil (kein Frame seit >500 ms → kriechendes Rausch-/Entsättigungsveil), Heartbeat-Beacon am `_StatusDot` nach echter Frame-Ankunft statt Timer, Latenz-Aurora im Fokusring.
- **Maximize** – animiertes `ImageFilter.blur`-Sigma über die volle Fensterfläche ist der teuerste Frame-Block der App. Sigma fixieren oder quantisieren und die fehlende Tiefe mit Shader-Scrim (Frostglas-Rauschen, radialer Spotlight, Randabdunklung) kompensieren.
- **Grid-Reflow und Close** – mit Freeze-Frame CRT-Power-Off oder Glitch-Dissolve. Unabhängig davon ist `Curves.easeInCubic` in `reflow_grid.dart` die falsche Kurve fürs Einlaufen; `easeOutCubic` oder Spring wirkt stärker als jeder Shader.
- **Sidebar** – Cursor-Spotlight auf `_AdbDeviceEntry`, Shockwave beim „Verbinden"-Klick, weicher Innenverlauf statt Flatfarbe auf der Icon-Kachel.
- **Leere Zustände** – langsames Plasma-/Radar-Feld hinter Icon und Text; leere Screens starrt man am längsten an.

### Voraussetzungen für „butter smooth"

Ruckelt die Basis, machen Shader es schlimmer. Drei Punkte unabhängig von jeder Optik:

- **`ScreenMirrorPlugin.register`** setzt den Chunk-Handler ohne TaskQueue – NAL-Parsing und `VTDecompressionSessionDecodeFrame` laufen für alle Geräte zusammen auf dem macOS-Main-Thread. `registrar.messenger.makeBackgroundTaskQueue()` an `setMessageHandlerOnChannel(taskQueue:)` ist ein Einzeiler mit großer Wirkung.
- **Videostrom über den UI-Isolate** – Socket-Read bis `NativeTextureChannel.sendChunk` erzeugt eine Kopie pro Chunk und damit GC-Druck genau dort, wo Frames flüssig bleiben sollen. Kandidat für ein Background-Isolate oder Verlagerung nach native.
- **Rebuild-Disziplin im `DeviceFrame`** – `_handleHoverChange` und `onFocusChange: (_) => setState(() {})` rebuilden den kompletten Frame-Subtree inklusive `LayoutBuilder` und `BlocProvider`-Ebene bei jedem Mausein- und -austritt. Für Hover, Fokus und Ripples `ValueNotifier` plus repaint-only Listener, dazu `RepaintBoundary` je Zelle.

### Umsetzung: Paket statt Streuung

Effekte gehören in ein eigenes, nicht veröffentlichtes Paket (`packages/shader_effects/`, analog zu `api_adb` und `app_logger`) mit generischen Primitiven – Shader-Uhr, `ShaderEffectsScope`, `AmbientBackdrop`, `SdfFocusRing`, `RippleOverlay`. Die Komposition (welche Farben, wo montiert, was ein „Licht" bedeutet) bleibt in der App; das Paket kennt die Synk-Domäne nicht. Widgets bekommen das `FragmentProgram` injiziert, statt Assets selbst zu laden – kein Asset-Coupling, trivial testbar.

Abgrenzungskriterium: **Ein Effekt gehört ins Paket, wenn sein Entfernen bedeutet, ein Wrapper-Widget zu löschen, und sonst nichts.** Braucht das Entfernen Eingriffe in Layout, State oder Datenfluss, ist es kein Effekt, sondern ein Feature (gilt für Ambilight und Stale-Frame-Veil) und gehört in eine `feat_*`-Struktur. Deren Daten – Frame-Zeitstempel, Latenz, Blockfarben – sind ohnehin für sich nützlich und sollten unabhängig von der Optik existieren.

Der praktische Hauptgewinn des Pakets ist ein `example/`-Playground mit Slidern für die Konstanten. Shader-Arbeit ist zu 90 % Feintuning; Light und Dark nebeneinander mit Reglern spart gegenüber „App starten, Gerät anstecken, hinschauen" Stunden.

Schalterdesign: kein `bool`, sondern `enum ShaderEffectLevel { off, subtle, full }` mit automatischer Degradation (`disableAnimations`, Fenster unfokussiert, Gerät maximiert, Shader-Ladefehler). Drei Regeln halten es nicht-invasiv: jedes Effekt-Widget nimmt ein `child` und ist bei `off` reiner Passthrough; der Aus-Zustand ist exakt der heutige Look, kein dritter; Degradation passiert zentral im Scope, nicht an den Aufrufstellen. Golden-Tests laufen immer mit `off`, GPU-abhängige Goldens sind eine Flake-Quelle. Das Level von Anfang an einbauen – einen Schalter nachträglich durch fünf Effekte zu fädeln ist teuer.

Weitere Perf-Disziplin: eine App-weite Shader-Uhr statt eines `AnimationController` pro Effekt, Repaint auf ~20 fps gedrosselt (Low-Frequency-Content sieht identisch aus), `CustomPainter(repaint:)` statt `setState`, `RepaintBoundary` um jede Shader-Fläche, Pause bei unfokussiertem Fenster (Dauerläufer-Tool auf Akku) und während eine maximierte Route steht – ein animierter Hintergrund zwingt den `BackdropFilter` sonst zum Neufiltern der ganzen Fensterfläche. Budget: < 1 ms GPU-Zeit für den Vollbild-Backdrop, messbar über die Impeller-GPU-Zeit in DevTools.

### Priorisierungsvorschlag

1. Experiment 0 (`ImageFilter.shader` über `Texture`) – verschiebt die Machbarkeitsgrenze aller folgenden Punkte. Parallel dazu Decoding vom Main-Thread holen.
2. Ohne Sampling machbar und mit großer Wirkung: Canvas-Backdrop mit Dither, Ambilight samt Device-Wall, SDF-Fokusring, Noise-Dissolve beim ersten Frame, Tap-Ripples.
3. Braucht Freeze-Frame oder mehr Feinarbeit: CRT-Power-Off beim Schließen, Shutter-Screenshot, Sidebar-Spotlight und Shockwave, Heartbeat-Beacon, Glass-Sheen, abgerundete Geräteecken.
4. Feinschliff: Stale-Frame-Veil, Latenz-Aurora, Plasma-Empty-States, Maximize-Scrim als Blur-Ersatz.

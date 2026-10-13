# Roadmap & Design Notes

> Internal planning notes (German). See the [README](../README.md) for the user-facing project overview.
> Plattform-Architektur und Umbauplan für neue Gerätetypen: [PLATFORM_ABSTRACTION.md](PLATFORM_ABSTRACTION.md).

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

> **Teil-Korrektur 2026-10-09:** Für Touch-/Key-Injection gilt der letzte Satz nicht mehr – Apple liefert diesen Kanal inzwischen selbst mit, ohne eigene Binary auf dem Gerät. Siehe [Input-Injection via CoreDevice-HID](#input-injection-via-coredevice-hid). Clipboard, Datei-Transfer und App-Install bleiben davon unberührt.

> **Teil-Korrektur 2026-10-10:** Dasselbe gilt für Bildschirm *und* Ton. CoreDevice bringt einen Medienstrom mit, den das Gerät selbst sendet – kabellos tragfähig und mit Systemton. Siehe [Kabellose Spiegelung und Audio via CoreDevice-Medienstrom](#kabellose-spiegelung-und-audio-via-coredevice-medienstrom). Damit bleibt als echte Plattformgrenze nur noch der App-Install.

### Vergleich Android (Ist-Zustand) vs. iOS (realistisch)

| Feature              | Android (jetzt)                            | iOS (realistisch)                                                                                                                                                                                                      |
| -------------------- | ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Geräte-Discovery     | `adb track-devices`                        | kein ADB-Äquivalent; `usbmuxd`-Protokoll (z. B. über `libimobiledevice`)                                                                                                                                               |
| Bildschirm-Mirroring | eigener Server streamt H264 über Socket    | **zwei Wege umgesetzt:** CoreDevice-Medienstrom (Gerät sendet HEVC per RTP, trägt auch kabellos und bringt Ton mit) mit `AVFoundation`/`CoreMediaIO` als Rückfall (captured Gerät als Kamera, USB-only, stumm)        |
| Audio-Forwarding     | dritter scrcpy-Socket, `audio_codec=raw`   | **umgesetzt** über einen zweiten CoreDevice-Medienstrom (`.audioSystemOutput`), AAC-ELD 48 kHz stereo                                                                                                                 |
| Touch-/Key-Injection | InputManager-Reflection im eigenen Server  | **Touch und Gesten umgesetzt** über CoreDevice-HID (`com.apple.coredevice.feature.remote.hid.digitizer`): Tap, Drag, Navigationsleiste als Kantenwische und Trackpad-Pinch, ohne Companion-App auf dem Gerät. Keys (`.hid.keyboard`), Hardware-Tasten (`.hid.button`) und Mausrad (`.hid.scroll`) hängen am selben Muster und sind ungeprüft – eigener Abschnitt unten |
| Clipboard-Sync       | Custom-Protokoll im eigenen Server         | **umgesetzt** über `devicectl device pasteboard` – `copy`/`paste` für Text; `monitor` und `sync-with-host` (bidirektional) bleiben als Option                                      |
| Datei-Transfer       | `adb push`                                 | `devicectl device copy` läuft, erreicht aber nur App-Container und Scratch-Bereiche – kein nutzersichtbares Ziel und damit kein Gegenstück zum Android-Feature (eigener Abschnitt unten)                      |
| App-Install          | `pm install`                               | `devicectl device install`, braucht aber gültig signierte/provisionierte IPA – kein freies Sideloading                                                                                                                  |
| Screenshot           | RPC an eigenen Server                      | **umgesetzt** über `devicectl device capture screenshot`; DDI-Verwaltung übernimmt `devicectl manage ddis`                                                                                                              |
| Recording            | `AVAssetWriter` zapft den Decode-Stream ab | bleibt `AVAssetWriter` am Sample-Buffer-Strom – `devicectl device capture screen-record` existiert, das Gerät bietet die Capability aber nicht an (eigener Abschnitt unten)                                              |

### Priorisierungsvorschlag

1. **Mirroring** – **erledigt, auf zwei Unterbauten.** Zuerst view-only über `AVCaptureSession`/`CoreMediaIO` (USB-only, stumm), inzwischen bevorzugt über den CoreDevice-Medienstrom: das Gerät sendet HEVC per RTP, trägt auch kabellos und bringt den Systemton mit. Die Capture-Session bleibt als Rückfall, weil sie jedes vertraute Gerät erreicht und keinen Developer Mode braucht. Eigener Abschnitt unten.
2. **Alles, was `devicectl` schon kann** – Screenshot und Clipboard-Sync sind erledigt. Datei-Transfer und Display-Infos waren der Rest und haben sich bei der Probe weitgehend aufgelöst, siehe eigener Abschnitt; dieser Punkt ist damit abgeschlossen. Shell-out auf ein CLI, also dasselbe Muster wie der ADB-Pfad (`connect_wirelessly_interactor.dart`, `ScrcpyServerLauncher`). Billigster Posten mit dem größten Sprung in der Feature-Tabelle und nach Punkt 1 als Nächstes dran.
3. **Input-Injection** über CoreDevice-HID – Touch und Gesten sind **erledigt** und in der App verdrahtet. Offen ist der Rest derselben Familie: Keys, Mausrad und Hardware-Tasten, jeweils am selben Muster und ohne Zugangsproblem. Eigener Abschnitt unten.
4. **App-Install** bleibt der teure Rest: `devicectl device install` existiert, scheitert aber an der signierten/provisionierten IPA. Daran ändert kein Unterbau etwas.

Diese Stufen nicht als ein „iOS-Support"-Ticket planen, sondern getrennt bewerten – sie liegen inzwischen auf drei verschiedenen Unterbauten.

### Umgesetzt via `devicectl` (Stand 2026-10-09)

#### Screenshot

Der iOS-Screenshot kommt jetzt aus `devicectl device capture screenshot` statt aus dem gespiegelten Frame. Neu dafür ist das Paket `api_devicectl` (`DevicectlApi` + `DevicectlProcessRunner`, Shell-out auf `/usr/bin/xcrun devicectl`) – dasselbe Muster wie `api_adb` und damit der Platz, an den Datei-Transfer und Display-Infos als Nächstes gehören.

- **Auflösung:** `devicectl` liefert den Framebuffer des Geräts, am iPhone 15 also 1179×2556 PNG. Der AVCaptureSession-Frame hing dagegen an der Skalierung der Capture-Session. Laufzeit rund 2,9 s pro Screenshot – spürbar, aber für einen Shutter-Klick vertretbar.
- **Geräte-Identifier:** `--device` nimmt die UDID, und die „USB Serial Number", die `IosDeviceDiscoveryPlugin` aus der IORegistry liest, *ist* bei iPhones die UDID. Die bestehende `DeviceId` geht also unverändert durch, ohne zweiten Identifier-Begriff im Code.
  **Nachtrag 2026-10-10:** derselbe Wert, aber nicht dieselbe Schreibweise. Die IORegistry liefert ihn ungetrennt (`000081200009555001C2601E`), CoreDevice schreibt ihn mit Bindestrich (`00008120-0009555001C2601E`). `devicectl` nimmt beide Formen an und verdeckt den Unterschied damit – wer selbst vergleicht, muss normalisieren (Bindestriche raus, lowercase). Das hat die HID-Integration einen Debug-Durchgang gekostet: das Gerät war da, hieß nur anders.
- **Fallback:** `devicectl` erreicht nur gepaarte Geräte mit aktiviertem Developer Mode, Mirroring dagegen jedes vertraute Gerät. Scheitert der Aufruf, fällt `IosDeviceAgent.captureScreenshot` auf den gespiegelten Frame zurück statt den Screenshot platzen zu lassen.

**Rotation geklärt (2026-10-09):** `devicectl` liefert den gedrehten Framebuffer, nicht stur Portrait. Mit einer App in Landscape kam der Screenshot am iPhone 15 als 2556×1179, und `devicectl device info displays` meldete dazu `currentOrientation: rot270` bei unverändertem `nativeOrientation: rot0` und `nativeSize: (1179, 2556)`. Screenshot und gespiegelter Frame laufen also nicht auseinander – kein Korrekturbedarf im Code.

Dabei gelernt, und für spätere Posten wichtig: *Geräte*-Orientierung (`devicectl device orientation get`, also der Lagesensor) und *Display*-Orientierung (`currentOrientation`, also der tatsächliche Framebuffer) sind zwei verschiedene Dinge. Ein ins Querformat gedrehtes Gerät, auf dem eine Portrait-only-App läuft, bleibt im Screenshot hochkant – richtig so, denn genau das zeigt der Schirm.

#### Clipboard-Sync

Läuft über `devicectl device pasteboard` und hängt an denselben Kürzeln wie bei Android: ⌘C holt die Geräte-Zwischenablage auf den Host, ⌘V schiebt die Host-Zwischenablage aufs Gerät. Dahinter `DevicectlApi.readPasteboard`/`writePasteboard` – `paste` liefert den Payload auf stdout, `copy` nimmt ihn auf stdin. Kein Temp-File, damit Zwischenablage-Inhalte nicht auf der Platte landen.

- **Neue Abstraktion:** `ClipboardAgent`, analog zu `ScreenCaptureAgent`, implementiert von `AndroidDeviceAgent` und `IosDeviceAgent`. Die Kürzel-Interception in `DeviceFrameRepositoryImpl.simulateKeyEvent` ist damit plattformfrei und verzweigt nicht mehr auf Android.
- **Für iOS der entscheidende Punkt:** ⌘C/⌘V werden auf dem Host abgefangen und *nicht* ans Gerät geschickt – bei Android war das schon so, für iOS gab es keinen anderen Weg. Clipboard-Sync funktioniert damit, ohne dass Punkt 3 geklärt ist.
  **Korrektur 2026-10-10:** „keine Key-Injection auf iOS" stimmt nicht mehr – `.hid.keyboard` ist da, nur ungeprüft (siehe unten). Am Clipboard-Entwurf ändert das nichts: die Kürzel gehören auf beiden Plattformen auf den Host abgefangen, weil sie eine Host-Aktion meinen und keinen Tastendruck.
- **Tempo:** rund 150 ms pro Richtung, also eine andere Größenordnung als der Screenshot. UTF-8 inklusive Emoji geht unverfälscht durch, beide Richtungen am Gerät verifiziert.
- **Nur Text:** ohne `--type` schreibt `devicectl` unter `public.utf8-plain-text`, `public.plain-text` und `public.text` zugleich und liest die Texttypen in Prioritätsreihenfolge. Bilder und Dateien auf der Zwischenablage sind damit nicht abgedeckt – `--type public.png` wäre der Hebel, braucht aber einen Begriff von Nicht-Text-Inhalten im Host-Code.
- **Leere Zwischenablage ist kein Fehler:** `paste` endet mit Exit-Code 0 und leerem stdout. Der Host-Clipboard wird dann nicht überschrieben, statt ihn zu leeren.

`pasteboard monitor` und `sync-with-host` wären der automatische Weg – bidirektional, ohne Kürzel. Beide laufen aber als Dauerprozess mit 300-s-Session-Timeout und würden die Host-Zwischenablage ungefragt überschreiben. Für einen Geräte-Mirror ist das explizite Kürzel die passendere Granularität; `sync-with-host` bleibt notiert, falls es doch automatisch laufen soll.

#### Recording

**Recording bleibt beim bestehenden Pfad.** `devicectl device capture screen-record` ist als Subcommand vorhanden, das Gerät meldet die Fähigkeit aber nicht:

```
ERROR: The capability "Screen Recording" is not supported by this device.
       CapabilityFeatureIdentifier = com.apple.coredevice.feature.screenrecording
```

Geprüft an iPhone 15 (iPhone15,4) mit iOS 26.6.2 (23G90) gegen `devicectl` 642.16: unter den 65 gemeldeten Capabilities fehlt `screenrecording`. Recording läuft deshalb weiter über `AVAssetWriter` am Mirror-Stream. Lehre für die nächsten Posten: die Subcommand-Liste des CLI sagt nur, was `devicectl` kann, nicht was *dieses* Gerät kann – maßgeblich ist die Capability-Liste aus `devicectl device info details`.

**Nachgeprüft auf iOS 27.0.1 (24A446), 2026-10-09:** unverändert. Weiterhin 65 Capabilities, weiterhin kein `screenrecording`, derselbe Fehler bei `screen-record`. Auch die HID- und Video-Capabilities sind Zeichen für Zeichen dieselben wie unter 26.6.2. Das ist also kein Bug einer 26.x-Version, sondern Absicht – ein iOS-Update ist kein Hebel für diesen Posten, und erneutes Nachprüfen bei künftigen Point-Releases lohnt nicht.

#### Kabellose Spiegelung und Audio via CoreDevice-Medienstrom

**Umgesetzt und am Gerät verifiziert (2026-10-10).** Das Gerät sendet seinen
Bildschirm und seinen Systemton selbst an den Mac, über denselben
CoreDevice-Tunnel, der auch kabellos trägt. Code und Reproduktionsschritte:
[`docs/spikes/ios-mediastream/`](spikes/ios-mediastream/README.md). Damit fällt
die letzte Zeile aus der Feature-Tabelle, die noch als Plattformgrenze galt –
Audio ist auf iOS **nur** so zu holen.

**Die Aufwandsschätzung von vorher war falsch, und zwar in beide Richtungen.**
Die alte Notiz nahm an, AVConference müsse als „zweites, deutlich größeres
privates Framework" angesteuert werden, weil DeviceHub es linkt und CoreDevice
nicht. Richtig ist:

- AVConference ist **Objective-C**, nicht Swift. Es braucht keine
  `.swiftinterface`-Rekonstruktion, sondern eine gewöhnliche
  Header-Deklaration, und alles ist per Laufzeit-Reflexion nachlesbar.
- Gebraucht wird davon **nur der Negotiator** – eine Klasse, fünf Methoden.
  CoreDevice liefert die Optionen dazu sogar selbst
  (`MediaStreamFunctions.getNegotiatorOptions(for:)`).
- Die „undurchsichtigen Blobs" sind nur Angebot und Antwort. Danach schickt das
  Gerät **rohes, unverschlüsseltes RTP** an eine Adresse, die man ihm nennt
  (`receiverIP`/`receiverPort` in der `StartRequest`). Die Verhandlung meldet
  SRTP-Cipher-Suite 0.
- Der Empfang braucht AVConference deshalb **gar nicht**. Video ist HEVC nach
  RFC 7798, Audio AAC-ELD 48 kHz stereo – beides mit VideoToolbox bzw.
  AudioConverter zu dekodieren, also derselbe Werkzeugkasten wie im
  Android-Pfad.

Der Versuch, stattdessen AVConferences eigene Empfangsseite zu benutzen
(`AVCVideoStream` plus `AVCVideoDataOutput`), ist eine Sackgasse und braucht
nicht wiederholt zu werden: ausserhalb des eigenen Prozesses kommen die
`nw_parameters` ohne Protokoll-Stack bei `avconferenced` an („Data mode 0
unrecognized"), und mit `kAVCMediaStreamOptionRunInProcess` baut der Strom
zwar, aber `AVCVideoDataOutput` scheitert, weil es die prozessübergreifende
Image-Queue braucht.

**Einbau.** `IosMediaStreamPlugin` liegt neben `IosMirrorPlugin` und beantwortet
dieselben Methodennamen; `IosMirrorTransport` ist die Naht dazwischen. Das
Repository bevorzugt den Medienstrom und fällt auf die Capture-Session zurück –
die erreicht jedes vertraute Gerät, braucht aber USB und hat keinen Ton. Audio
hängt an der neuen Abstraktion `AudioAgent`, die Android und iOS gemeinsam
implementieren; der Mute-Knopf in der Toolbar hing vorher an „ist Android" und
hängt jetzt an `supportsAudio`.

**Drei Fallen, die Zeit gekostet haben** (Details im Spike-README):

- `clientSessionID` und die `callID` müssen als **UUID** in die Optionen, nicht
  als String. Sonst antwortet das Gerät mit „Missing ClientName, CallID, or
  ClientSessionID", obwohl die Schlüsselnamen stimmen.
- **RTCP ist Pflicht.** Ohne Receiver Reports liest Apples Sender die Stille als
  zusammenbrechende Verbindung, fährt die Bitrate herunter – das Bild zerfällt
  sichtbar in Blöcke – und stellt schliesslich ein. Mit Reports hält die
  Bildrate bei 53–63 fps.
- **`timeout` in der `StartRequest` ist eine harte Frist, kein Idle-Timeout.**
  Die naheliegenden 30 s lassen die Spiegelung mitten im Betrieb nach einer
  halben Minute stehenbleiben. synk bittet um 24 Stunden.

**Verifiziert** am iPhone 15 mit iOS 27.0.1, ad-hoc signiert und ohne jedes
Entitlement: 1184×2576 bei 53–63 fps über 90 s ohne Paketverlust oder
Dekodierfehler, Speicher flach bei 47 MiB, und Audio mit echtem Ton
gegengeprüft (Spitzenamplitude 0,000 bei Stille, 0,825 während VoiceOver
sprach).

**Offen:** der kabellose Fall selbst. Alle Messungen liefen über einen
CoreDevice-Tunnel, dessen Unterbau zu diesem Zeitpunkt USB war. Der Code
unterscheidet das nicht – er nimmt die utun-Adresse, die CoreDevice
bereitstellt – aber gemessen ist es nicht. Ebenfalls offen: die Bitrate liegt
mit 0,7–2,5 Mbit/s deutlich unter der ausgehandelten Obergrenze von 6 Mbit/s.
Das ist Apples Ratensteuerung, nicht unsere Grenze;
`-[AVCMediaStreamNegotiator overrideMaxBandwidth:foveationIsSupported:]` wäre
der Hebel, falls die Qualität nicht reicht.

Die Capability `.audioOutput` bleibt kein Ersatz – ihr `AudioOutputProtocol`
steuert die Lautstärke *des Geräts*, es leitet keinen Ton zum Mac.

### Datei-Transfer und Display-Infos: Befund 2026-10-09

Der Rest von Punkt 2. Nach der Probe am Gerät ist der eine Posten etwas anderes als gedacht und der andere weitgehend überflüssig.

#### Datei-Transfer: kein Gegenstück zum Android-Feature

`devicectl device copy to` und `copy from` funktionieren, in beide Richtungen am iPhone 15 verifiziert. Der Haken ist nicht der Transport, sondern das Ziel: `--domain-type` kennt nur `temporary`, `appDataContainer`, `appGroupDataContainer` und `systemCrashLogs`.

- `temporary` – ein Scratch-Bereich je Client-Identifier. Funktioniert (Hin- und Rückweg getestet), ist auf dem Gerät aber für niemanden sichtbar. Also kein „Datei aufs Handy schicken".
- `appDataContainer` – nur bei entwicklersignierten Apps. Bei einer eigenen Dev-App kamen `Documents`, `Library` und `tmp` zurück; bei einer Systemapp (`com.apple.mobileslideshow`) bricht es mit `CoreDevice.ActionError error 3` ab.
- Ein `/sdcard/Download`-Äquivalent gibt es nicht. Das Android-Feature – Datei auf den Frame ziehen, sie liegt danach sichtbar auf dem Gerät – hat auf iOS **keine Entsprechung**, mit keinem Unterbau. Das ist Sandboxing, nicht ein fehlendes CLI.

Was stattdessen ginge, ist ein anderes Feature: ein Browser für die Container der entwicklersignierten Apps, mit Push und Pull. Nützlich zum Debuggen, aber eine eigene UI (App-Auswahl, Dateibaum) und nicht das, was in der Tabelle unter „Datei-Transfer" steht. Deshalb hier notiert statt gebaut – es ist eine Produktentscheidung, keine Fleißarbeit.

#### Display-Infos: vorhanden, aber überwiegend redundant

`devicectl device info displays` liefert je Display `bounds`, `nativeSize`, `pointScale`, `currentOrientation`, `nativeOrientation` und einen `--stream`-Modus, der bei jeder Änderung neu ausgibt. Am iPhone 15 erscheinen zwei Displays: das interne LCD und ein `Wireless` (2556×2556, `type: wireless`).

Für die App ist davon wenig neu. Die Bildschirmgröße kommt heute aus den Frame-Dimensionen der Capture-Session, und die tragen die Drehung bereits mit – genau das leistet `IosMirrorPlugin` seit der Orientierungs-Erkennung. Ein zusätzlicher Dauerprozess je Gerät für dieselbe Information wäre Aufwand ohne Gegenwert. Einen echten Nutzen hätte `info displays` nur dort, wo noch keine Capture-Session läuft – etwa um Auflösung und Lage schon vor dem Verbinden anzuzeigen.

### Input-Injection via CoreDevice-HID

Stand: 2026-10-09. Ausgelöst von der Beobachtung, dass der „Device Hub" in Xcode 27 iOS-Geräte nicht nur spiegelt, sondern per Gesten steuert. Der Unterbau dafür ist schon in **Xcode 26.6** installiert, in `/Library/Developer/PrivateFrameworks/CoreDevice.framework` (CoreDevice 518.33) – das Fehlende ist nicht die Fähigkeit, sondern ein aufrufbarer Zugang.

#### Gelöst: Touch und Gesten laufen am Gerät (2026-10-10)

**Der Zugang ist gefunden, und er trägt.** Ein lokal gebautes, ad-hoc signiertes CLI **ohne jedes Entitlement und ohne root** steuert das iPhone 15 (iOS 27.0.1) per Touch. Verifiziert sind Tap, Drag/Scroll im App-Inhalt, Edge-Swipe als Home-Geste und Zwei-Finger-Pinch. Code und Reproduktionsschritte: [`docs/spikes/ios-hid/`](spikes/ios-hid/README.md). Damit fällt der letzte Posten aus der Feature-Tabelle, der noch als Plattformgrenze galt – es ist keine mehr, sondern Integrationsarbeit.

**Der Weg war nicht Swift-ABI, sondern das Interface.** Der bisher angenommene Blocker 1 („`@_silgen_name` plus Protocol-Witness-Tables von Hand") war ein Umweg. Richtig ist: einen `.swiftinterface` für den benötigten Modulausschnitt schreiben, rekonstruiert aus den demangelten Export-Symbolen der Dylib, und ihn als `CoreDevice.swiftmodule/arm64-apple-macos.swiftinterface` in den Suchpfad legen. Danach ist `import CoreDevice` ein ganz normaler Import, und der Compiler erzeugt von sich aus dieselben Mangled Names und Dispatch-Thunk-Aufrufe wie Apples eigener Code.

Warum das stabiler ist, als es klingt: die Deklarationen müssen namens- und signaturgenau sein, aber **nicht vollständig und nicht layoutgenau**. Wir implementieren keines der Protokolle, sondern rufen nur über Dispatch-Thunks auf Instanzen auf, die aus der Dylib kommen; resiliente Typen werden ohnehin über Metadata angefasst. Ein Protokoll mit 20 Requirements darf im Stub mit zwei stehen. Und das Ganze ist mechanisch prüfbar statt geraten: stimmt eine Deklaration nicht, schlägt schon der Link fehl.

Der Aufrufpfad – derselbe, den DeviceHub nimmt:

```
CoreDeviceService.sharedConnection          // XPC zum Broker CoreDeviceService.xpc
  -> DeviceManager(serviceConnection:)
  -> awaitFullInitialization()
  -> devices[uuid]                          // RemoteDevice
  -> getImplementation(for: .hid.digitizer) // CoreDevice.IndigoHIDDigitizer
  -> send(pointOne:pointTwo:eventType:edge:target:)
```

Drei Details, an denen es sonst scheitert, jedes am Gerät erarbeitet:

- **Unit-Koordinaten, nicht Pixel.** `DigitizerPoint` will 0…1 relativ zum Framebuffer. Pixelwerte werden angenommen, quittiert und verpuffen – kein Fehler, keine Wirkung. Das passt zum `viewToUnitTransform` in DeviceKits `DigitizerState` (siehe unten).
- **`sendBarrier()` ist der Flush, nicht nur ein Abschluss.** Ohne Barriere nach *jedem* Event werden Zwischenpunkte zusammengefasst. Taps und System-Gesten kommen trotzdem durch, ein In-App-Drag aber nicht: die Liste scrollt schlicht nicht. Mit Barriere pro Event scrollt sie. Das war der eigentliche Stolperstein, nicht der Zugang.
- **Der Versand ist fire-and-forget.** Endet der Prozess direkt nach dem letzten `send`, kommt nichts an. Für die App irrelevant (Dauerprozess), für jedes CLI entscheidend.

**Wie DeviceHub es macht, und warum wir es anders machen.** `DeviceHub.app` ist nur eine 440-KB-Hülle; die Arbeit steckt in `DeviceKit.framework` (12 MB, Xcode 27). Dessen Importe zeigen den Weg exakt: `DeviceKit.DigitizerState.handleTouch(mouseEventType:viewLocation:viewToUnitTransform:viewBounds:edgeSwipeRegion:framebufferRect:locationIsInFramebuffer:)` übersetzt NSEvents in Unit-Punkte plus `DigitizerEdge`, wobei Edge-Swipes daran erkannt werden, dass der Zeiger *außerhalb* des Framebuffers startet und hineinzieht. Gesten sind also keine eigene API – es sind Touch-Sequenzen, und das `edge`-Feld ist das, was daraus eine Systemgeste macht.

Beim Transport weicht DeviceHub allerdings ab: für Touch nutzt es nicht `HIDDigitizer.send`, sondern baut host-seitig `IOHIDEventCreateDigitizerFingerEvent`-Events, filtert sie durch `UniversalHID.DigitizerFilter` zu `HIDReport`s und schickt sie über `UniversalHIDService.createService(descriptor:)` / `send(report:to:)` an ein virtuelles HID-Gerät auf dem iPhone. Tastatur, Buttons und Scroll gehen dagegen über die typisierten Capabilities (`HIDKeyboard.send`, `HIDButton.sendButton`, `HIDScroll.send`).

Für uns ist der Digitizer-Pfad der richtige: eine Methode statt Event-Konstruktion, Pinch direkt über `pointTwo`, und er läuft über dieselbe Capability (`com.apple.coredevice.feature.remote.hid.digitizer`), die das Gerät ohnehin meldet. Preis ist die Fingerzahl – `send` kennt genau zwei Punkte. Mehr als Pinch braucht den UniversalHID-Weg; für einen Geräte-Mirror ist das kein Verlust.

**Was damit mitkommt**, ohne weitere Recherche, weil es am selben Muster hängt: `.hid.keyboard` (Key-Injection statt Clipboard-Workaround), `.hid.button` (Home, Siri, Lautstärke, Power – also die Hardware-Button-Zeile aus der Vysor-Liste) und `.hid.scroll`. Und in derselben Konstruktion liegt `CoreDeviceMediaStreamSupport.MediaStreamSession.makeVideoStream(withConfiguration:fromRemoteDevice:)` – der Unterbau für kabelloses Mirroring, siehe Nebenbefund weiter oben.

#### Eingebaut: Touch und Gesten in der App (2026-10-10)

Der Spike ist verdrahtet. Ein verbundenes iPhone lässt sich im Rahmen bedienen wie ein Android-Gerät: Tap, Drag, Long-Press mit der Maus, die Navigationsleiste unter dem Rahmen (Zurück, Home, Übersicht) und Zwei-Finger-Zoom vom Trackpad.

**Der Schnitt.** `InteractionAgent` ist das Gegenstück zu `ClipboardAgent` und tut dasselbe: `AndroidDeviceAgent` und `IosDeviceAgent` implementieren ihn beide, und `DeviceFrameRepository` verzweigt nicht mehr auf die Plattform. Über denselben Weg ging auch der Weckruf dorthin, wo er hingehört – `KEYCODE_WAKEUP` beim Druck ist eine Android-Eigenart und steht jetzt im Android-Agent, nicht beim Aufrufer.

Dieselbe Aktion, zwei grundverschiedene Wege: `DeviceControlAction.home` ist auf Android ein Key-Event, auf iOS ein Wisch von der unteren Kante. Beides passt hinter eine Methode, weil der Aufrufer nur die Absicht kennt.

**Die Policy liegt in Dart, das Timing im Plugin.** `IosHidPlugin` kennt Punkte, Phasen und Kanten – aber keine Gesten; welche Bewegung ein Home-Wisch ist, steht in `ios_touch_gesture.dart` und ist damit testbar. Nativ bleibt nur, was dort bleiben muss: die Zwischenpunkte eines gescripteten Wischs, weil jeder eine eigene Barriere braucht und ein Umweg über den Method-Channel pro Punkt die Geste zerreißen würde.

**Kanten am Druckpunkt, und nur dort.** iOS liest das `edge`-Feld auf *jedem* Event einer Geste; der Agent legt es beim Druck fest und hält es bis zum Loslassen. Der Randstreifen, der dafür zählt, ist mit 2 % bewusst schmal: genau diesen Streifen behandelt iOS selbst als Gestenzone, ein echter Finger löst dort auch keinen Tap aus. Breiter gefasst würden Taps auf Tab-Bars zu Home-Gesten.

**Die UDID hat zwei Schreibweisen.** Die `DeviceId` der App kommt ungetrennt aus der IORegistry, `DeviceInfo.udid` kommt mit Bindestrich – derselbe Wert, und `devicectl` verdeckt den Unterschied, weil es beides annimmt. Der Abgleich im Plugin normalisiert deshalb beide Seiten, statt sie direkt zu vergleichen.

**Verfügbarkeit ist eine Geräte-Eigenschaft, keine Plattform-Eigenschaft.** `prepareInput` löst den Digitizer einmal beim Verbinden auf; danach ist jedes Event ein Aufruf ohne Wartezeit. Das Ergebnis trägt `DeviceConnection.ios` bis in die Oberfläche: ein Gerät ohne CoreDevice-Zugang bleibt gespiegelt und view-only, statt dass Eingaben ins Leere laufen. Mirroring erreicht jedes vertraute Gerät, CoreDevice nur gepaarte mit Developer Mode – die beiden decken sich nicht.

Dafür ist das grobe `supportsInteraction` der Oberfläche in zwei Begriffe zerfallen: `supportsInteraction` (Touch und Navigationsleiste) und `supportsDeviceActions` (Audio, Datei-Transfer, App-Installation, Standby – alles, was den Agent auf dem Gerät braucht, also Android).

**Auslieferung ohne Xcode bricht nichts.** CoreDevice ist mit `-weak_framework` gebunden und nur für arm64 – die Dylib gibt es ausschließlich als arm64e-Slice, ein x86_64-Link scheitert hart. Beides hängt an `macos/Runner/Configs/PrivateFrameworks.xcconfig`; das Release-Binary bleibt universal, der Intel-Slice referenziert CoreDevice gar nicht und hat die Injection per `#if arch(arm64)` wegkompiliert. Fehlt die Dylib, lösen ihre Symbole zu null auf, deshalb steht vor dem ersten Zugriff eine Existenzprüfung.

Die Interface-Stubs liegen jetzt in [`packages/synk_app/macos/PrivateFrameworkStubs/`](../packages/synk_app/macos/PrivateFrameworkStubs/README.md) – eine Kopie, die auch das Spike-CLI benutzt, das damit die Handprobe für sie ist. Neu darin gegenüber dem Spike ist `RemoteDevice.deviceInfo` aus dem Modul `CoreDeviceProtocols`: der Spike nahm einfach das erste Gerät, die App muss ihres anhand der UDID finden, und die steht in `DeviceInfo.udid`. Dass `CoreDeviceUtilities` mitgebunden werden muss, stimmte übrigens nie – es reicht `CoreDevice`.

**Zur „dauerhaften Session" von oben:** `DeviceManager` und Digitizer werden einmal aufgelöst und gehalten, wie vermutet.

**Korrektur 2026-10-10:** hier stand, eine `acquireDeviceUsageAssertion` brauche es nicht – „ohne sie läuft es unverändert". Das war der Trugschluss, der Touch und Tasten später reihenweise ausfallen ließ: es lief nur, solange *irgendwer sonst* das Gerät verbunden hielt (Xcode, DeviceHub, ein `devicectl`-Aufruf). Ohne eigene Assertion liefert `DeviceManager.devices` ein `RemoteDevice`, dessen Capability-Satz auf fünf Einträge zusammenschrumpft – `connectdevice`, `acquireusageassertion`, `unpairdevice`, `tags`, `default.user.credentials` – und jedes `getImplementation(for: .hid.*)` scheitert mit „not supported by this device". Die App hält jetzt selbst eine Assertion, siehe unten.

**Was offen bleibt:**

- **Querformat ist implementiert und am Gerät verifiziert (2026-10-11).** Der Digitizer liegt im nativen (Hochformat-)Framebuffer, unterhalb der Rotation. `IosHidPlugin.swift` rotiert `DigitizerPoint`/`DigitizerEdge` in der gemeinsamen `emit(...)`-Funktion zurück ins native Koordinatensystem, bevor sie beim Digitizer ankommen – ein Funnel für Touches, Pinches und Control-Swipes gleichermaßen. Die Transformationsformeln (`rot90`: `xn = yd, yn = 1-xd`; `rot270`: `xn = 1-yd, yn = xd`; `rot180`: `xn = 1-xd, yn = 1-yd`) sind per `hidpoc setorient` + `devicectl device capture screenshot` einzeln am echten Gerät nachgemessen, nicht nur aus `UIDeviceOrientation`-Semantiken hergeleitet.
  **Korrektur 2026-10-11:** die erste Fassung las die Orientierung über `.orientationControl` (den `OrientationControl`-Stub, also den Lagesensor). Das war der eigentliche Bug hinter „Touches nach einer Drehung falsch gemappt": der Lagesensor und die tatsächliche Digitizer-Rotation laufen auseinander, sobald der aktuelle Screen (z. B. der Home Screen auf kleineren iPhones) die gemeldete Sensor-Orientierung gar nicht unterstützt – siehe die Lehre oben zu `devicectl device orientation get` vs. `currentOrientation`. Die Quelle der Rotation ist deshalb jetzt `devicectl device info displays --json-output -` (`result.displays[].currentOrientation`, `rot0/90/180/270`) statt des Sensors; `.orientationControl` wird nicht mehr aufgelöst. Die Abfrage kostet ca. 200 ms und wird deshalb weiterhin nicht pro Touch, sondern nur gecacht und bei denselben zwei Ereignissen aufgefrischt: einmal direkt nach `prepareInput`, und erneut bei jeder `screenSizeChanges`-Emission.
- **Mausrad.** `.hid.scroll` (`HIDScroll.send(point:phase:momentum:target:)`) wäre der richtige Weg und hängt am selben Muster. Gezogen wird heute mit gedrückter Maustaste.
  **Korrektur 2026-10-10:** hier stand, `ScrollPoint`/`ScrollPhase`/`ScrollMomentum` exportierten keine eigenen Symbole und ihre Layouts wären zu erraten. Das war ein Suchfehler – die Member liegen in `CoreDeviceUtilities`. `ScrollPoint.init<A: BinaryFloatingPoint>(x:y:z:)`, `ScrollPhase.init(rawValue: UInt16)`, `ScrollMomentum.init(rawValue: UInt8)` und `ScrollTarget.init(rawValue: UInt)` sind alle da, und die `description`-Getter geben die Bedeutung der Rohwerte preis, statt sie raten zu lassen (`./hidpoc scrollinfo`):

  - `ScrollPhase` ist ein OptionSet: `began` = 1, `changed` = 2, `ended` = 4, `cancelled` = 8
  - `ScrollMomentum` ebenso: `continue` = 1, `start` = 2, `end` = 4
  - `ScrollTarget` kennt aber **nur zwei gültige Werte**: `digitalCrown` = 0 und `dial` = 1

  Dieser letzte Punkt ist der Haken: es gibt kein Bildschirm-Ziel. `.hid.scroll` sieht damit nach Apple Watch aus, nicht nach iPhone. Ein erster Versuch mit `digitalCrown` am iPhone 15 blieb wirkungslos – der Schirm war dabei allerdings aus, der Test ist also nicht gültig. **Offen und vor jeder Verdrahtung zu klären:** scrollt `.hid.scroll` mit Ziel `digitalCrown` oder `dial` an einem entsperrten iPhone überhaupt etwas? Wenn nicht, ist der Posten erledigt und Ziehen mit gedrückter Maustaste bleibt der Weg.
- **Tastatur** (`.hid.keyboard`) und **Hardware-Tasten** (`.hid.button`) sind deklariert, gebaut und gelinkt, aber **am Gerät noch nicht nachgewiesen** – siehe den Spike-Abschnitt unten. `HIDKeyboard.send(key: HIDKeyboardUsageCode, state: HIDButtonState)` und `HIDButton.sendCustomButton(usagePage: Int, usageCode: Int, state: HIDButtonState)`, beide mit `sendBarrier()` wie der Digitizer. Zu raten ist nichts: `HIDButtonState` exportiert seine Cases `down`/`up`, `HIDKeyboardUsageCode` hat `init(rawValue: UInt16)` und 152 benannte Konstanten (`keyboardA` … `keyboardSpacebar`). Die Usage-Codes für die Hardware-Tasten sind aus dem Framework ausgelesen, nicht geschätzt: Consumer-Page `0xc`, `sleepWake`/`power` = `0x30`, `home`/`menu` = `0x40`, `siri` = `0xcf`, `snapshot` = `0x65`, `volumeIncrement`/`volumeDecrement` = `0xe9`/`0xea`. Damit fiele auch `.standby`.
- **Der Dart-Pfad dafür steht (2026-10-10).** `InteractionAgent.simulateKeyEvent` nimmt ein plattformfreies `DeviceKeyEvent` (`LogicalKeyboardKey` plus Modifier-Set). Die Android-Übersetzung nach scrcpy-Keycode und `META_*`-Flags liegt in `scrcpy_key_input.dart` und wird vom `AndroidDeviceAgent` gerufen, nicht mehr vom Bloc. Für iOS ist damit nur noch die Abbildung auf HID-Usage-Codes zu schreiben – dieselbe Rolle, die `iosTouchPhaseOf` für Pointer spielt.
- **Vollständige HID-Familie laut Exports:** `.hid.digitizer` (benutzt), `.hid.keyboard`, `.hid.button`, `.hid.scroll`, `.hid.pointer` und `.hid.vendorDefined`. `.hid.pointer` ist neu in dieser Liste und interessant, weil `HIDPointer.send(button:phase:clicks:at:)` einen echten Mauszeiger meint statt eines Fingers – ungeprüft, ob iOS darauf anders reagiert als auf den Digitizer.
- **Pinch auf Android.** Das scrcpy-Protokoll könnte einen zweiten Pointer führen; verdrahtet ist es nicht, Trackpad-Zoom ist vorerst iOS-only.
- **Tempo im Blick behalten.** Ein Touch-Event kostet am iPhone 15 rund 5,4 ms (schlechtester Fall 8,6 ms), gemessen über 120 Events inklusive Barriere; die Auflösung des Digitizers einmalig 64 ms. Bei 60 Hz Mausbewegung ist das reichlich Luft, bei 120 Hz knapp – die Events laufen sequenziell und werden nicht verworfen, ein sehr schneller Drag könnte dem Zeiger also hinterherlaufen. Falls es sich so anfühlt, ist die Stelle bekannt: ein „latest wins" für `move` im `IosDeviceAgent`, während ein Versand noch läuft. Positionsangaben verlieren durch Auslassen nichts.
- **Gegenprobe in der CI.** Weiterhin offen und weiterhin ein Zweizeiler: die Stub-Deklarationen gegen die Dylib-Exports prüfen, damit ein Xcode-Major nicht erst im Build auffällt.

Der Rest dieses Abschnitts ist der Weg dorthin und bleibt als Begründung stehen.

**Nachgewiesen** (per `strings`/`nm` am Framework-Binary):

- Feature-IDs für echte Geräte, nicht Simulator: `com.apple.coredevice.feature.remote.hid.digitizer`, `.hid.button`, `.hid.scroll`, in 642.16 zusätzlich `.hid.vendordefined`, plus `.remote.universalhidservice` (in 518.33 noch `.remote.universalhid`); geräteseitiger Service `com.apple.dt.remote.hid`.
- Exportierte Swift-Protokolle:
  - `HIDDigitizer.send(pointOne:pointTwo:eventType:edge:target:)` – zwei Punkte, also Pinch/Zoom, plus `edge` für Edge-Swipes
  - `HIDPointer.send(button:phase:clicks:at:)` und `send(movedTo:)`
  - `HIDKeyboard.send(key:state:)` über `HIDUsageCode`
  - `HIDButton` mit `home`, `menu`, `siri`, `volumeIncrement`/`volumeDecrement`, `authorizeApplePay`, `watchSideButton`
  - `UniversalHIDServicePool.createDevice(type:descriptor:)` und `send(report:to:)` – rohe HID-Reports über ein virtuelles Gerät
  - `HIDGamepad`
- **Am Gerät bestätigt (2026-10-09):** `devicectl device info details` meldet für iPhone 15 die Capabilities `…remote.hid.digitizer`, `.hid.button`, `.hid.keyboard`, `.hid.scroll`, `.hid.vendordefined`, `.remote.universalhid` und `.remote.universalhidservice` – identisch unter iOS 26.6.2 und 27.0.1. Der Kanal ist also nicht nur im Framework vorhanden, sondern wird vom Gerät auch angeboten – offen bleibt allein der mac-seitige Zugang, nicht die Geräteseite.
- `IndigoHID*` ist die Simulator-Variante derselben Protokolle (Indigo ist das HID-Protokoll von CoreSimulator); die `remote.*`-Feature-IDs sind der Gerätepfad.
- `devicectl device orientation set` existiert schon heute. Gerätesteuerung ohne Companion-App ist also kein Novum, nur bisher auf Rotation beschränkt.
- Geräteseitig bedient den Kanal der Daemon `/usr/libexec/dthidd` (`com.apple.coredevice.dthidd`, aus den Platform-LaunchDaemons von CoreSimulator). Mac-seitig läuft `com.apple.CoreDevice.remotepairingd` als geladener Dienst – das ist der Tunnel.
- **Xcode 27 bestätigt den Stack.** `Xcode.app/Contents/Applications/DeviceHub.app` (Bundle-ID `com.apple.dt.Devices`, Version 27.0) linkt direkt gegen `/Library/Developer/PrivateFrameworks/CoreDevice.framework` und das neue `DeviceKit.framework` in `SharedFrameworks`, das `IOHIDEventCreateDigitizer` und Konsorten aufruft. Seine Settings-Keys (`…settings.section.interaction.keyboard`, `.interaction.audio.output`, `.session.keepalive`, `.privacy.secure.input`, `.disable.auto.start.live.device.view`) zeigen den Funktionsumfang: Live-View, Keyboard-Forwarding und Audio-Output in einem.

**Zwei Blocker, beide Zugang und nicht Machbarkeit:**

1. Kein `.swiftinterface` und kein Header im Framework – `import CoreDevice` geht nicht. Die Signaturen selbst zu deklarieren heißt, Swift-ABI mit `async`, Generics und Protocol-Witness-Tables per `@_silgen_name` nachzubauen; bricht bei jedem Xcode-Update.
2. Kein CLI zum Rausshellen – siehe Probe-Ergebnis unten, in Xcode 27 unverändert.

#### Gelöst: Keyboard, Hardware-Tasten – und die Ursache, warum HID reihenweise ausfiel (2026-10-10)

Am iPhone 15 verifiziert: `./hidpoc type hallo` schreibt in ein fokussiertes Textfeld, `./hidpoc button sleepWake` schaltet den Schirm aus. Damit sind `.hid.keyboard` und `.hid.button` nachgewiesen, nicht nur deklariert.

**Die eigentliche Ursache war eine fehlende Usage-Assertion.** Touch fiel zwischendurch komplett aus, und zwar mit derselben Meldung wie Keyboard und Button:

```
CoreDeviceError 1001 – The capability "HID Digitizer" is not supported by this device.
```

obwohl `devicectl device info details` alle HID-Identifier listet. Der Unified Log von CoreDevice zeigt, warum: im `DeviceStateSnapshot` stehen dann nur fünf `capabilityImplementations` – `connectdevice`, `acquireusageassertion`, `unpairdevice`, `tags`, `default.user.credentials`. Das ist der Satz eines **gepaarten, aber nicht verbundenen** Geräts. `devicectl` funktioniert trotzdem, weil es pro Aufruf selbst verbindet; synk und der Spike taten das nicht und liefen nur, solange zufällig jemand anders die Verbindung hielt.

Die Gegenprobe ist eindeutig: ein nebenher laufendes `devicectl device info processes` genügt, und dieselbe Probe meldet `digitizer: ok, keyboard: ok, button: ok`.

Der richtige Weg ist `RemoteDevice.acquireDeviceUsageAssertion(withReason:options:)`, die zurückgegebene `DeviceUsageAssertion` über die Lebensdauer der Sitzung halten und am Ende `releaseAssertion()`. Mit eigener Assertion und ohne fremde Hilfe lösen die Capabilities auf. `IosHidPlugin` hält sie jetzt je Gerät neben dem Digitizer und gibt sie in `release(udid:)` wieder frei.

**Zwei übertragbare Lehren:**

- „not supported by this device" von CoreDevice heißt oft **„gerade nicht verbunden"**. Gegenprobe vor jeder Capability-Jagd: scheitert der nachweislich funktionierende Digitizer genauso, liegt es an der Verbindung.
- Die **Member der Werttypen liegen in `CoreDeviceUtilities`**, das CoreDevice per `LC_REEXPORT_DYLIB` reexportiert – die Protokolle und Capabilities stehen in CoreDevice selbst. Wer nur das Haupt-Binary durchsucht, hält Layouts für ungeklärt, die längst deklariert vorliegen. Deshalb linkt `DigitizerPoint(x:y:)` seit jeher. Konkret gedeckt: `HIDButtonState` (RawRepresentable über `UInt8`, Cases `down`/`up`), `HIDKeyboardUsageCode` (`init(rawValue: UInt16)` plus 152 benannte Konstanten) und die Scroll-Typen.

Dritte Kleinigkeit für den Stub: Member, für die es **keinen Dispatch-Thunk** gibt – hier `acquireDeviceUsageAssertion` und `DeviceUsageAssertion.identifier` – müssen `final` deklariert werden, sonst sucht der Linker einen Thunk, den es nicht gibt.

Die Usage-Codes für die Hardware-Tasten liest `./hidpoc pages` aus dem Framework statt sie zu schätzen: Consumer-Page `0xc`, `sleepWake`/`power` = `0x30`, `home`/`menu` = `0x40`, `siri` = `0xcf`, `snapshot` = `0x65`, `volumeIncrement`/`volumeDecrement` = `0xe9`/`0xea`. **Standby ist seitdem eingebaut.** `IosHidPlugin` löst `.hid.button` neben Digitizer und Tastatur auf und bietet `pressButton(usagePage:usageCode:)`, das down/hold/up nativ scriptet – dieselbe Begründung wie beim Wisch. `iosButtonForControlAction` in `ios_hardware_button.dart` bildet `DeviceControlAction.standby` auf Consumer `0xc`/`0x30` ab; `IosDeviceAgent.simulateControlAction` nimmt erst den Wisch, sonst die Hardware-Taste. In der Oberfläche hängt „Standby" jetzt an `supportsInteraction` statt an `supportsDeviceActions` – es ist eine Eingabe, keine Agent-Aktion –, während APK-Installation und Datei-Transfer weiter Android-only bleiben.

**Tastatur ist seitdem eingebaut.** `IosHidPlugin` löst `.hid.keyboard` neben dem Digitizer auf und bietet `sendKey(usage:isDown:)`; `iosKeyUsageOf` in `ios_key_input.dart` bildet `LogicalKeyboardKey` auf HID-Usage-Codes ab – das iOS-Gegenstück zu `scrcpyKeyCodeOf`. Modifier brauchen dabei kein Gegenstück zu Androids `metaState`: HID kennt sie als eigene Tasten (`0xe0`–`0xe7`), und da der Host sie ohnehin als eigene Key-Events schickt, hält das Gerät den Zustand selbst. Gibt ein Gerät den Digitizer her, aber keine Tastatur, werden Tastendrücke still verworfen statt pro Anschlag eine Fehlermeldung zu erzeugen.

#### Entitlement-Frage beantwortet: nein, es braucht keins (2026-10-09)

Das war der Punkt, an dem die Machbarkeit hing. **Der Mac-seitige Aufrufer braucht kein Entitlement.** Die bisherige Vermutung – DeviceHub.app linkt `ServiceManagement`, also wohl ein privilegierter Helper – ist widerlegt.

Wie der Stack tatsächlich gebaut ist: die Privilegien sitzen nicht beim Aufrufer, sondern beim Broker. `CoreDeviceService.xpc` (aus CoreDevice.framework, läuft als normaler Nutzer-Job, nicht als root) trägt die ganze Sammlung – darunter `com.apple.private.CoreDevice.hid`, `.canAccessPasteboard`, `.canViewDeviceDisplay`, `.canTransferFilesToDevice`, `.devicecontrol`. Clients reden per XPC mit ihm.

Belege, dass dieser Broker seine Clients **nicht** autorisiert:

- Kein einziges Peer-Prüfsymbol in der gesamten Kette. `CoreDevice`, `CoreDeviceInternal`, `CoreDeviceUtilities`, `CoreDeviceService` und `remotepairingd` importieren zusammen 0× `SecTaskCreateWithAuditToken`, 0× `SecCodeCheckValidity`, 0× `xpc_connection_set_peer_code_signing_requirement`.
- Die einzige Entitlement-Maschinerie überhaupt ist ein `SecTaskCreateFromSelf` in `CoreDeviceUtilities` – also ein Prozess, der sich *selbst* prüft, nicht einen Gegenüber. Die einzigen Entitlement-Namen, die als Strings vorkommen, sind `takeDeviceSysdiagnose` und `obtainContainerAccess`. Für HID existiert kein solcher String.
- **Der stärkste Beleg:** das echte `devicectl`-Binary (`…/CoreDevice.framework/Versions/A/Resources/bin/devicectl`; der zsh-Wrapper in `Developer/usr/bin` ist nur ein Trampolin) trägt genau drei Entitlements – `takeDeviceSysdiagnose`, `com.apple.private.sysdiagnose`, `allow-conferencing`. Kein HID, kein Pasteboard, kein `devicecontrol`, kein Datei-Transfer. Trotzdem macht es all das. Ein Client-Gate kann es also nicht geben, sonst würde `devicectl` an sich selbst scheitern.
- `com.apple.private.coredevice.client` steht zwar auf DeviceHub.app, wird aber nirgends abgefragt; der einzige String-Treffer in CoreDevice ist ein Dispatch-Queue-Label (`com.apple.dt.coredevice.ClientManager.client.`), kein Entitlement-Lookup.
- Sysdiagnose ist die Ausnahme, die die Regel bestätigt: der einzige Pfad mit echtem Gate ist auch der einzige, für den `devicectl` ein Entitlement mitbringt.

Empirisch gegengeprüft: ein lokal gebautes, ad-hoc signiertes Binary **mit Hardened Runtime und ohne jedes Entitlement** kann `CoreDevice.framework` per `dlopen` laden und `HIDDigitizer.send(pointOne:pointTwo:eventType:edge:target:)` per `dlsym` auflösen. Library Validation steht dem nicht im Weg, weil das Framework Apple-signiert ist.

Ein Detail, das nicht verwechselt werden darf: DeviceHub.app hat zusätzlich `com.apple.private.hid.client.event-filter`, `.event-monitor` und TCC-`kTCCServicePostEvent`/`kTCCServiceListenEvent`. Das sind **Host**-Entitlements – fürs Abgreifen und Erzeugen von Eingaben auf dem Mac –, nicht für den Geräte-HID-Kanal. Wir brauchen sie nicht: unsere Key- und Pointer-Events kommen ohnehin aus dem eigenen Fenster, genau wie im Android-Pfad.

**Damit bleibt von den zwei Blockern nur noch Blocker 1.** Und der ist bestätigt: `nm` findet 0 ObjC-Klassen in CoreDevice, das Framework ist reines Swift. Die Symbole sind exportiert und auflösbar – `HIDDigitizer.send` ist eine Protocol-Extension-Methode (`PAAE`), der Aufruf braucht also nicht nur das Symbol, sondern eine konforme Instanz aus einem Device-Objekt. Das ist die eigentliche Arbeit, nicht das Finden des Symbols.

**Offen bleibt** nur noch die Geräteseite: ob Developer Mode plus Trust-Pairing genügt. Die Capability-Liste des Geräts meldet die HID-Features (siehe oben), was dafür spricht.

#### Probe-Ergebnis Xcode 27: Input nein, der Rest ja (2026-10-09)

**Für Input negativ, für den Rest überraschend positiv.** Geprüft gegen das installierte `devicectl` 642.16 (`xcrun devicectl device --help`), also autoritativ und nicht mehr über Binary-Strings.

Kein HID: es gibt in 642.16 keinen Subcommand für Touch, Keys oder Scroll. `simulate` deckt nur `location`, `statusBar` und `biometrics` ab; die Treffer auf `tap`, `gesture` und `input` in den Strings sind Hilfetexte („tap each configuration profile", VoiceOver-Beschreibung, Audio-Input-Gerät). Auch `devicectl manage` hat nur `ddis`, `loggingProfile`, `pair`, `unpair`. Damit bleibt Input die private API, und Blocker 1 gilt unverändert: weder CoreDevice 642.16 noch `DeviceKit.framework` haben Header oder `.swiftinterface`.

Dafür kann 642.16 außerhalb von Input weit mehr als 518.33 – und mehr, als diese Notizen vorher annahmen:

- `device pasteboard` – `copy`, `paste`, `info`, `monitor`, `transfer`, `sync-with-host`
- `device capture` – `screenshot`, `screen-record`
- `device info` – `displays`, `files`, `apps`, `processes`, `lockState`, `audio`, `appIcon`, `ddiServices`, `details`
- `device settings` – `appearance`, `audio`, `biometrics`, `voiceover`, `reset`
- dazu `appResize`, `motion`, `pairings`, `profile`, `rename`

> **Methodik-Warnung:** Eine erste Runde dieses Checks lief über die Paket-Payload (`pkgutil --expand-full XcodeSystemResources.pkg`) plus `grep -ao`, weil CoreDevice noch nicht installiert und ohne akzeptierte Lizenz auch `strings`/`nm`/`otool` als CLT-Shims blockiert waren. Das hat die HID-Aussage korrekt ergeben, aber die Subcommand-Liste **massiv unterschätzt** – `pasteboard` und `capture` fehlten komplett, woraus hier fälschlich ein „Clipboard nur über WDA" abgeleitet wurde. Swift-ArgumentParser-Kommandonamen sind per String-Grep nicht zuverlässig zu finden. Für Feature-Inventuren gilt: `--help` gegen die installierte Version, sonst nicht.

#### Bewertung der verbleibenden Wege

| Weg                                                          | Kosten                                         | Haltbarkeit                                           |
| ------------------------------------------------------------ | ---------------------------------------------- | ----------------------------------------------------- |
| ~~`devicectl`-Subcommand~~                                   | –                                              | **ausgeschlossen**, existiert in 642.16 nicht         |
| RemoteXPC-Tunnel selbst sprechen (`com.apple.dt.remote.hid`) | hoch – Tunnel-Aufbau braucht root              | Xcode-unabhängig, am ehesten langlebig                |
| ~~CoreDevice per `dlopen` plus Swift-ABI reversen~~          | –                                              | **überholt** durch den Stub-`.swiftinterface`         |
| **Stub-`.swiftinterface` plus normaler Link** (umgesetzt)    | niedrig – rund 90 Zeilen Deklarationen, am Gerät verifiziert | bricht potenziell pro Xcode-Major, aber zur *Build*-Zeit |
| `WebDriverAgent`/XCTest                                      | hoch – Signing, Provisioning, Runner pro Gerät | unabhängig von Apples Privat-APIs                     |

Die Tabelle hat sich mit dem Spike aufgelöst. Der `dlopen`-Weg war nie nötig: statt die ABI von Hand nachzubilden, reicht es, die Signaturen zu deklarieren und den Compiler die ABI erzeugen zu lassen. Das ist derselbe Zugang, nur ohne den Handarbeitsanteil, der ihn teuer gemacht hätte – und es kostet damit deutlich weniger als vorher veranschlagt.

Der RemoteXPC-Weg bleibt theoretisch der langlebigste (Xcode-unabhängig, `dthidd` als benanntes Gegenstück), ist jetzt aber schlecht begründbar: er braucht root und ein eigenes Infrastrukturprojekt, um etwas zu ersetzen, das bereits läuft. Realistisch wird er erst interessant, falls Apple den Stub einmal unreparierbar bricht oder synk ohne Xcode-Installation auskommen soll. Bis dahin ist er notiert, nicht geplant.

WDA ist für reinen Input die schlechteste der Optionen und wird durch `devicectl` auch für Clipboard nicht mehr gebraucht; als Begründung taugt es nur noch für App-Install, und dort ist der Blocker die Signatur, nicht der Transportweg.

**Nächster Schritt:** nicht mehr Machbarkeit, sondern Einbau – native Session-Klasse plus plattformfreie Pointer-Abstraktion, siehe die offenen Punkte unter „Gelöst: Touch und Gesten laufen am Gerät".

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

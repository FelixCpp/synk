# Nutzer-Feedback

> Gesammelte Rezensionen und Rückmeldungen zur App. Status pro Punkt: offen / in Arbeit / erledigt / verworfen.

## Rezensionen 2026-11-11 (nach v0.1.3)

### 1. Aufnahme im Finder anzeigen

- **Status:** erledigt
- **Feedback:** Screenshot/Screenrecording nach der Aufnahme direkt im Finder anzeigen können (vielleicht per Klick auf die Preview).
- **Ist-Zustand:** Ein Klick auf die Preview-Kachel öffnet die Datei im Standard-Viewer (`SystemFileOpener` → `open <datei>`).
- **Umsetzung:** Der schwebende Kachelstapel wurde durch eine Liste „AUFNAHMEN“ unten rechts ersetzt (`ScreenCapturePreviewList`). Pro Zeile: kleine Vorschau, Gerätename, Screenshot/Video und drei stets sichtbare Buttons – im Finder zeigen (`open -R`), in den Papierkorb legen (`trash`) und aus der Liste entfernen. Klick auf die Zeile öffnet die Aufnahme im Standard-Viewer.

### 2. Gerätegröße verändern

- **Status:** offen – Detailbesprechung steht aus
- **Feedback:** Die Größe des gespiegelten Geräts soll sich verändern lassen.
- **Notizen:** Große Änderung. Berührt `SynkTheme.deviceFrameSizeFor`, das `ReflowGrid` und die vertagte Idee „Freier Drag-Space / eigenes Fenster pro Gerät“ aus der [ROADMAP](ROADMAP.md#vertagte-ideen).

### 3. Tastatursymbol auf dem DeviceFrame entfernen

- **Status:** erledigt
- **Feedback:** Das Tastatursymbol (`_KeyboardTargetBadge` in `device_screen_mirror.dart`) ist überflüssig, weil die Border den Fokus schon anzeigt. Die Border selbst ist aber vermutlich auch noch nicht optimal.
- **Umsetzung:** Badge entfernt. `SynkUiCard(focused: true)` zeichnet jetzt zusätzlich einen 3px-Fokusring außen in der Akzentfarbe (45 % Deckkraft), der beim Fokuswechsel ein- und ausblendet.

### 4. Zielpfad nach Dateiübertragung auf Android anzeigen

- **Status:** erledigt
- **Feedback:** Nach der Übertragung einer Datei auf ein Android-Gerät soll der Pfad angezeigt werden, damit man weiß, wo die Datei liegt.
- **Ist-Zustand:** Dateien landen fest in `/sdcard/Download` (`adb_file_transfer.dart`), die Rückmeldung (`FileTransferOutcome`) enthält nur den Dateinamen.
- **Umsetzung:** `DeviceFileTransfer.pushFile` liefert den Zielpfad, `FileTransferOutcome.destination` trägt ihn bis in die Benachrichtigung: „Datei auf Gerät übertragen: /sdcard/Download/<datei>“. Danach meldet Synk die Datei über scrcpys `SCAN_FILE` (Control-Message 22) beim MediaStore an. So taucht sie sofort in Galerie und Dateien-App auf, statt erst nach dem nächsten Medien-Scan.

### 5. Bug: Mirroring eingefroren nach erneutem Anstecken

- **Status:** vermutlich behoben – Test am echten Gerät steht aus
- **Feedback:** Nach dem Ziehen des Kabels und erneutem Anschließen funktionieren die Interaktionen nicht mehr und das Mirroring ist eingefroren.
- **Ursache:** `DeviceConnectionsFeatureImpl` hat die Sitzung eines abgezogenen Geräts nie beendet. Beim Wiedereinstecken galt das Gerät weiter als verbunden, und der Frame hing wieder an der alten, toten Sitzung (scrcpy-Sockets bzw. Capture-Session weg).
- **Umsetzung:** siehe Punkt 6.

### 6. Bug: Aufnahme lässt sich nach beendeter Übertragung nicht mehr beenden

- **Status:** behoben – Test am echten Gerät steht aus
- **Feedback:** Wird die Übertragung während einer Bildschirmaufnahme beendet, lässt sich nach dem Wiederverbinden zwar eine Aufnahme starten, aber nicht mehr beenden („Die Aufnahme ließ sich nicht beenden“).
- **Ursachen:**
  - Abgezogene Geräte behielten ihre Sitzung (Punkt 5), samt der darin laufenden Aufnahme.
  - Das Aufräumen einer Sitzung brach beim ersten fehlschlagenden Schritt ab, z. B. wenn adb das Gerät nicht mehr erreicht. Spiegel und Aufnahme wurden dann nie beendet.
  - Schlug das Beenden fehl, blieb der Bloc auf „nimmt auf“ stehen, obwohl die native Seite schon zurückgesetzt war. Jeder weitere Versuch scheiterte erneut.
  - Der Aufnahme-Status lebte nur im Bloc und im kurzlebigen Feature, nicht in der Sitzung. Ein neu gebauter Frame (z. B. maximiert) wusste nichts von einer laufenden Aufnahme.
- **Umsetzung:**
  - Ein abgezogenes Gerät verliert sofort seine Sitzung. Eine Sitzung, die erst nach dem Abziehen fertig aufgebaut ist, wird gleich wieder verworfen.
  - Sitzungen räumen über `tearDownEach` jeden Schritt auf, auch wenn ein früherer fehlschlägt. Der Spiegel samt Aufnahme wird zuerst beendet.
  - Natively wird eine abgebrochene Aufnahme verworfen und ihre halbe Datei gelöscht.
  - `DeviceScreenCapture.recordingPath` hält den Aufnahme-Status pro Sitzung. Der Bloc startet mit diesem Stand und gibt „nimmt auf“ auch dann frei, wenn das Beenden fehlschlägt.
- **Nachtrag – eigentliche Ursache der Fehlermeldung (nur Android):** Eine Aufnahme bei stillstehendem Bildschirm schlug immer fehl, unabhängig vom Trennen. Der Recorder wartet auf einen Keyframe, und scrcpy liefert bei unverändertem Bild keine neuen Frames. Ohne Keyframe bis zum Stopp ist die Datei leer („Die Aufnahme enthielt kein Bild …“).
  - Beim Start der Aufnahme fordert Synk über scrcpys `RESET_VIDEO` (Control-Message 17) sofort einen frischen Keyframe an (`VideoInteractionLayer`).
  - Beim Stopp endet die Aufnahme zur Stopp-Zeit (`endSession`), sodass auch ein Standbild die volle Länge hat.
  - iOS ist nicht betroffen: Dort beginnt die Aufnahme mit dem nächsten beliebigen Frame.

### 7. Gerät drehen

- **Status:** erledigt
- **Feedback:** Die Geräte-Rotation lässt sich über Synk nicht ändern. Vysor, der Device-Viewer von Android Studio und Device Hub haben dafür Buttons.
- **Ist-Zustand:** Synk zeigte nur die Rotation, die das Gerät selbst meldete (siehe [ROADMAP](ROADMAP.md), „Kleinere Lücken“).
- **Umsetzung:** Neuer Button „Gerät drehen“ in der Toolbar, sichtbar bei jedem bedienbaren Gerät. Er wechselt zwischen Hoch- und Querformat (`DeviceInteraction.rotate`). Die Richtung ergibt sich aus dem gespiegelten Bild: Querformat → Hochformat, sonst Querformat (gegen den Uhrzeigersinn).
  - iOS: `devicectl device orientation set` überschreibt den Lagesensor (`portrait` bzw. `landscapeLeft`). Am iPhone 15 geprüft: Die Drehung greift sofort (`rot270`/`rot90`/`rot0`) und bleibt stehen.
  - Android: `AdbRotation` schaltet per `settings put system accelerometer_rotation 0` die automatische Drehung aus und setzt `user_rotation` auf 0 bzw. 1. Den alten Wert von `accelerometer_rotation` stellt die Sitzung beim Beenden wieder her. Läuft auf allen Android-Versionen.
  - Grenzen: Apps, die nur Hochformat können, drehen nicht mit, so wie beim echten Drehen. Auf dem iPhone-Homescreen bleibt das Bild deshalb hochkant. Es gibt nur Hoch-/Querformat-Umschalten, keine 180°-Drehung.
- **Nachtrag – erster Android-Versuch verworfen:** Zuerst lief die Drehung über scrcpys `ROTATE_DEVICE` (Control-Message 11). Der Server fixiert die Rotation, gibt sie aber gleich wieder frei (`thawRotation`), wenn die automatische Drehung an war. Dann übernimmt sofort der Lagesensor: Das Gerät drehte und sprang nach unter einer Sekunde zurück. Meldete der Sensor gerade Querformat, passierte gar nichts. Am Pixel 6 (Android 16) nachgestellt.

# Stub-Interfaces für Apples private CoreDevice-Frameworks

`CoreDevice.framework` und `CoreDeviceUtilities.framework` liegen unter
`/Library/Developer/PrivateFrameworks` (von Xcode installiert), sind reines Swift
und bringen weder Header noch `.swiftinterface` mit – also nicht importierbar.

Die Dateien hier deklarieren **den Ausschnitt, den synk braucht**, so wie Apple ihn
deklariert hat: rekonstruiert aus den demangelten Export-Symbolen der Dylibs
(`dyld_info -exports … | swift demangle`). Daraus erzeugt der Swift-Compiler dieselben
Mangled Names und Dispatch-Thunk-Aufrufe wie Apples eigener Code; der Linker bindet
gegen die echten Dylibs. Nachgebaut wird also das *Interface*, nicht die ABI.

Deshalb gilt:

- Die Deklarationen müssen **namens- und signaturgenau** sein, aber weder vollständig
  noch layoutgenau – synk implementiert keines der Protokolle, sondern ruft nur über
  Dispatch-Thunks auf fremden Instanzen auf.
- Eine falsche Deklaration ist **ein Link-Fehler**, kein Laufzeitproblem: der Build
  schlägt fehl, sobald ein Symbol nicht existiert. Das ist die eingebaute Gegenprobe.
- Gebunden wird mit `-weak_framework` (siehe `Runner/Configs/PrivateFrameworks.xcconfig`),
  damit die App auch ohne installiertes Xcode startet. Vor dem ersten Zugriff prüft
  `IosHidPlugin.isCoreDeviceAvailable`, ob die Dylib da ist.
- Alle Build-Settings dafür sind auf `[arch=arm64]` beschränkt: CoreDevice liegt nur als
  arm64e-Slice vor und erst ab macOS 14, ein x86_64-Link scheitert hart. So bleibt ein
  Intel-Build baubar – dort ist die Injection per `#if arch(arm64)` abgeschaltet.

Haltbarkeit: der Stub bricht potenziell mit jedem Xcode-Major – dann aber zur Build-Zeit
und mit dem fehlenden Symbol im Fehlertext. Hintergrund und Geräte-Nachweis stehen in
`docs/spikes/ios-hid/` und in `docs/ROADMAP.md`.

Gebaut und am Gerät verifiziert gegen CoreDevice 642.16 (Xcode 27).

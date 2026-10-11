# Spike: Touch- und Gesten-Injection auf iOS via CoreDevice-HID

Stand 2026-10-10. Lauffähiger Nachweis, dass sich ein physisches iPhone ohne
Companion-App, ohne Entitlement und ohne root per Touch steuern lässt. Hintergrund,
Bewertung und nächste Schritte stehen in [../../ROADMAP.md](../../ROADMAP.md),
Abschnitt „Input-Injection via CoreDevice-HID".

Inzwischen ist das in der App eingebaut. Die Interface-Stubs liegen deshalb nicht mehr
hier, sondern dort, wo die App sie benutzt:
[`packages/synk_app/macos/PrivateFrameworkStubs/`](../../../packages/synk_app/macos/PrivateFrameworkStubs/README.md).
Dieses CLI baut gegen dieselbe Kopie und ist damit die Handprobe für sie – wenn
`./build.sh` durchläuft und ein Tap ankommt, trägt der Stub auch in der App.
Dasselbe Muster für Bildschirm und Ton steht in
[`../ios-mediastream/`](../ios-mediastream/README.md).

```sh
./build.sh
./hidpoc tap 0.5 0.5                  # Tap, Unit-Koordinaten
./hidpoc drag 0.5 0.8 0.5 0.3 none    # Scrollen im App-Inhalt
./hidpoc drag 0.5 1.0 0.5 0.35 bottom # Home-Geste (Edge-Swipe von unten)
./hidpoc pinch 0.5 0.5 0.06 0.33      # Zwei-Finger-Pinch

./hidpoc probe                        # Capabilities auflösen, ohne etwas zu senden
./hidpoc assert                       # dasselbe, aber mit eigener Usage-Assertion
./hidpoc pages                        # Usage-Codes aus dem Framework auslesen
./hidpoc scrollinfo                   # ScrollPhase/-Momentum/-Target entschluesseln
./hidpoc scroll -300                  # Mausrad, Ziel 0 = digitalCrown, 1 = dial
./hidpoc button sleepWake             # Standby-Taste (Consumer 0xc/0x30)
./hidpoc rawbutton 0xc 0xe9           # beliebige Page/Code-Kombination
./hidpoc key 0x04                     # eine Taste (HID-Usage, 0x04 = "a")
./hidpoc type hallo                   # Zeichenkette tippen
```

Alles davon ist am Gerät verifiziert. Wenn eine Capability „not supported by this device"
meldet, fehlt fast sicher die Usage-Assertion – siehe unten.

## Worauf das aufsetzt

`CoreDevice.framework` ist reines Swift ohne Header und ohne `.swiftinterface`, also
nicht importierbar. Der Trick hier ist, **nicht die ABI nachzubauen, sondern das
Interface**: `CoreDevice.swiftmodule/arm64-apple-macos.swiftinterface` deklariert
den benötigten Ausschnitt des Moduls so, wie Apple ihn deklariert hat – rekonstruiert aus
den demangelten Export-Symbolen der Dylib. Der Swift-Compiler erzeugt daraus dieselben
Mangled Names und Dispatch-Thunk-Aufrufe wie Apples eigener Code; der Linker bindet
gegen die echten Dylibs.

Dass das trägt, ist mechanisch prüfbar: der Link schlägt fehl, sobald eine Deklaration
nicht exakt stimmt. Die Deklarationen müssen nur namens- und signaturgenau sein, nicht
vollständig – wir implementieren keines der Protokolle, sondern rufen nur über
Dispatch-Thunks auf existierenden Instanzen auf. Layout-Annahmen gibt es deshalb keine.

Der Aufrufpfad entspricht dem, was Xcodes DeviceHub.app tut:

```
CoreDeviceService.sharedConnection          // XPC zum Broker CoreDeviceService.xpc
  -> DeviceManager(serviceConnection:)
  -> awaitFullInitialization()
  -> devices[uuid]                          // RemoteDevice
  -> getImplementation(for: .hid.digitizer) // CoreDevice.IndigoHIDDigitizer
  -> send(pointOne:pointTwo:eventType:edge:target:)
```

## Drei Eigenheiten, die den Unterschied machen

- **Unit-Koordinaten, nicht Pixel.** `DigitizerPoint` erwartet 0…1 relativ zum
  Framebuffer. Pixelwerte werden klaglos geschluckt und verpuffen wirkungslos.
- **`sendBarrier()` ist der Flush.** Ohne Barriere nach jedem Event werden
  Zwischenpunkte zusammengefasst: Taps und System-Gesten gehen trotzdem durch, ein
  In-App-Drag aber nicht – die Liste scrollt einfach nicht. Mit Barriere pro Event
  scrollt sie.
- **Der Versand ist fire-and-forget.** Beendet sich der Prozess direkt nach dem letzten
  `send`, kommt nichts an. In der App ist das kein Thema (Dauerprozess), im CLI braucht
  es das abschließende Warten.

## Was damit verifiziert ist

Am iPhone 15 (iPhone15,4) mit iOS 27.0.1 (24A446), angebunden über `localNetwork`,
gegen CoreDevice 642.16 aus Xcode 27:

| Geste                      | Ergebnis                                                         |
| -------------------------- | ---------------------------------------------------------------- |
| Tap                        | trifft die Zeile, auf die er zielt (Settings → Bluetooth)         |
| Drag im App-Inhalt         | scrollt, sobald pro Event eine Barriere gesetzt ist               |
| Edge-Swipe `bottom`        | Home-Geste, App geht in den Hintergrund                           |
| Zwei-Finger-Pinch          | zoomt das Fotos-Raster                                            |

Das aufrufende Binary war lokal gebaut, ad-hoc signiert und **ohne jedes Entitlement**.


## Keyboard und Hardware-Tasten (2026-10-10)

**Beide am Gerät verifiziert.** `./hidpoc type hallo` schreibt in ein fokussiertes Textfeld,
`./hidpoc button sleepWake` schaltet den Schirm aus.

**Vorher muss eine Usage-Assertion her – das war die Falle.** Ohne sie liefert
`DeviceManager.devices` ein gepaartes, aber *nicht verbundenes* `RemoteDevice`, dessen
Capability-Satz auf fünf Einträge schrumpft (`connectdevice`, `acquireusageassertion`,
`unpairdevice`, `tags`, `default.user.credentials`). Jedes `getImplementation(for: .hid.*)`
scheitert dann mit „not supported by this device" – **auch der Digitizer**, der
nachweislich funktioniert. `devicectl` merkt davon nichts, weil es pro Aufruf selbst
verbindet.

```swift
let assertion = try await device.acquireDeviceUsageAssertion(
  withReason: "…",
  options: UsageAssertionOptions(requiredPreparedness: DevicePreparedness(rawValue: 0)))
defer { assertion.releaseAssertion() }
```

`./hidpoc assert` macht genau das und probt danach – so lässt sich die Reparatur ohne App
nachstellen. `./hidpoc probe` lässt sie weg und zeigt den kaputten Zustand.

**Werttypen liegen in `CoreDeviceUtilities`, nicht in `CoreDevice`.** CoreDevice reexportiert
es per `LC_REEXPORT_DYLIB`; die Protokolle und Capabilities stehen in CoreDevice, die Member
der Werttypen drüben. Deshalb linkt `DigitizerPoint(x:y:)`, obwohl es in CoreDevices eigener
Export-Liste fehlt – und deshalb sah es lange so aus, als müsse man Layouts raten.

```sh
otool -l …/CoreDevice | grep -A3 REEXPORT          # Reexporte finden
dyld_info -exports …/CoreDeviceUtilities \
  | awk '{print $NF}' | grep '^_\$s' | sed 's/^_//' | swift demangle
```

Damit ist alles gedeckt, nichts zu raten:

- `HIDButtonState` – `RawRepresentable` über `UInt8`, Cases `down`/`up`; die Reihenfolge
  `down, up` ist am Gerät bestätigt
- `HIDKeyboardUsageCode` – `init(rawValue: UInt16)` plus 152 benannte Konstanten
- `HIDUsageCode<Page>` – `init(_:_:)` sowie `usagePage`/`usageCode`

`./hidpoc pages` liest die Consumer-Codes aus dem Framework: Page `0xc`,
`sleepWake`/`power` = `0x30`, `home`/`menu` = `0x40`, `siri` = `0xcf`, `snapshot` = `0x65`,
`volumeIncrement`/`volumeDecrement` = `0xe9`/`0xea`.

**Stub-Detail:** Member ohne Dispatch-Thunk – `acquireDeviceUsageAssertion` und
`DeviceUsageAssertion.identifier` – müssen `final` deklariert werden, sonst sucht der Linker
einen Thunk, den es nicht gibt.

## Scroll (2026-10-10, offen)

`./hidpoc scrollinfo` liest die Bedeutung der Rohwerte aus den `description`-Gettern:
`ScrollPhase` ist ein OptionSet (`began` = 1, `changed` = 2, `ended` = 4, `cancelled` = 8),
`ScrollMomentum` ebenso (`continue` = 1, `start` = 2, `end` = 4). `ScrollTarget` nimmt
dagegen **nur zwei Werte** an: `digitalCrown` = 0 und `dial` = 1 – kein Bildschirm-Ziel.

Das riecht nach Apple Watch statt iPhone. Bevor das in die App wandert, gehoert die Frage
beantwortet, ob `./hidpoc scroll -300 0` bzw. `... 1` an einem **entsperrten** iPhone mit
einer scrollbaren Ansicht irgendetwas bewegt. Der bisherige Versuch lief gegen einen
ausgeschalteten Schirm und zaehlt nicht.

## Die Assertion gilt fuer alle Kommandos

Seit 2026-10-10 holt `main.swift` beim Start eine `DeviceUsageAssertion` und haelt sie
ueber den ganzen Lauf. Vorher funktionierten die Kommandos nur, solange zufaellig jemand
anders das Geraet verbunden hielt.

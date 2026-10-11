# Spike: Schirm und Systemton von iOS via CoreDevice-Medienstrom

Stand 2026-10-10. Lauffähiger Nachweis, dass ein iPhone seinen Bildschirm **und
seinen Systemton** selbst an den Mac sendet – ohne Companion-App, ohne
Entitlement, ohne root, und über denselben CoreDevice-Tunnel, der auch kabellos
trägt. Hintergrund und Bewertung stehen in [../../ROADMAP.md](../../ROADMAP.md),
Abschnitt „Kabellose Spiegelung und Audio via CoreDevice-Medienstrom".

Dieses CLI ist die **Handprobe für den App-Code**: es kompiliert
`CoreDeviceMediaStream.swift` und `MediaStreamRtp.swift` direkt aus
[`packages/synk_app/macos/Runner/`](../../../packages/synk_app/macos/Runner/).
Es gibt also keine zweite Kopie der Logik – wenn hier Frames dekodiert werden,
trägt derselbe Code auch in der App.

```sh
./build.sh
./mspoc <udid> probe          # Capabilities, ohne einen Strom zu starten
./mspoc <udid> video 30       # Schirm spiegeln und dekodieren, 30 s
./mspoc <udid> audio 15       # Systemton empfangen und dekodieren, 15 s

SYNK_TIMEOUT=30 ./mspoc <udid> video 60   # Sitzungsdauer variieren
SYNK_DUMP_FRAME=300 ./mspoc <udid> video  # Frame 300 als PNG sichern
SYNK_DUMP_LAST=1 ./mspoc <udid> video     # letzten Frame als last.png sichern
SYNK_DUMP_STREAM=1 ./mspoc <udid> video   # Elementarstrom als stream.h265
SYNK_FORWARD=5004 ./mspoc <udid> video    # Datagramme an 127.0.0.1:5004 spiegeln
```

Die UDID nimmt beide Schreibweisen (mit und ohne Bindestrich).

## Der Weg

CoreDevice vermittelt nur die Verhandlung, nicht die Medien:

```
CoreDeviceService.sharedConnection
  -> DeviceManager -> devices[uuid]                  // RemoteDevice
  -> acquireDeviceUsageAssertion(...)                // sonst keine Capabilities
  -> mediaStreamSupportInfo                          // was Gerät und Mac gemeinsam können
  -> AVCMediaStreamNegotiator(mode:options:)         // AVConference baut das Angebot
  -> createOffer() -> offer
  -> startMediaStream(StartRequest(... receiverIP:receiverPort: ...))
  -> setAnswer(response.negotiatorAnswer) + processAnswer
```

Danach schickt das Gerät **rohes RTP** an die Adresse, die man ihm genannt hat.
Das liest synk selbst – AVConference wird nur für Angebot und Antwort gebraucht.

- **Video:** HEVC nach RFC 7798 – Aggregation Packets (NAL-Typ 48),
  Fragmentation Units (49), Parametersätze inline. Dekodiert mit VideoToolbox
  über `CMVideoFormatDescriptionCreateFromHEVCParameterSets`.
- **Audio:** AAC-ELD, 48 kHz stereo, 10-ms-Frames, ein Frame je Paket.
  Dekodiert mit `AudioConverter` (`kAudioFormatMPEG4AAC_ELD`).
- **Verschlüsselung:** keine. Die Verhandlung meldet SRTP-Cipher-Suite 0, der
  Strom ist also direkt lesbar. `CoreDeviceMediaStream` prüft das und bricht ab,
  falls ein Gerät doch verschlüsselt aushandelt.

## Fünf Eigenheiten, die den Unterschied machen

- **Die Usage-Assertion ist Pflicht**, genau wie bei HID. Ohne sie meldet das
  Gerät keine Medienstrom-Capability.
- **`clientSessionID` muss eine UUID sein, kein String.** Als String antwortet
  das Gerät mit „Missing ClientName, CallID, or ClientSessionID. Invalid Options
  passed." – die Diagnose kostete mehrere Durchgänge, weil die Schlüsselnamen
  dabei schon stimmten. Dasselbe gilt für die `callID` in den Init-Optionen, die
  AVConference als String zurückgibt.
- **Die Empfängeradresse gehört in die Start-Anfrage**, und der Socket muss
  vorher gebunden sein: `receiverIP`/`receiverPort` sind Pflicht, und ein nur
  reservierter Port kann in der Zwischenzeit weg sein.
- **RTCP ist nicht optional.** Ohne Receiver Reports liest Apples Sender die
  Stille als zusammenbrechende Verbindung: das Bild zerfällt in Blöcke, die
  Bildrate sinkt, und der Strom stirbt. Messung über 20 s, sonst identisch:

  | | t+5s | t+10s | t+15s | t+20s |
  | --- | --- | --- | --- | --- |
  | ohne RTCP | 58 fps | 47 | 52 | 43 |
  | mit RTCP | 58 fps | 63 | 62 | 61 |

- **`timeout` in der Start-Anfrage ist eine harte Frist, kein Idle-Timeout.**
  Mit `timeout: 30` hört das Gerät nach ~27 s auf zu senden, mitten im Betrieb.
  Das Gerät nimmt jeden Wert an; synk bittet um 24 Stunden.

## Was damit verifiziert ist

Am iPhone 15 (iPhone15,4) mit iOS 27.0.1 (24A446) gegen CoreDevice 642.16 und
AVConference 2235.63, aus einem lokal gebauten, ad-hoc signierten Binary **ohne
jedes Entitlement**:

| Posten | Ergebnis |
| --- | --- |
| Capabilities | `Primary video display mirrored output stream` und `System audio output stream`, beide unter `common` |
| Video | 1184×2576, 53–63 fps über 90 s, 0 Paketverluste, 0 Dekodierfehler – aber sichtbar korrupt, siehe unten |
| Audio | 825 Pakete → 825 dekodierte Frames; Spitzenamplitude 0,000 bei Stille und 0,825 während VoiceOver sprach |
| Speicher | flach bei 47 MiB über 60 s und 3208 Frames – kein Leck |
| Bitrate | 0,7–2,5 Mbit/s je nach Bildinhalt, Obergrenze der Verhandlung 6 Mbit/s |

**Noch nicht verifiziert:** der kabellose Fall. Alle Messungen liefen über einen
CoreDevice-Tunnel, dessen Unterbau zu diesem Zeitpunkt USB war
(`transportType: wired`). Der Code kennt den Unterschied nicht – er nimmt die
utun-Adresse, die CoreDevice bereitstellt – aber „läuft über WLAN" ist damit
begründet, nicht gemessen. Zum Nachprüfen: in Xcode „Connect via Network"
aktivieren, Kabel ziehen, `./mspoc <udid> video 30`.

## Offen: die Bildqualität

Das Bild ist während Bewegung stark zerrissen – Farbstiche, verschobene Bänder,
und Bereiche, die veraltet stehenbleiben und sich **nicht mehr erholen**, auch
nicht nach Sekunden völligen Stillstands. Was dazu gemessen ist:

- **Der Depacketizer ist es nicht.** `SYNK_DUMP_STREAM=1` schreibt den
  zusammengesetzten Elementarstrom; `ffmpeg` dekodiert ihn fehlerfrei und mit
  korrekten Maßen. Und `SYNK_FORWARD=5004` reicht die Datagramme unverändert
  weiter, sodass **ffmpegs eigener** RTP-Depacketizer dieselben Pakete
  verarbeitet – mit exakt derselben Korruption, ohne eine Warnung.
- **Es ist kein Paketverlust.** Über Minuten null Lücken in den
  Sequenznummern, kein Padding, keine CSRC, eine Fragmentierungseinheit je
  Frame.
- **Es ist kein Dekodierfehler.** VideoToolbox meldet über hunderte Frames
  hinweg keinen einzigen; der Strom beginnt sauber mit einem IDR (NAL-Typ 20).
- **Es ist keine Pufferwiederverwendung.** Ein über 1,5 s festgehaltener
  Decoder-Puffer bleibt auf statischem Schirm unverändert sauber, während
  darüber 100+ Frames dekodiert werden.
- **Es ist nicht die gemeldete Empfangsqualität.** Receiver Reports mit
  künstlich perfekten Werten ändern die Bitrate nicht messbar (2,9 vs.
  3,3 Mbit/s).

Was übrig bleibt, und worauf die Konfiguration zeigt: `IsltrpEnabled = true`
bei `KeyFrameInterval = 0`. Der Encoder arbeitet mit Langzeit-Referenzbildern
und sendet **genau ein** Intra-Frame, am Anfang, und nie wieder – gemessen:
1 Intra-Frame in 12 s. Beide Standardmittel, es zu einem neuen zu bewegen,
ignoriert er: PLI und FIR (RFC 4585/5104) blieben über je zwölf Anforderungen
wirkungslos. Und `ltrpEnabled` im Angebot auf `false` zu setzen greift zwar
lokal, das Gerät schaltet LTR trotzdem ein.

AVConference benennt den fehlenden Baustein selbst: `RtcpAppLTRAckRx` /
`RtcpAppLTRAckTx`, `_VideoReceiver_ProcessRtcpLTRAck` und das Flag
`vc-rtcp-psfb-for-ltr-ack`. Der Empfänger muss jedes Langzeit-Referenzbild per
RTCP bestätigen; ohne das laufen die Referenzzustände von Encoder und Decoder
auseinander, und weil es keine Keyframes gibt, heilt das nie. Das Format dieses
Pakets ist der nächste Schritt – es ist proprietär und steht noch aus.

## Nützliches beim Nachforschen

Die Modus-Werte für `initWithMode:` stehen nirgends; sie wurden gefunden, indem
alle Modi durchprobiert und die entstandene Settings-Klasse ausgelesen wurde
(`AVCMediaStreamNegotiatorSettingsCoreDeviceScreenSharing` = 5,
`…CoreDeviceSystemAudio` = 6). AVConference ist Objective-C, also ist alles per
Laufzeit-Reflexion lesbar – anders als CoreDevice, das reines Swift ist und die
Stub-Interfaces braucht.

Warum ein Fehler auftritt, verrät oft erst das Protokoll des Daemons:

```sh
log stream --level debug --style compact --predicate 'process == "avconferenced"'
```

Die Fehlermeldungen des *Geräts* stehen in der DDI, nicht auf dem Mac:

```sh
hdiutil attach -nobrowse -readonly /Library/Developer/CoreDevice/CandidateDDIs/iOS_DDI.dmg
# darin Restore/*.dmg erneut mounten, dann:
#   Library/Frameworks/CoreDeviceMediaStreamSupport.framework
#   usr/libexec/dtremotedisplayd
```

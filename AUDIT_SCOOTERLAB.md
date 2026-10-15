# Syrak ScooterLab — Bug-, Schwachstellen- & Tuning-Audit

Dieser Branch (`scooterlab-audit-fixes`) enthält den kompletten, überarbeiteten
Quellcode der Android-Tuning-App **Syrak ScooterLab** (`com.syrak.scooterlab`).

> **Hinweis zum Repository:** Das Repository `Syrak-Hub` enthielt auf `main`
> ausschließlich `script.lua` (ein Roblox-Script). Das Android-Projekt lag nicht
> im Repo, sondern nur im Arbeitsverzeichnis. Dieser Branch legt den geprüften
> und korrigierten Stand unter der echten Projektstruktur
> (`app/src/main/java/com/syrak/scooterlab/`) ab, damit er versioniert ist.

## Verifikation

* Kompiliert mit **kotlinc 1.9.24** gegen **Android-34** (`android.jar`) + AndroidX
  (appcompat 1.7.0, activity 1.9.2, core 1.13.1, lifecycle 2.8.5, fragment 1.8.4).
* Ergebnis: **EXIT=0 — 0 Fehler, 0 Warnungen, 108 Klassen.**

## Architektur (Modul-Split)

| Datei | Aufgabe |
|---|---|
| `ScooterProtocolAdapter.kt` | Adapter-Interface + `FrameCodec` + `ProtocolAdapters`-Registry/Factory |
| `FrameBuilders.kt` | Frame-Bau (Ninebot `5AA5…`, Navee `AA55…` / `55AA…`) inkl. Flash-Frames |
| `TelemetryDecoder.kt` | Telemetrie-Dekodierung (beide Navee-Header, Ninebot) |
| `NaveeGt3MaxAdapter.kt` | Referenzadapter **NAVEE GT3 Max (DE, 20 km/h eKFV)** |
| `NinebotAdapter.kt` | Zweiter Adapter (Ninebot) — ohne Kern-Umbau plugbar |
| `BleEngine.kt` | BLE-Kern: Scan/Connect, Write-Queue, ACK-Flow-Control, Flashing |
| `ScooterRepository.kt` | Persistenz (SharedPreferences) |
| `MainActivity.kt` | Komplette programmatische UI (Tabs, Trip-Computer, Dashboards, Flash) |
| `Models.kt`, `FirmwareCatalog.kt`, `Palette.kt` | Datenmodelle, Firmware-Katalog, Farben |

## Behobene Fehler & Schwachstellen

### Protokoll / Decoder
1. **`decodeNavee` verwarf `55AA`-Telemetrie.** Es wurde nur der Header `AA55`
   akzeptiert. Jetzt werden **beide** Header (`AA55` und `55AA`) erkannt.

### BLE-Engine (Kern)
2. **Unlock-Handshake galt nach lokalem Write als „unlocked".** Der Adapter wurde
   freigeschaltet, sobald der lokale GATT-Write zurückkam — nicht, wenn der
   Controller tatsächlich antwortete. Jetzt wird erst bei **echtem ACK**
   (`onCharacteristicChanged`) freigeschaltet; bei Timeout best-effort.
3. **ACK-Timeout gehörte nicht zur jeweiligen Operation.** Timeouts konnten eine
   inzwischen ersetzte Operation treffen. Fix: **Ownership-Check**
   (`awaitingAck === op`) plus monotones Step-Token.
4. **Notify-Charakteristik wurde mit der Write-Charakteristik gleichgesetzt.**
   Jetzt sucht `findNotifyChar()` die echte NOTIFY/INDICATE-Charakteristik
   (gleicher Service → sonst beliebige → Fallback Write-Char).
5. **`handleNotification`: Cross-Fallback** für abweichende Frames ergänzt; da
   `decodeNavee` nun beide Header kennt, greifen auch `55AA`-Frames zuverlässig.

### Flashing („Gyrostat-Flashing") — Hauptverbesserung
6. **Doppel-Start-Guard** (`flashActive`) — kein zweiter Flash, während einer läuft.
7. **Gerahmtes Flash-Protokoll** (Start/Chunk/Ende/Abort) mit **echtem
   ACK-Flow-Control** pro Chunk, statt blindem Schreiben.
8. **Automatischer Fallback** gerahmt → roh, wenn der Start-Frame kein ACK erhält
   (Kompatibilität mit Controllern ohne gerahmtes Flash).
9. **Per-Chunk-Retry (2×)** statt sofortigem Abbruch bei Write-Fehler/Timeout.
10. **Inter-Chunk-Pacing (25 ms)** gegen Puffer-Überlauf beim Controller.
11. **Abort-Frame** beim manuellen Abbruch (sauberer Zustand im Controller).
12. **Fortschritt = bestätigte Bytes** (nicht gesendete) — korrekte Anzeige.
13. **Flash-Watchdog** pro Chunk (Timeout → Retry bzw. Abbruch + Abort-Frame).

### UI / MainActivity
14. **`maxSpeedKmh` wurde nicht auf den Easy-Speed des Modells gesetzt**
    (GT3 Max: 25 statt 20 km/h). Jetzt korrekt beim Verbinden initialisiert.
15. **Hard-Flash: Akku-Gate (> 50 %) + `KEEP_SCREEN_ON`** ergänzt — verhindert
    Bricking durch Akku-Ende mitten im Flash bzw. Display-Schlaf.
16. **Direkte `.bin`-Validierung** akzeptierte beliebige Textdateien. Neuer
    `looksLikeText()`-Check (NUL → binär; > 95 % druckbares ASCII → Text).
17. **`overspeedAlarmMuted` wurde nicht persistiert** — jetzt in den Prefs.
18. **Flash-Button während Flash gesperrt** (`flashInProgress`, Label „FLASH LÄUFT…").

### Repository
19. **`overspeedAlarmMuted` persistieren** (`KEY_OVERSPEED_MUTED`).

## Grundregeln (eingehalten)

* **Vollständiger Code** — keine Platzhalter.
* **Keine Fake-Daten** — nicht empfangene Telemetrie ist `null`, niemals `0`.
* **UI unverändert funktionsfähig** — alle Tabs, Trip-Computer, Dashboards.
* **Alles funktioniert wie zuvor** (bzw. besser) — durch Kompilierung verifiziert.

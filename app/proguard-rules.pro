# Syrak ScooterLab — ProGuard/R8-Regeln.
# Aktuell ist Minify im Release-Build deaktiviert (isMinifyEnabled = false).
# Diese Datei existiert, damit der Build sie referenzieren kann und um
# spaetere Optimierungen (z. B. Keep-Regeln fuer BLE-Callbacks) zu dokumentieren.

# BLE-Callbacks werden vom Android-Framework ueber Reflection aufgerufen.
-keep class com.syrak.scooterlab.BleEngine { *; }
-keep class com.syrak.scooterlab.ScooterProtocolAdapter { *; }
-keep class * implements com.syrak.scooterlab.ScooterProtocolAdapter { *; }

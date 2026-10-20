# tok_tik

Aplicación Flutter de videos verticales con feeds **Para ti**, **Descubrir** y
**Cerca de ti**.

## Configuración estacional

La aplicación carga las fechas anuales desde `.env`. El formato es `MM-DD` y
los intervalos incluyen ambas fechas:

```dotenv
HALLOWEEN_START=10-01
HALLOWEEN_END=10-31
CHRISTMAS_START=12-01
CHRISTMAS_END=01-06
```

Los feeds de ejemplo usan endpoints MP4 públicos y necesitan conexión a
Internet. El datasource local de `assets/videos/` se conserva para usarlo como
fuente alternativa durante el desarrollo.

Android usa un ícono de lanzamiento estático generado desde
`assets/icons/icon_normal.png`.

## Ícono estático para Android

El ícono de lanzamiento se genera desde `assets/icons/icon_normal.png` con
`flutter_launcher_icons`. Después de modificar la imagen o la configuración,
ejecuta desde la raíz del proyecto:

```powershell
flutter clean
flutter pub get
dart run flutter_launcher_icons
```

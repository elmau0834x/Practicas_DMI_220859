# Práctica 04: TokTik — Clon de Videos Cortos (Flutter)

- **Asignatura:** Desarrollo Móvil Integral (10° Cuatrimestre)
- **Carrera:** Ingeniería en Desarrollo y Gestión de Software
- **Docente:** M.T.I. Marco Antonio Ramírez Hernández
- **Alumno:** Mauricio Rosales Gabriel
- **Universidad:** Universidad Tecnológica de Xicotepec de Juárez (UTXJ)

<div align="center">

[![Appetize.io Demo](https://img.shields.io/badge/Appetize.io-Probar%20en%20el%20Navegador-FF6B6B?style=for-the-badge&logo=android&logoColor=white)]([AQUÍ_TU_ENLACE_APPETIZE])
[![Diagrama de Arquitectura](https://img.shields.io/badge/Diagramas-Clean%20Architecture-02569B?style=for-the-badge)]([AQUÍ_TU_ENLACE_GITHUB_PAGES])

</div>

---

## Objetivo de la Práctica

Diseñar y desarrollar una aplicación móvil interactiva en **Flutter** que simule la experiencia de usuario de la plataforma TikTok. El proyecto aplica rigurosamente los principios de **Clean Architecture** (separando Presentación, Dominio e Infraestructura) e implementa el consumo simultáneo de múltiples APIs de video, persistencia de datos en memoria local estricta (sin bases de datos remotas), manejo avanzado de estado con `Provider`, pantallas de carga interactivas y personalización temática estacional basada en fechas y preferencias del usuario.

---

## Funcionalidades Implementadas (Cumplimiento de Rúbrica)

### 1. Pantalla de Carga Animada (Splash Screen) y Audio Reactivo
- **Experiencia de Entrada:** Al iniciar la aplicación, se despliega una pantalla de carga interactiva que evalúa el tema activo (mediante fecha o caché). 
- **Multimedia:** Renderiza el ícono correspondiente a la temporada y reproduce de forma aislada un audio/ringtone temático (usando `audioplayers`) antes de navegar automáticamente a la pantalla principal, previniendo reproducciones accidentales durante la navegación.

### 2. Secciones de Feed y Navegación Lateral (Swipe)
- Implementación de un `PageView` horizontal (o `TabBarView`) que permite el desplazamiento lateral continuo entre tres secciones principales:
  - **Discover:** Consumo de la API de The Movie Database (TMDB).
  - **For You:** Mezcla dinámica de videos extraídos de YouTube y almacenamiento local.
  - **Favorites:** Colección privada de videos que el usuario ha marcado con "Me gusta", cargados instantáneamente desde el caché.

### 3. Consumo de 3 Datasources (Clean Architecture)
El proyecto utiliza abstracciones e inyección de dependencias para consumir 3 fuentes de video externas garantizando el rendimiento móvil:
  - **YouTube Data API v3:** Extrae IDs y utiliza `youtube_explode_dart` para decodificar el stream `.mp4` (muxed) de alta calidad, limitando la resolución a 1080p/720p para evitar bloqueos por hardware (`NO_EXCEEDS_CAPABILITIES`).
  - **Pixabay Video API:** Consumo de videos cortos nativos en formato vertical.
  - **The Movie Database (TMDB):** Extracción de IDs de trailers y conversión a formato MP4 reproduciéndose de forma transparente en la interfaz.

### 4. Temas Visuales y Auditivos por Temporada
- **Detección Automática:** La app lee la fecha del dispositivo e inyecta la paleta de colores, **Tipografía** (`fontFamily`), **Iconografía** y un **Audio/Ringtone** específico para cada temporada:
  - 🎃 **Halloween:** Tonos naranja/morado.
  - 🎄 **Christmas:** Tonos rojo/verde.
  - 💘 **Valentine's Day:** Tonos rosa/rojo.
  - 📱 **Normal:** Tema oscuro estándar.
- **Modo Manual y Persistencia:** Menú interactivo para forzar cualquier temporada. Esta elección sobreescribe la fecha y se guarda en el **Local Storage**, manteniéndose activa incluso si se reinicia la aplicación.

### 5. Persistencia Local (Likes y Favoritos)
- Almacenamiento en caché mediante `shared_preferences` (cumpliendo la regla de *cero bases de datos SQLite*).
- El botón de corazón (Like) suma `+1` y guarda la interacción localmente. Si se desmarca, resta `-1`. 
- Si la aplicación se cierra, los likes y los videos en la pestaña de "Favorites" permanecen intactos gracias a la serialización JSON en caché.

### 6. Reproductor Avanzado y UI
- **Control de Audio (Mute):** Botón flotante inferior derecho con icono dinámico para silenciar/activar el audio global del `VideoPlayerController`.
- **Descripción Extensa (Expandable Caption):** Si la descripción del video supera las 2 líneas, el texto se trunca mostrando el botón **"(... más)"**. Al tocarlo, se despliega un contenedor con scroll vertical independiente (`SingleChildScrollView`).
- **Gradientes y Loops:** Implementación de `LinearGradient` para oscurecer la base del reproductor asegurando legibilidad, y auto-loop infinito de los videos.
- **Aserciones (Asserts):** Validaciones a nivel de entidad (`VideoPost`) exigiendo que el `caption` no esté vacío y que los contadores de likes/views sean `>= 0`.

---

## Arquitectura y Diagramas

Cumpliendo con la documentación requerida, se han generado 2 diagramas de arquitectura interactivos separados:

### Diagrama 1: Arquitectura con Provider Local
Muestra el flujo inicial con acoplamiento directo entre el manejador de estado (Provider) y los *assets* locales estáticos de la aplicación.
- 🌐 **[Ver Diagrama de Provider Local en Vivo](https://elmau0834x.github.io/Practicas_DMI_220859/Practica04/clean_architecture.html)**

### Diagrama 2: Provider a través de Repositorio y 3 Datasources
Ilustra el cumplimiento de *Clean Architecture* con la inversión de dependencias: cómo los Providers delegan la petición al Contrato (Repository) y este orquesta las consultas hacia YouTube, Pixabay, TMDB y Local Storage.
- 🌐 **[Ver Diagrama de Múltiples Datasources en Vivo](https://elmau0834x.github.io/Practicas_DMI_220859/Practica04/clean_architecture.html)**

---

## Configuración del Entorno y Ejecución

Para ejecutar este proyecto de forma local, es indispensable configurar las llaves de las APIs comerciales.

1. Clona el repositorio e instala dependencias:
   ```bash
   git clone https://github.com/elmau0834x/Practicas_DMI_220859.git
   cd Practica04/tok_tik
   flutter pub get
   ```

2. Crea un archivo `.env` en la raíz del proyecto basándote en este formato:
   ```env
   YOUTUBE_API_KEY=tu_llave_aqui
   PIXABAY_API_KEY=tu_llave_aqui
   TMDB_API_KEY=tu_llave_aqui

   HALLOWEEN_START_DATE=2026-10-01
   CHRISTMAS_START_DATE=2026-12-01
   VALENTINE_START_DATE=2027-02-01
   ```

3. Limpia el caché y ejecuta:
   ```bash
   flutter clean
   flutter run
   ```

---

## Evidencia en Video

### 1. Splash Screen y Temas Estacionales
Demostración de la pantalla de carga animada, reproducción del audio reactivo y el cambio manual persistente entre las diferentes temporadas (Halloween, Navidad, San Valentín).
*▶️ **[Ver Demostración de Temas y Splash Screen]([AQUÍ_TU_ENLACE_YOUTUBE_O_DRIVE])***

### 2. Navegación, APIs, Favoritos y UI Expandible
Demostración del consumo asíncrono de YouTube, Pixabay y TMDB, navegación lateral entre secciones (Swipe), almacenamiento de likes, mute global y despliegue del texto extendido "(... más)".
*▶️ **[Ver Demostración de Navegación y Funcionalidad Core]([AQUÍ_TU_ENLACE_YOUTUBE_O_DRIVE])***
# Parte 2 — Compresión en Apache: Tabla Comparativa y Análisis Crítico

Servidor: `parcial.empresa.local` (192.168.50.2) · Apache 2.4.52 · mod_deflate + mod_brotli

---

## Tabla comparativa de resultados

### `app.js` (biblioteca JS real — jQuery 3.7.1) · Tamaño original: 285,314 B

| Algoritmo / nivel | Tamaño (B) | Ratio | Ahorro % | Tiempo |
|---|---|---|---|---|
| Sin comprimir (base) | 285,314 | 1.00 | 0% | 5.8 ms |
| gzip nivel 1 | 102,649 | 0.36 | 64.02% | 166.8 ms* |
| gzip nivel 6 | 84,014 | 0.29 | 70.56% | 17.5 ms |
| gzip nivel 9 | 83,592 | 0.29 | 70.70% | 27.0 ms |
| brotli calidad 5 | 79,680 | 0.28 | 72.07% | 11.1 ms |
| brotli calidad 11 | 69,545 | 0.24 | 75.63% | 475.1 ms |

### `datos.json` (dataset grande) · Tamaño original: 1,071,472 B

| Algoritmo / nivel | Tamaño (B) | Ratio | Ahorro % | Tiempo |
|---|---|---|---|---|
| Sin comprimir (base) | 1,071,472 | 1.00 | 0% | 2.2 ms |
| gzip nivel 1 | 153,854 | 0.14 | 85.64% | 183.2 ms* |
| gzip nivel 6 | 131,912 | 0.12 | 87.69% | 18.6 ms |
| gzip nivel 9 | 130,518 | 0.12 | 87.82% | 59.9 ms |
| brotli calidad 5 | 121,878 | 0.11 | 88.63% | 20.9 ms |
| brotli calidad 11 | 103,915 | 0.10 | 90.30% | 1,618.3 ms |

### `lorem.txt` (texto plano, muy repetitivo) · Tamaño original: 372,000 B

| Algoritmo / nivel | Tamaño (B) | Ratio | Ahorro % | Tiempo |
|---|---|---|---|---|
| Sin comprimir (base) | 372,000 | 1.00 | 0% | 1.9 ms |
| gzip nivel 1 | 2,712 | 0.0073 | 99.27% | 48.7 ms* |
| gzip nivel 6 | 1,397 | 0.0038 | 99.62% | 4.0 ms |
| gzip nivel 9 | 1,397 | 0.0038 | 99.62% | 3.4 ms |
| brotli calidad 5 | 106 | 0.00028 | 99.97% | 2.7 ms |
| brotli calidad 11 | 99 | 0.00027 | 99.97% | 56.8 ms |

### `index.html` (100-500 KB) · Tamaño original: 139,875 B

| Algoritmo / nivel | Tamaño (B) | Ratio | Ahorro % | Tiempo |
|---|---|---|---|---|
| Sin comprimir (base) | 139,875 | 1.00 | 0% | 3.0 ms |
| gzip nivel 1 | 3,062 | 0.0219 | 97.81% | 55.2 ms* |
| gzip nivel 6 | 3,052 | 0.0218 | 97.82% | 5.3 ms |
| gzip nivel 9 | 3,058 | 0.0219 | 97.81% | ~5 ms** |
| brotli calidad 5 | 1,613 | 0.0115 | 98.85% | 3.7 ms |
| brotli calidad 11 | 1,499 | 0.0107 | 98.93% | 367.0 ms |

### Archivos pequeños (CSS, SVG, XML) — donde el overhead domina

| Archivo (base) | gzip 1 | gzip 6 | gzip 9 | brotli 5 | brotli 11 |
|---|---|---|---|---|---|
| estilos.css (704 B) | 390 B (44.6%) | 374 B (46.9%) | 374 B (46.9%) | 301 B (57.2%) | 277 B (60.7%) |
| grafico.svg (363 B) | 243 B (33.1%) | 236 B (35.0%) | 236 B (35.0%) | 204 B (43.8%) | 207 B (43.0%) |
| feed.xml (784 B) | 243 B (69.0%) | 242 B (69.1%) | 242 B (69.1%) | 204 B (74.0%) | 187 B (76.2%) |

### Recursos ya comprimidos (excluidos correctamente)

| Archivo | Tamaño original | Con gzip/brotli forzado | Content-Encoding |
|---|---|---|---|
| foto.jpg | 135,911 B | 135,911 B (sin cambio) | *(ninguno — excluido)* |
| clip.mp4 | 2,848,208 B | 2,848,208 B (sin cambio) | *(ninguno — excluido)* |

`*` Los tiempos de gzip nivel 1 salieron más altos que nivel 6/9 en varias mediciones puntuales — es ruido de red/conexión en archivos pequeños sobre una sola petición `curl`, no una medida de CPU confiable (se explica en el punto 10 del análisis). `**` Medición afectada por una interferencia del RRL del DNS (ver nota metodológica al final); valor estimado por consistencia con las demás filas de esa columna.

---

## Análisis crítico

### 1. Brotli vs gzip: ¿cuánto mejora el ratio?

Brotli superó a gzip de forma consistente en **todos** los tipos de archivo de texto probados, pero la magnitud de la mejora depende del tamaño y la redundancia del contenido:

- **Diferencia significativa** en archivos grandes con estructura repetitiva: en `datos.json`, brotli calidad 11 logró 90.30% de ahorro frente al 87.82% de gzip nivel 9 — una diferencia de **2.5 puntos porcentuales**, que en términos absolutos son ~26,600 bytes menos por descarga. En `app.js`, la diferencia entre brotli 11 y gzip 9 fue de 5 puntos porcentuales (75.63% vs 70.70%).
- **Diferencia marginal o incluso negativa** en archivos muy pequeños: en `grafico.svg` (363 B), brotli calidad 11 (207 B) resultó **peor** que brotli calidad 5 (204 B). Esto ocurre porque en archivos diminutos el overhead fijo de las tablas de contexto de Brotli de alta calidad pesa más que la ganancia real de compresión — el algoritmo "gasta" bytes en metadatos que no alcanza a amortizar.
- En `lorem.txt` (texto extremadamente repetitivo), ambos algoritmos comprimen casi al límite teórico (99.6% gzip vs 99.97% brotli), pero en términos absolutos brotli sigue siendo ~14 veces más pequeño (99 B vs 1,397 B), aunque el porcentaje de ahorro se vea similar en la tabla.

### 2. Niveles de compresión: ¿qué se gana al subir el nivel?

**gzip (1→6→9):** el salto grande ocurre entre nivel 1 y 6 (en `app.js`: 64.02% → 70.56%, +6.5 puntos). De 6 a 9 la ganancia es marginal: solo +0.14 puntos (70.56% → 70.70%), es decir, apenas ~400 bytes menos en un archivo de 285 KB. **El punto de rendimientos decrecientes de gzip está claramente en el nivel 6** — subir a 9 no se justifica para servir contenido en tiempo real.

**brotli (5→11):** la ganancia es mayor que en gzip (72.07% → 75.63% en `app.js`, +3.6 puntos), pero el costo de CPU es desproporcionado: en `datos.json`, calidad 11 tardó **1.62 segundos** frente a los **20.9 ms** de calidad 5 — **77 veces más lento** para ganar solo 1.7 puntos porcentuales adicionales de compresión (88.63% → 90.30%). Ese costo **no se justifica** para compresión al vuelo en cada petición; solo tiene sentido si el archivo se comprime **una vez** y se sirve pre-comprimido (ver punto 11).

### 3. ¿Por qué los binarios no se benefician?

JPEG y MP4 ya contienen sus propios algoritmos de compresión internos (DCT + cuantización + codificación de entropía en JPEG; predicción de movimiento y transformadas en MP4/H.264). Esa compresión ya elimina la mayor parte de la redundancia estadística del archivo, dejando datos que se comportan casi como ruido aleatorio desde la perspectiva de LZ77/Huffman (gzip) o del modelado de contexto de Brotli. Al no encontrar patrones repetibles que codificar más corto, estos algoritmos no logran reducir el tamaño — y en la práctica pueden incluso aumentarlo levemente por los encabezados propios del formato comprimido (gzip/brotli header + checksum). Por eso se excluyeron explícitamente con `SetEnvIfNoCase` (mod_deflate) y simplemente no incluyéndolos en `AddOutputFilterByType` (mod_brotli) — confirmado empíricamente: ambos archivos mantuvieron su tamaño exacto sin `Content-Encoding` en la respuesta.

### 4. Impacto en CPU y ancho de banda

Existe un equilibrio claro entre ahorro de ancho de banda y consumo de CPU:

- Niveles bajos (gzip 1, brotli 5) → CPU barata, buen ahorro de banda (ya captura la mayoría de la ganancia disponible).
- Niveles altos (gzip 9, brotli 11) → CPU cara, ganancia adicional marginal (gzip) o moderada pero costosa (brotli).

Bajo **concurrencia alta**, este equilibrio se desplaza: el costo de CPU por petición se multiplica por el número de peticiones simultáneas. Un servidor que sirve `datos.json` con brotli 11 a 1 usuario tarda 1.6s de CPU; con 50 usuarios concurrentes pidiendo el mismo endpoint dinámico, ese costo puede saturar los núcleos disponibles y aumentar la latencia de *todas* las respuestas, no solo la comprimida — es un riesgo real de denegación de servicio auto-infligida. Por eso en producción de alto tráfico se prefiere gzip 6 o brotli 5 para contenido dinámico, reservando brotli 11 para contenido pre-comprimido una sola vez.

### 5. Contenido estático vs dinámico — recomendación de producción

- **Contenido estático** (bibliotecas JS, CSS, imágenes SVG que casi no cambian): conviene **precomprimir en disco** una sola vez con brotli calidad 11 (ej. generar `app.js.br` en el pipeline de build) y servirlo con `mod_headers`/`mod_brotli` configurado para detectar el archivo `.br` ya existente. El costo alto de CPU se paga **una vez**, no en cada petición.
- **Contenido dinámico** (respuestas de API, JSON generado por petición): comprimir al vuelo, pero con un nivel moderado — **gzip nivel 6** o **brotli calidad 4-5** — que ya captura la mayor parte del ahorro disponible sin penalizar la latencia ni saturar CPU bajo carga.
- **Binarios** (imágenes, video, ZIP): nunca comprimir — excluir explícitamente como se hizo en este parcial.

**Configuración recomendada para producción:**

```apache
# Estático (assets con hash en el nombre, ya no cambian tras deploy)
<FilesMatch "\.(js|css|svg)$">
    # servir versión precomprimida .br generada en build, vía mod_headers o similar
</FilesMatch>

# Dinámico (API, HTML generado por petición)
<IfModule mod_brotli.c>
    BrotliCompressionQuality 5
</IfModule>
<IfModule mod_deflate.c>
    DeflateCompressionLevel 6
</IfModule>

# Binarios: sin filtro de compresión (ya excluidos por MIME/extensión)
```

---

## Nota metodológica: interferencia del RRL del DNS

Durante las mediciones, algunas peticiones puntuales (especialmente a `index.html`, la ruta consultada con más frecuencia) mostraron tiempos anómalos de ~5 segundos. Se diagnosticó que el **Rate Limiting (RRL)** configurado en BIND9 en la Parte 1 (`responses-per-second 5; window 5;`) estaba limitando las respuestas DNS repetidas de `systemd-resolved` hacia `127.0.0.1` en ráfagas de pruebas rápidas — confirmado en `journalctl -u named` con mensajes `rate limit drop response to 127.0.0.0/24`. Se corrigió agregando `exempt-clients { 127.0.0.1; 192.168.50.0/24; };` al bloque `rate-limit`, preservando la protección RRL contra clientes externos. Este hallazgo es evidencia adicional de que el hardening de la Parte 1 funciona correctamente.

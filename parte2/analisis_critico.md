# Análisis Crítico de Compresión HTTP (Apache: mod_deflate vs mod_brotli)

## 1. Brotli vs gzip sobre texto
Con base en las mediciones obtenidas, Brotli supera de manera contundente a gzip en todos los recursos de texto:
- En `datos.json`, gzip (niveles 1, 6 y 9) redujo el tamaño de 366 KB a ~39 KB (89.3% de ahorro), mientras que Brotli (Q5) lo comprimió hasta 12,176 B (96.7% de ahorro), representando casi un tercio del tamaño final de gzip.
- En recursos como `index_test.html` y `estilos.css`, Brotli logró reducir el peso a 109 B y 87 B respectivamente (>99.9% de ahorro), frente a los 820 B y 479 B de gzip.
- **Conclusión:** La diferencia es crítica en datasets grandes estructurados (JSON/XML) y librerías extensas debido al diccionario estático predefinido de Brotli; en archivos extremadamente pequeños la diferencia en bytes absolutos es marginal.

## 2. Niveles de compresión y rendimientos decrecientes
- **gzip (1 -> 6 -> 9):** Pasar de nivel 1 a 6 logra una reducción sustancial (en `index_test.html` pasa de 1,616 B a 820 B). Sin embargo, pasar de nivel 6 a nivel 9 no aportó ninguna ganancia en tamaño (820 B en ambos) pero incrementó la latencia en `datos.json` de 0.005s a 0.012s.
- **brotli (5 -> 11):** Pasar de calidad 5 a 11 causó un impacto crítico en CPU/latencia: en `datos.json` el tiempo pasó de 0.007s a 0.368s (un incremento de más del 5000% en tiempo de procesamiento) y el archivo resultante fue incluso mayor (15,152 B vs 12,176 B) debido al costo de empaquetamiento de bloques en el algoritmo.
- **Punto de rendimientos decrecientes:** Se ubica en gzip nivel 6 y Brotli calidad 5. Superar estos umbrales en compresión al vuelo no justifica el consumo de CPU.

## 3. Tipos de archivo y exclusión de binarios
- En `foto.jpg` (5,913 B) y `paquete.zip` (40,597 B), el tamaño transferido fue exactamente el mismo (ratio 1.00, ahorro 0.0%) en todos los algoritmos y niveles.
- **Justificación:** Los formatos JPEG y ZIP ya incorporan algoritmos de compresión con alta entropía. Intentar comprimirlos de nuevo no reduce datos y, en un entorno real sin la exclusión (`no-gzip`), genera sobrecarga de CPU inútil e incrementa el tamaño final por las cabeceras adicionales de compresión.

## 4. Impacto en CPU y ancho de banda
Existe una compensación directa (*trade-off*) entre el uso de ancho de banda y la carga del servidor:
- En baja concurrencia, una compresión pesada no degrada la experiencia.
- En **alta concurrencia**, un tiempo de compresión de 0.368s (como Brotli 11) saturaría rápidamente los hilos/procesos de Apache (MPM event/worker), agotando la CPU y causando encolamiento de solicitudes (aumento del TTFB). Gzip 6 o Brotli 5 responden en 0.003s–0.007s, logrando un balance óptimo entre ahorro de red y concurrencia.

## 5. Contenido estático vs dinámico (Recomendación para Producción)
- **Contenido estático (HTML, CSS, JS, SVG):** Se recomienda **precompresión en disco** durante el pipeline de despliegue usando Brotli calidad 11 (`.br`) y gzip (`.gz`), sirviéndolos directamente mediante directivas de Apache y `mod_headers`. Esto aprovecha la compresión máxima con costo de CPU igual a cero en tiempo de ejecución.
- **Contenido dinámico (JSON de APIs, HTML generado por servidor):** Se debe usar **compresión al vuelo** configurando Brotli en calidad 4–5 o gzip en nivel 6 para no degradar el tiempo de respuesta dinámico del servidor.

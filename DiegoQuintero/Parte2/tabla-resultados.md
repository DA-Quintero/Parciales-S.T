# Tabla de resultados - Parte 2

Comparación de los resultados obtenidos para los distintos algoritmos y niveles de compresión aplicados sobre los recursos del sitio de prueba.

Las métricas utilizadas son:

- **Tamaño:** tamaño transferido del recurso.
- **Ratio:** tamaño comprimido / tamaño original.
- **Ahorro %:** `(1 - ratio) × 100`.
- **Tiempo / CPU:** tiempo promedio de transferencia y consumo promedio de CPU de Apache por petición.

---

## index.html

**Tamaño original:** 378.971 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 378.971 B | 1,0000 | 0,00 % | 0,011468 s / 18,2 ms |
| gzip nivel 1 | 11.926 B | 0,0315 | 96,85 % | 0,006084 s / 13,4 ms |
| gzip nivel 6 | 11.482 B | 0,0303 | 96,97 % | 0,007265 s / 13,2 ms |
| gzip nivel 9 | 11.278 B | 0,0298 | 97,02 % | 0,007459 s / 14,2 ms |
| Brotli calidad 5 | 5.520 B | 0,0146 | 98,54 % | 0,007161 s / 14,0 ms |
| Brotli calidad 11 | 4.363 B | 0,0115 | 98,85 % | 0,874172 s / 16,4 ms |

---

## estilos.css

**Tamaño original:** 358.893 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 358.893 B | 1,0000 | 0,00 % | 0,009023 s / 17,8 ms |
| gzip nivel 1 | 8.938 B | 0,0249 | 97,51 % | 0,005579 s / 13,4 ms |
| gzip nivel 6 | 8.611 B | 0,0240 | 97,60 % | 0,007129 s / 13,2 ms |
| gzip nivel 9 | 8.488 B | 0,0237 | 97,63 % | 0,007503 s / 14,2 ms |
| Brotli calidad 5 | 3.959 B | 0,0110 | 98,90 % | 0,007019 s / 15,2 ms |
| Brotli calidad 11 | 3.931 B | 0,0110 | 98,90 % | 0,969431 s / 18,8 ms |

---

## estilos.min.css

**Tamaño original:** 274.893 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 274.893 B | 1,0000 | 0,00 % | 0,008414 s / 17,6 ms |
| gzip nivel 1 | 8.857 B | 0,0322 | 96,78 % | 0,004975 s / 13,8 ms |
| gzip nivel 6 | 8.563 B | 0,0312 | 96,88 % | 0,006395 s / 13,6 ms |
| gzip nivel 9 | 8.429 B | 0,0307 | 96,93 % | 0,006803 s / 15,0 ms |
| Brotli calidad 5 | 4.150 B | 0,0151 | 98,49 % | 0,006629 s / 15,0 ms |
| Brotli calidad 11 | 4.265 B | 0,0155 | 98,45 % | 0,628949 s / 16,8 ms |

---

## app.js

**Tamaño original:** 467.786 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 467.786 B | 1,0000 | 0,00 % | 0,009760 s / 20,2 ms |
| gzip nivel 1 | 27.510 B | 0,0588 | 94,12 % | 0,007075 s / 13,6 ms |
| gzip nivel 6 | 28.129 B | 0,0601 | 93,99 % | 0,008855 s / 15,0 ms |
| gzip nivel 9 | 27.695 B | 0,0592 | 94,08 % | 0,012549 s / 16,4 ms |
| Brotli calidad 5 | 10.583 B | 0,0226 | 97,74 % | 0,009813 s / 13,6 ms |
| Brotli calidad 11 | 12.019 B | 0,0257 | 97,43 % | 0,887716 s / 17,0 ms |

---

## datos.json

**Tamaño original:** 693.789 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 693.789 B | 1,0000 | 0,00 % | 0,013291 s / 23,0 ms |
| gzip nivel 1 | 33.388 B | 0,0481 | 95,19 % | 0,009423 s / 14,8 ms |
| gzip nivel 6 | 34.426 B | 0,0496 | 95,04 % | 0,010710 s / 15,2 ms |
| gzip nivel 9 | 33.877 B | 0,0488 | 95,12 % | 0,017567 s / 13,6 ms |
| Brotli calidad 5 | 15.019 B | 0,0216 | 97,84 % | 0,013639 s / 15,2 ms |
| Brotli calidad 11 | 15.057 B | 0,0217 | 97,83 % | 1,492270 s / 16,2 ms |

---

## grafico.svg

**Tamaño original:** 316.968 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 316.968 B | 1,0000 | 0,00 % | 0,009908 s / 21,0 ms |
| gzip nivel 1 | 8.962 B | 0,0283 | 97,17 % | 0,005509 s / 14,6 ms |
| gzip nivel 6 | 8.662 B | 0,0273 | 97,27 % | 0,006231 s / 12,4 ms |
| gzip nivel 9 | 8.533 B | 0,0269 | 97,31 % | 0,007328 s / 14,8 ms |
| Brotli calidad 5 | 3.970 B | 0,0125 | 98,75 % | 0,006650 s / 15,8 ms |
| Brotli calidad 11 | 4.387 B | 0,0138 | 98,62 % | 0,794729 s / 15,8 ms |

---

## feed.xml

**Tamaño original:** 501.822 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 501.822 B | 1,0000 | 0,00 % | 0,011996 s / 23,2 ms |
| gzip nivel 1 | 22.949 B | 0,0457 | 95,43 % | 0,007548 s / 15,2 ms |
| gzip nivel 6 | 23.151 B | 0,0461 | 95,39 % | 0,008871 s / 14,0 ms |
| gzip nivel 9 | 22.792 B | 0,0454 | 95,46 % | 0,013113 s / 14,2 ms |
| Brotli calidad 5 | 8.529 B | 0,0170 | 98,30 % | 0,010054 s / 16,6 ms |
| Brotli calidad 11 | 10.150 B | 0,0202 | 97,98 % | 1,163554 s / 18,0 ms |

---

## lorem.txt

**Tamaño original:** 1.200.000 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 1.200.000 B | 1,0000 | 0,00 % | 0,017376 s / 25,2 ms |
| gzip nivel 1 | 7.696 B | 0,0064 | 99,36 % | 0,009574 s / 15,4 ms |
| gzip nivel 6 | 4.201 B | 0,0035 | 99,65 % | 0,011520 s / 12,8 ms |
| gzip nivel 9 | 4.201 B | 0,0035 | 99,65 % | 0,010646 s / 13,6 ms |
| Brotli calidad 5 | 145 B | 0,0001 | 99,99 % | 0,007120 s / 16,0 ms |
| Brotli calidad 11 | 97 B | 0,0001 | 99,99 % | 0,026113 s / 13,0 ms |

---

## imagen.png

**Tamaño original:** 7.112 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 7.112 B | 1,0000 | 0,00 % | 0,003189 s / 13,2 ms |
| gzip nivel 1 | 7.112 B | 1,0000 | 0,00 % | 0,003960 s / 14,0 ms |
| gzip nivel 6 | 7.112 B | 1,0000 | 0,00 % | 0,003833 s / 13,2 ms |
| gzip nivel 9 | 7.112 B | 1,0000 | 0,00 % | 0,003341 s / 13,8 ms |
| Brotli calidad 5 | 7.112 B | 1,0000 | 0,00 % | 0,004313 s / 16,4 ms |
| Brotli calidad 11 | 7.112 B | 1,0000 | 0,00 % | 0,004095 s / 13,0 ms |

---

## foto.jpg

**Tamaño original:** 8.853 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 8.853 B | 1,0000 | 0,00 % | 0,003577 s / 13,0 ms |
| gzip nivel 1 | 8.853 B | 1,0000 | 0,00 % | 0,003543 s / 14,6 ms |
| gzip nivel 6 | 8.853 B | 1,0000 | 0,00 % | 0,003799 s / 12,8 ms |
| gzip nivel 9 | 8.853 B | 1,0000 | 0,00 % | 0,003049 s / 12,6 ms |
| Brotli calidad 5 | 8.853 B | 1,0000 | 0,00 % | 0,004368 s / 14,8 ms |
| Brotli calidad 11 | 8.853 B | 1,0000 | 0,00 % | 0,003783 s / 12,8 ms |

---

## clip.mp4

**Tamaño original:** 541.196 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 541.196 B | 1,0000 | 0,00 % | 0,011579 s / 20,6 ms |
| gzip nivel 1 | 541.196 B | 1,0000 | 0,00 % | 0,013057 s / 22,0 ms |
| gzip nivel 6 | 541.196 B | 1,0000 | 0,00 % | 0,013709 s / 20,8 ms |
| gzip nivel 9 | 541.196 B | 1,0000 | 0,00 % | 0,011808 s / 21,8 ms |
| Brotli calidad 5 | 541.196 B | 1,0000 | 0,00 % | 0,017909 s / 25,0 ms |
| Brotli calidad 11 | 541.196 B | 1,0000 | 0,00 % | 0,012484 s / 22,2 ms |

---

## paquete.zip

**Tamaño original:** 6.319 B

| Algoritmo / nivel | Tamaño | Ratio | Ahorro % | Tiempo / CPU |
|---|---:|---:|---:|---:|
| Sin comprimir (base) | 6.319 B | 1,0000 | 0,00 % | 0,003360 s / 14,0 ms |
| gzip nivel 1 | 6.319 B | 1,0000 | 0,00 % | 0,003435 s / 14,8 ms |
| gzip nivel 6 | 6.319 B | 1,0000 | 0,00 % | 0,003289 s / 12,6 ms |
| gzip nivel 9 | 6.319 B | 1,0000 | 0,00 % | 0,003219 s / 11,8 ms |
| Brotli calidad 5 | 6.319 B | 1,0000 | 0,00 % | 0,003651 s / 13,8 ms |
| Brotli calidad 11 | 6.319 B | 1,0000 | 0,00 % | 0,003453 s / 13,0 ms |

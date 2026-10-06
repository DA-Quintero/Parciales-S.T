#!/bin/bash

ALGORITMO=$1
NIVEL=$2
ENCODING=$3

URL="http://parcial.empresa.local"
IP="192.168.50.2"

# Más repeticiones para que la diferencia de CPU sea medible
REPETICIONES=20

ARCHIVOS="index.html estilos.css estilos.min.css app.js datos.json grafico.svg feed.xml lorem.txt imagen.png foto.jpg clip.mp4 paquete.zip"

CGROUP=$(systemctl show apache2.service -p ControlGroup --value)
CPU_STAT="/sys/fs/cgroup${CGROUP}/cpu.stat"

get_cpu_usec() {
    awk '/^usage_usec / {print $2}' "$CPU_STAT"
}

for ARCHIVO in $ARCHIVOS
do

    # Solicitud de calentamiento; no se registra
    curl --resolve parcial.empresa.local:80:$IP \
         -s \
         -H "Accept-Encoding: $ENCODING" \
         -o /dev/null \
         "$URL/$ARCHIVO"

    TMP=$(mktemp)

    CPU_INICIO=$(get_cpu_usec)

    for i in $(seq 1 $REPETICIONES)
    do
        curl --resolve parcial.empresa.local:80:$IP \
             -s \
             -H "Accept-Encoding: $ENCODING" \
             -o /dev/null \
             -w "%{size_download},%{time_total}\n" \
             "$URL/$ARCHIVO" >> "$TMP"
    done

    CPU_FIN=$(get_cpu_usec)

    TAMANO=$(awk -F, 'NR==1 {print $1}' "$TMP")

    TIEMPO=$(awk -F, \
        '{s+=$2} END {printf "%.6f", s/NR}' \
        "$TMP")

    # usage_usec -> promedio de CPU por petición en ms
    CPU_MS=$(awk \
        -v inicio="$CPU_INICIO" \
        -v fin="$CPU_FIN" \
        -v n="$REPETICIONES" \
        'BEGIN {printf "%.3f", ((fin-inicio)/1000)/n}')

    echo "$ALGORITMO,$NIVEL,$ARCHIVO,$TAMANO,$TIEMPO,$CPU_MS"

    rm "$TMP"

done

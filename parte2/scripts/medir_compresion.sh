#!/bin/bash
BASE="http://192.168.56.10"
for archivo in index_test.html estilos.css app.js datos.json grafico.svg lorem.txt foto.jpg paquete.zip; do
    echo "=== $archivo ==="
    echo -n "SIN: "
    curl -s -H 'Accept-Encoding: identity' -o /dev/null -w '%{size_download}B t=%{time_total}s\n' $BASE/$archivo
    echo -n "GZIP6: "
    curl -s -H 'Accept-Encoding: gzip' -o /dev/null -w '%{size_download}B t=%{time_total}s\n' $BASE/$archivo
    echo -n "BR: "
    curl -s -H 'Accept-Encoding: br' -o /dev/null -w '%{size_download}B t=%{time_total}s\n' $BASE/$archivo
    echo ""
done

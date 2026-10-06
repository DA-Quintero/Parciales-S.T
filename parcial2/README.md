\# Segundo parcial - Servicios Telemáticos



Hostnames: srv1-2230532, srv2-2230532, cliente-2230532 (Vagrant, Ubuntu 22.04).



\## Direccionamiento (distinto al del diagrama)

\- IP pública de srv1 (red cliente-srv1): 192.168.56.10

\- srv1 red interna: 192.168.50.3 | srv2: 192.168.50.2

\- cliente: 192.168.56.20 (sin ruta a la red interna)



\## Certificados

La CA y el certificado de servidor se regeneraron con OpenSSL para este entorno

(SAN con IP 192.168.56.10). Las llaves privadas no se incluyen en el repositorio.



\## Estructura

\- parte1-ftps/: before.rules, vsftpd.conf, evidencias UFW/NAT y openssl s\_client

\- parte2-dot/: resolved.conf y resolvectl status

\- parte3-sftp/: sshd\_config, before.rules, evidencias UFW/NAT y comparativa

\- capturas/: ftp\_plano, ftps, dot, dns\_plano y sftp (.pcap)


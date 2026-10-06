# Comparativa FTPS vs SFTP

Segundo Parcial, Servicios Telemáticos, Tercera Parte, punto 19.
Código: 2230608

## Tabla comparativa

| Criterio | FTPS (vsftpd + TLS explícito) | SFTP (OpenSSH) |
|---|---|---|
| Protocolo base | FTP con una capa TLS (RFC 4217). Se negocia con `AUTH TLS`. | Subsistema del protocolo SSH-2. No es FTP. |
| Número de conexiones y puertos | Dos conexiones: control (21/tcp) y datos (rango pasivo 50000-50010/tcp, una conexión por transferencia o listado). | Una sola conexión: 22/tcp en srv2 (2222/tcp publicado en srv1). |
| Autenticación del servidor | Certificado X.509 firmado por una CA. El cliente lo valida con `ca.crt` (`Verify return code: 0 (ok)`). | Clave de host SSH. El cliente confía en la huella la primera vez (TOFU) y la guarda en `known_hosts`. |
| Momento en que inicia el cifrado | Después de la conexión TCP y del saludo FTP en claro, cuando el cliente envía `AUTH TLS` y se hace el handshake TLS. | Desde el principio: tras el intercambio de versiones `SSH-2.0` en claro, el intercambio de claves cifra todo lo demás. |
| Facilidad para atravesar firewall/NAT | Difícil. Exige abrir el rango pasivo, que coincida con `pasv_min_port`/`pasv_max_port`, y configurar `pasv_address`. El firewall no puede inspeccionar el canal cifrado para abrir puertos dinámicos. | Fácil. Un solo puerto y una regla de reenvío. No depende de ninguna IP anunciada. |
| Facilidad de configuración | Más compleja: certificados y CA, opciones TLS, modo pasivo, NAT y reglas de firewall coherentes entre sí. | Más simple: `Match User`, `ChrootDirectory` y `ForceCommand internal-sftp` en `sshd_config`. |

## Evidencias propias del laboratorio

| Aspecto | FTPS | SFTP |
|---|---|---|
| Reglas DNAT en srv1 | 2 (puerto 21 y rango 50000:50010) | 1 (2222 -> 192.168.50.2:22) |
| Reglas `ufw route allow` | 2 (21 y 50000:50010) | 1 (22) |
| Parámetros adicionales en el servidor | `pasv_min_port`, `pasv_max_port`, `pasv_address=192.168.56.11`, certificado y clave | Ninguno fuera del bloque `Match User` |
| Cifrado negociado | TLS 1.3, `TLS_AES_256_GCM_SHA384` | Canal SSH cifrado (ECDH), host key ED25519 |
| Visible en la captura | `USER`/`PASS` no aparecen: tras `AUTH TLS` todo va en TLS (`ftps.pcap`). | Solo versiones SSH e intercambio de claves; después, paquetes cifrados (`sftp.pcap`). |

## Conclusión

Con restricciones de firewall estrictas, **SFTP es más adecuado**.

- En mis pruebas, SFTP necesitó **un puerto, una regla DNAT y una regla `ufw route`**. FTPS necesitó dos reglas DNAT, dos reglas de ruta y un rango de 11 puertos abiertos.
- En FTPS, si el rango pasivo del servidor no coincide con las reglas del firewall, o si `pasv_address` no se configura detrás de NAT, el login funciona pero el listado y las transferencias fallan. Con TLS el firewall no puede leer el comando `PASV` para abrir esos puertos dinámicamente.
- SFTP encapsula autenticación y datos en un único canal cifrado, por lo que la superficie expuesta es mínima y la política de firewall es fácil de auditar.

FTPS sigue siendo útil cuando se necesita compatibilidad con clientes FTP existentes o una infraestructura de certificados X.509 ya establecida.
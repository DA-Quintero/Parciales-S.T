\# Comparativa FTPS vs SFTP



| Criterio | FTPS (vsftpd, TLS explícito) | SFTP (OpenSSH) |

|---|---|---|

| Protocolo base | FTP con TLS (comando AUTH TLS) | Subsistema sftp sobre SSH; no es FTP |

| Conexiones y puertos | Control en el 21 y una conexión de datos por operación en el rango pasivo 50000-50010. En mi captura: 4 conexiones TCP (puertos 21, 50007, 50010) | Una sola conexión TCP (22 en srv2, publicada como 2222). En mi captura: 1 conexión para ls, put y get |

| Autenticación del servidor | Certificado X.509 firmado por mi CA; verificado con Verify return code 0 y huella SHA-256 coincidente en FileZilla | Clave de host SSH; verificada por huella ED25519 en la primera conexión (sin CA) |

| Inicio del cifrado | Tras conectar al 21 y enviar AUTH TLS: el banner y AUTH TLS viajan en claro, luego handshake TLS 1.3 | Tras el intercambio de versiones SSH-2.0 (en claro) y de claves; todo lo posterior va cifrado |

| Firewall / NAT | Difícil: DNAT del 21 y del rango pasivo, dos reglas ufw route y pasv\_address con la IP pública | Fácil: un DNAT (2222 a 22) y una regla ufw route |

| Facilidad de configuración | Mayor: CA y certificado, vsftpd.conf (ssl\_\* y pasv\_\*), rango pasivo coherente con el firewall | Menor: OpenSSH ya instalado; Match User, ChrootDirectory y ForceCommand internal-sftp |

| Visible en la captura | FTP plano: USER, PASS y contenido. FTPS: AUTH TLS y handshake; datos cifrados en puertos pasivos | Solo los banners SSH-2.0 y el intercambio de claves; el resto es Encrypted packet |



\## Conclusión



Para un entorno con restricciones estrictas de firewall es más adecuado SFTP.

Mis evidencias lo muestran: con FTPS necesité abrir el puerto 21 y un rango

pasivo de 11 puertos, con dos reglas ufw route. Con solo el 21 abierto, el login

funcionó pero el listado se quedó colgado en el puerto pasivo 50002 hasta

agregar el rango, y además hubo que configurar pasv\_address con la IP pública.

Como el canal de control va cifrado, el firewall no puede deducir ni abrir

dinámicamente los puertos de datos. Con SFTP bastó un DNAT y una regla

ufw route para el 22, y una sola conexión llevó autenticación y datos.

FTPS sigue siendo útil cuando se necesita compatibilidad con clientes y

servidores FTP existentes, o autenticación basada en certificados de una CA.


# Comparación entre FTPS y SFTP

## Tabla comparativa

| Criterio | FTPS | SFTP |
|---|---|---|
| **Protocolo base** | FTP protegido mediante TLS. | SSH (Secure Shell). |
| **Servicio utilizado en la práctica** | `vsftpd` configurado con TLS explícito. | OpenSSH con `internal-sftp`. |
| **Puerto externo utilizado** | `21/tcp` para el canal de control y `50000:50010/tcp` para conexiones pasivas de datos. | `2222/tcp` en el Servidor 1, reenviado al puerto `22/tcp` del Servidor 2. |
| **Número de conexiones** | Utiliza varias conexiones: una para control y conexiones adicionales para transferencia de datos. | Utiliza una sola conexión SSH para autenticación, comandos y transferencia de archivos. |
| **Canal de control** | Puerto `21/tcp`. | Forma parte de la misma sesión SSH. |
| **Canal de datos** | Usa conexiones independientes dentro del rango pasivo `50000:50010/tcp`. | Los datos viajan por el mismo canal SSH cifrado. |
| **Autenticación del servidor** | Se realiza mediante un certificado digital X.509. En la práctica se utilizó un certificado de servidor firmado por una CA propia. | Se realiza mediante la clave de host SSH del servidor. En la primera conexión se verifica su huella digital. |
| **Autenticación del usuario** | Usuario y contraseña protegidos por TLS una vez activado el cifrado. | Usuario y contraseña protegidos dentro de la sesión SSH cifrada. |
| **Inicio del cifrado** | La conexión inicia como FTP y posteriormente el cliente solicita TLS mediante el comando `AUTH TLS`. | El cifrado se establece durante la negociación inicial de SSH antes de la autenticación y de la transferencia de archivos. |
| **Protección de los datos** | El canal de control y los canales de datos quedan cifrados mediante TLS. | Autenticación, comandos y archivos viajan cifrados dentro de la misma sesión SSH. |
| **Certificados / claves** | Requiere certificado de servidor y clave privada; para validar confianza puede utilizarse una CA. | Requiere las claves de host de OpenSSH; no necesita certificados X.509 para el funcionamiento básico. |
| **Configuración detrás de NAT** | Requiere configurar correctamente `pasv_address` con la dirección utilizada por el cliente y reenviar tanto el puerto 21 como el rango pasivo. | Solo requiere reenviar el puerto externo seleccionado hacia el puerto 22 del servidor SFTP. |
| **Configuración del firewall** | Más compleja, porque deben permitirse el canal de control y el rango de puertos pasivos. | Más sencilla, porque toda la comunicación utiliza un único puerto TCP. |
| **Reglas utilizadas en esta práctica** | DNAT del puerto `21` y del rango `50000:50010` desde el Servidor 1 hacia el Servidor 2, además de reglas `ufw route allow`. | DNAT `2222 → 192.168.50.2:22` y una regla `ufw route allow` hacia el puerto 22 del Servidor 2. |
| **Comportamiento con firewall estricto** | Requiere más reglas y coordinación entre el rango pasivo de `vsftpd`, UFW y NAT. | Se adapta mejor a políticas restrictivas porque necesita una sola conexión y un solo puerto publicado. |
| **Evidencia en Wireshark** | Se observa `AUTH TLS`, el handshake TLS en el puerto 21 y tráfico cifrado en las conexiones pasivas. | Se observa el intercambio de versiones `SSH-2.0`, el intercambio de claves y después tráfico SSH cifrado sobre una sola conexión TCP. |
| **Información visible sin cifrado** | En FTP plano se pueden observar `USER`, `PASS`, comandos y contenido de archivos. | SFTP no utiliza una fase equivalente en texto plano para autenticación o transferencia de archivos. |
| **Facilidad de configuración** | Mayor complejidad por certificados, TLS, modo pasivo, rango de puertos, `pasv_address`, DNAT y reglas de firewall. | Menor complejidad de red: OpenSSH, usuario restringido, `ChrootDirectory`, `ForceCommand internal-sftp`, un DNAT y una regla de reenvío. |
| **Facilidad de administración** | Requiere mantener sincronizada la configuración de `vsftpd`, certificados y reglas de firewall/NAT. | La administración de red es más simple porque utiliza un único canal, aunque se deben configurar correctamente permisos y `chroot`. |

## Conclusión

De acuerdo con las pruebas realizadas, **SFTP es más adecuado para un entorno con restricciones estrictas de firewall**.

En FTPS fue necesario permitir y reenviar el puerto `21/tcp` para el canal de control y el rango `50000:50010/tcp` para las conexiones pasivas de datos. Además, fue necesario configurar `pasv_address` de forma coherente con la dirección del Servidor 1 utilizada por el cliente y mantener sincronizada esa configuración con las reglas de UFW y NAT.

En SFTP, en cambio, toda la autenticación, los comandos y la transferencia de archivos utilizaron una sola conexión SSH. En la práctica se publicó el puerto `2222/tcp` del Servidor 1 y se redirigió hacia `192.168.50.2:22` en el Servidor 2. Esto redujo la cantidad de reglas necesarias y simplificó el paso a través del firewall y NAT.

Las capturas también mostraron la diferencia: FTPS utiliza un canal de control y conexiones adicionales para datos, mientras que SFTP mantiene toda la comunicación cifrada dentro de un único canal SSH. Por esta razón, **SFTP presenta una configuración de firewall más simple y predecible en este escenario**.

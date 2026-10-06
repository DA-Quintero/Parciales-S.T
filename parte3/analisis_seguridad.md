# Análisis de Seguridad — Túnel Cloudflared

## Riesgos
1. **Superficie de exposición**: cualquier persona con la URL puede acceder al servidor
2. **Sin autenticación**: no hay control de acceso por defecto
3. **URL impredecible pero pública**: cualquiera que la conozca entra
4. **Sin límite de sesión en plan gratuito**: el túnel puede caerse sin aviso

## Mitigaciones
1. **Autenticación básica**: agregar .htaccess con usuario/contraseña
2. **Apagar el túnel al terminar**: nunca dejarlo activo más de lo necesario
3. **Restricción por IP**: configurar Apache para limitar acceso por IP
4. **Usar cuenta Cloudflare**: permite más control, logs y túneles nombrados

# Casa Clara

App web de finanzas familiares para Eli y Wil. Incluye vista individual y familiar, movimientos, saldos, gastos por categoría y calendario de pagos importantes.

## Ejecutar

Abre `index.html` en un navegador o visita la publicación de GitHub Pages. La app muestra un acceso real conectado a Supabase y conserva una opción de demo local para revisar la interfaz sin una cuenta.

El workflow de GitHub Pages en `.github/workflows/deploy-pages.yml` publica automáticamente el sitio después de cada push a `main` o `master`.

## Conexión real y permisos

La carpeta `supabase/schema.sql` contiene el esquema con usuarios, cuentas personales/compartidas y políticas RLS. El proyecto Casa Clara ya está creado en Supabase y `supabase-config.js` contiene únicamente la URL y la clave pública del navegador; nunca se publica una clave secreta.

La configuración inicial del hogar ya está creada en Supabase para Eli y Wil, con una cuenta personal por persona y una cuenta compartida. La invitación vigente de Eli se envió al correo corregido; Wil ya tiene su cuenta activa. Al abrir una invitación, la app permite crear la contraseña inicial sin conocer una contraseña previa.

- Cada usuario consulta sus cuentas personales y las cuentas compartidas de su hogar.
- Los movimientos nuevos se guardan en `transactions` con el usuario que los creó.
- Los pagos importantes se guardan en `recurring_payments`.
- La vista familiar consolida los datos permitidos por las políticas RLS.
- La URL de autenticación de Supabase apunta al sitio publicado en GitHub Pages; no se debe usar `localhost` desde un teléfono.

Consulta `DOCUMENTACION.md` para el procedimiento completo y el estado actual del proyecto.

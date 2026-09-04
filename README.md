# Casa Clara

App web de finanzas familiares para Eli y Wil. Incluye vista individual y familiar, movimientos, saldos, gastos por categoría y calendario de pagos importantes.

## Ejecutar

Abre `index.html` en un navegador. Los movimientos nuevos se guardan en el almacenamiento local del navegador.

El workflow de GitHub Pages en `.github/workflows/deploy-pages.yml` publica automáticamente el sitio después de cada push a `main` o `master`.

## Conexión real y permisos

La carpeta `supabase/schema.sql` contiene el esquema de producción con usuarios, cuentas personales/compartidas y políticas RLS. Para activar la conexión real:

1. Crea un proyecto Supabase y ejecuta el archivo SQL.
2. Crea los usuarios Eli y Wil en Authentication.
3. Añade ambos usuarios a la misma fila de `households` mediante `household_members`.
4. Configura las variables `SUPABASE_URL` y `SUPABASE_ANON_KEY` en el frontend.

La versión actual funciona como demo local para validar la experiencia antes de conectar credenciales y despliegue.

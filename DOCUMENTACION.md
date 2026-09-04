# Casa Clara · Documentación del proyecto

## Propósito

Casa Clara es una app web para que Eli y Wil registren movimientos, consulten saldos, revisen gastos y no dejen pasar pagos importantes. Incluye una vista individual protegida y una vista familiar conjunta.

## Repositorio y publicación

- Repositorio: https://github.com/wtellezf-netizen/Finance
- Rama principal: `main`
- Sitio publicado: https://wtellezf-netizen.github.io/Finance/
- Publicación: GitHub Actions mediante `.github/workflows/deploy-pages.yml`

## Estado de la conexión

El proyecto Supabase `casa-clara` ya fue creado en la organización Casa Clara, en East US (Ohio), plan Free. El archivo `supabase/schema.sql` fue ejecutado correctamente en el SQL Editor y creó las tablas, funciones y políticas de seguridad.

La configuración inicial también quedó realizada: hay un hogar Casa Clara, dos miembros con los nombres Eli y Wil, y tres cuentas (una personal para cada miembro y una compartida). La invitación vigente de Eli fue enviada al correo corregido y Wil ya tiene su cuenta activa. El usuario anterior creado con el correo equivocado no fue eliminado para conservar trazabilidad, pero fue retirado del hogar y ya no es propietario de ninguna cuenta financiera.

En Supabase Auth → URL Configuration, `Site URL` y el redirect permitido apuntan a `https://wtellezf-netizen.github.io/Finance/`. Por eso las invitaciones deben abrirse desde el enlace más reciente; un enlace antiguo que apunte a `localhost:3000` ya no es válido para un teléfono.

La app carga Supabase mediante:

- `supabase-config.js`: URL del proyecto y clave pública para el navegador.
- `supabase-client.js`: inicio/cierre de sesión, lectura de datos y alta de movimientos.
- `app.js`: interfaz, filtros, saldos, pagos y consolidado familiar.

No se incluye ninguna clave secreta en el repositorio. La clave pública está diseñada para usarse en el frontend y las políticas RLS limitan los datos que puede leer o modificar cada sesión.

## Estructura de datos

- `households`: hogar familiar.
- `household_members`: relación entre usuarios, hogar y nombre visible (`Eli` o `Wil`).
- `accounts`: cuentas personales o compartidas, con saldo inicial.
- `transactions`: ingresos y gastos por cuenta.
- `recurring_payments`: pagos importantes con día de vencimiento y estado.

## Permisos

Las políticas RLS permiten que un miembro vea los datos autorizados de su hogar para construir el consolidado. La interfaz personal muestra la cuenta propia y las cuentas compartidas. Cada persona solo puede guardar movimientos y pagos en su cuenta o en la cuenta compartida; el informe familiar reúne los registros permitidos por Supabase.

## Activación de Eli y Wil

La asociación de usuarios ya está hecha en el proyecto actual. Para completar el acceso, Eli debe abrir la invitación más reciente y Wil puede entrar con su cuenta activa desde el sitio publicado. Si se necesita repetir la configuración en otro proyecto, el procedimiento es:

1. En Supabase, abre Authentication → Users y crea los dos usuarios con sus correos. No compartas contraseñas en el repositorio.
2. Copia los UUID de ambos usuarios.
3. En el SQL Editor, crea un hogar y asocia los dos usuarios con sus nombres visibles:

```sql
with new_home as (
  insert into public.households (name) values ('Casa Clara') returning id
)
insert into public.household_members (household_id, user_id, display_name, role)
select new_home.id, 'UUID_DE_ELI', 'Eli', 'owner' from new_home
union all
select new_home.id, 'UUID_DE_WIL', 'Wil', 'member' from new_home;
```

4. Crea las cuentas personales y compartida asociadas al mismo `household_id`.
5. Cada usuario acepta la invitación, define su contraseña y entra en la app. El botón “Vista familiar” consolida el hogar.

## Demo local

El botón “Ver la demo local” usa datos de ejemplo y `localStorage`. Sirve para revisar la experiencia sin afectar Supabase. Los registros de la demo no se mezclan con los datos reales.

## Próximo paso recomendado

Eli debe aceptar la invitación más reciente enviada a su correo corregido y entrar en el sitio publicado. Después, ambos pueden registrar sus saldos iniciales reales y sus primeros movimientos. No es necesario compartir contraseñas.

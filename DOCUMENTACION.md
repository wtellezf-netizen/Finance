# Casa Clara · Documentación del proyecto

## 1. Resumen

Casa Clara es una app web de finanzas familiares para Eli y Wil. Permite revisar saldos, registrar ingresos y gastos, identificar pagos importantes y consultar un informe individual o combinado del hogar.

- Repositorio: https://github.com/wtellezf-netizen/Finance
- Rama principal: main
- Sitio publicado: https://wtellezf-netizen.github.io/Finance/
- Moneda de la demo: USD

## 2. Funcionalidades implementadas

- Selector de perfil para Eli, Wil y Vista familiar.
- Saldos disponibles, ingresos y gastos del mes.
- Gráfico de ingresos frente a gastos.
- Últimos movimientos con categoría, cuenta y monto.
- Filtros y búsqueda de movimientos.
- Registro de nuevos movimientos.
- Calendario de pagos importantes con estado pendiente o pagado.
- Informe familiar: saldo combinado, ingresos, gastos, ahorro y aporte de cada persona.
- Objetivo de ahorro familiar.
- Diseño adaptable para escritorio y móvil.

## 3. Estado actual de los datos

La versión publicada funciona en modo demo local: los movimientos nuevos se guardan en localStorage del navegador. Esto permite validar la experiencia sin poner datos financieros reales en el repositorio.

El selector Eli/Wil de la demo es visual y no reemplaza un inicio de sesión real. Para producción se debe activar Supabase y aplicar las políticas RLS descritas en la siguiente sección.

## 4. Conexión y permisos con Supabase

El archivo supabase/schema.sql crea estas entidades:

- households: hogar compartido.
- household_members: miembros Eli y Wil con rol.
- accounts: cuentas personales o compartidas.
- transactions: ingresos y gastos.
- recurring_payments: pagos importantes.

Las políticas RLS permiten que cada usuario vea las cuentas de su hogar, consulte la cuenta compartida y registre movimientos con su propia identidad. Las cuentas personales y los cambios de cada movimiento quedan asociados al usuario autenticado.

### Activación

1. Crear un proyecto en Supabase.
2. Ejecutar supabase/schema.sql desde el SQL Editor.
3. Crear a Eli y Wil en Authentication > Users.
4. Crear un hogar y añadir ambos usuarios en household_members.
5. Crear las cuentas personales y compartida en accounts.
6. Configurar SUPABASE_URL y SUPABASE_ANON_KEY en el frontend.
7. Sustituir el adaptador local por lecturas y escrituras autenticadas a Supabase.

Nunca subir una service role key ni contraseñas al repositorio. Solo la clave pública anon puede vivir en el frontend.

## 5. Despliegue

El workflow .github/workflows/deploy-pages.yml publica automáticamente el contenido estático en GitHub Pages cuando hay cambios en main o master. La primera ejecución fue verificada como exitosa y Pages está configurado con fuente GitHub Actions.

## 6. Historial publicado

- Lanzamiento inicial de Casa Clara: interfaz y demo funcional.
- Añade esquema Supabase y permisos RLS: estructura de datos y acceso.
- Configura publicación automática en GitHub Pages: workflow de despliegue.

## 7. Próximos pasos recomendados

- Conectar Supabase y habilitar login por correo para Eli y Wil.
- Añadir edición y eliminación controlada de movimientos.
- Configurar recordatorios de pagos por correo o notificación.
- Cambiar la moneda desde Configuración.
- Añadir exportación CSV/PDF del informe familiar.

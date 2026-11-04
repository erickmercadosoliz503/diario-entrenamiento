# Publicar en Google Play

La app es una PWA. Para Play se empaqueta como **Trusted Web Activity (TWA)**: un APK/AAB que abre la web a pantalla completa, sin barra del navegador.

## 1. Cuenta de desarrollador
- Alta en https://play.google.com/console (pago único de 25 USD + verificación de identidad).
- Para vender apps de pago: perfil de pagos (Payments profile) con datos fiscales y cuenta bancaria.
- Cuentas personales nuevas: Google exige una **prueba cerrada con al menos 12 testers durante 14 días** antes de poder publicar en producción.

## 2. Generar el paquete Android
1. Abrir https://www.pwabuilder.com e introducir `https://erickmercadosoliz503.github.io/diario-entrenamiento/`.
2. Package for stores → Android → Options:
   - Package ID: `io.github.erickmercadosoliz503.diario`
   - App name: Diario de entrenamiento · Launcher name: Diario
   - Signing key: *Create new* (¡guardar el .keystore y las contraseñas! sin ellos no se pueden publicar actualizaciones).
3. Descargar el ZIP: contiene el `.aab` (subir a Play) y `assetlinks.json`.

## 3. Verificar el dominio (Digital Asset Links)
Android exige el archivo en la **raíz del dominio**:
`https://erickmercadosoliz503.github.io/.well-known/assetlinks.json`

Con GitHub Pages eso implica crear el repo **`erickmercadosoliz503.github.io`** (público) con:
- `.nojekyll` (vacío, para que GitHub publique la carpeta `.well-known`)
- `.well-known/assetlinks.json` (el del ZIP de PWABuilder)

Después de subir el AAB, añadir también la huella SHA-256 de **Play App Signing** (Play Console → Configuración → Integridad de la app) al `assetlinks.json`; si no, la app muestra la barra del navegador.

## 4. Ficha en Play Console
- Icono 512×512: `icons/icon-512.png`
- Gráfico destacado 1024×500 y al menos 2 capturas de móvil.
- Política de privacidad: `https://erickmercadosoliz503.github.io/diario-entrenamiento/privacidad.html`
- Borrado de cuenta (URL obligatoria): `https://erickmercadosoliz503.github.io/diario-entrenamiento/borrar-cuenta.html`
- Seguridad de los datos: se recogen correo, nombre, datos de actividad física/salud introducidos por el usuario y fotos; cifrados en tránsito; el usuario puede borrarlos; no se comparten.
- Categoría: Salud y bienestar. Clasificación de contenido: cuestionario IARC.
- Precio: app de pago.

## 5. Actualizaciones
Cambios en la web (este repo) se ven en la app sin pasar por Play. Solo hay que subir un AAB nuevo si cambian el icono, el nombre o la configuración Android.

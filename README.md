# BoviControl

Proyecto de Aula Interdisciplinario de Eder Castro, Mateo Garrido y Andrea Galeano. Spring Boot + MySQL + optimización de atenciones veterinarias + Power BI.

Esta copia conserva el historial de https://github.com/castrorojaseder565-jpg/Proyecto_de_aula y añade la implementación y evidencias del integrador. Se publica desde la cuenta autorizada mgaleano2601-arch.

## Componentes
- `ganadoapp-main/`: Java 21, Spring Boot 3.3.4, Thymeleaf, JPA, seguridad y módulo IO.
- `ganadoapp-main/optimizer-api/`: FastAPI, PuLP y CBC. Contrato REST de asignación binaria.
- `analitica/BoviControl.pbix`: informe interactivo verificado en Power BI Desktop, con datos ficticios cargados.
- `analitica/PowerBI/`: proyecto editable PBIP/PBIR. Mantener sus carpetas juntas.
- `analitica/DataWarehouse/`: DDL/carga MySQL y base SQLite de demostración.
- `base_datos/BoviControl.sql`: dump operacional de demostración.

## Ejecutar la aplicación
Requisitos: Java 21, Maven 3.9 o wrapper, Python compatible con requirements.txt y MySQL 8.4. Crear una base aislada vacía `bovicontrol_taller` y un usuario con permisos sobre ella. Desde `ganadoapp-main`, copiar `.env.example` a `.env`; configurar TALLER_DB_URL, TALLER_DB_USER, TALLER_DB_PASSWORD y credenciales propias para el administrador inicial. Activar APP_BOOTSTRAP_ADMIN_ENABLED=true y completar `app.taller.demo-password`. No publicar `.env`.

En una terminal dentro de `ganadoapp-main/optimizer-api`:
```powershell
python -m venv .venv
.venv/Scripts/python -m pip install -r requirements.txt
.venv/Scripts/python -m uvicorn main:app --host 127.0.0.1 --port 8000
```
En otra terminal dentro de `ganadoapp-main`:
```powershell
./mvnw.cmd spring-boot:run '-Dspring-boot.run.arguments=--spring.profiles.active=taller --app.taller.seed=true'
```
Abrir http://127.0.0.1:8081. La jornada de demostración es 2026-11-04. Se esperan tres atenciones asignadas y objetivo 7. El perfil taller solo debe utilizarse en una base aislada. Desactivar semilla y bootstrap después de inicializar. El dump operacional es una alternativa para restaurar evidencia en otra base vacía y contiene cuentas sintéticas con hashes; no distribuye sus contraseñas.

## Power BI
Descargar `analitica/BoviControl.pbix` y abrirlo en Power BI Desktop. Resumen, Vacunacion y Produccion se verificaron con 24 animales, 72 aplicaciones y 22595,22 litros. El filtro Holstein da 8 animales, 24 aplicaciones y 7331,85 litros. Datos ficticios con corte fijo 2026-10-07; no son producción de una finca. El menú de la aplicación permite descargar el mismo archivo. No se requiere publicar en Power BI Service para abrirlo localmente.

El modelo analítico utiliza datos incorporados con Power Query; no hay refresco automático desde MySQL operacional. El script DW se ejecutó en MySQL 8.4.4 en un esquema de verificación y sus resultados coinciden con SQLite.

## Pruebas y LLM
`./mvnw.cmd test` con el perfil y MySQL configurados; para Python instalar `requirements-test.txt` y ejecutar `python -m pytest test_optimizer.py`. Ocho pruebas Java, siete Python y dieciocho verificaciones HTTP/MySQL aprobadas. El chatbot utiliza Groq mediante Java HttpClient si se configura GROQ_API_KEY; sin ella usa reglas limitadas. La respuesta externa requiere una clave propia y no se acredita mediante la prueba local sin clave. No se incluyen claves en el repositorio.

## Documentación y evidencia
Los cuatro informes finales están en `documentacion/`. Las capturas reales de Power BI, resultados del solver, pruebas Java/Python/HTTP, ejecución del DW MySQL y comprobación de descarga están en `evidencias/`. La declaración de IA distingue la asistencia realizada y el código previo.

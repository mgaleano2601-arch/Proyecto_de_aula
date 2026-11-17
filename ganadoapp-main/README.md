# BoviControl

Eder Castro, Mateo Garrido y Andrea Galeano. Proyecto de Aula Interdisciplinario, Ingeniería de Sistemas VII semestre, Tecnológico Comfenalco. Consolidación: 17 de noviembre de 2026.

## Entregables
- Documentos: informe técnico, informe metodológico con declaración de IA, modelo matemático e informe Power BI (PDF).
- Codigo_Fuente: Spring Boot, pruebas, microservicio Python y configuración sin claves.
- MySQL/BoviControl.sql: dump operativo de demostración de nueve tablas.
- PowerBI: proyecto PBIP completo, fuentes ficticias, DW y DAX.
- Evidencias: capturas reales IO, solicitudes/respuestas, pruebas y verificación de restauración.

## Versión
Repositorio de referencia: https://github.com/castrorojaseder565-jpg/Proyecto_de_aula
Commit base local: 3cc2c3b2380d4a1e3c46b9bb63b66a825b24178f.
La copia adjunta incluye cambios locales del módulo IO. No se ha publicado esta consolidación ni se ha verificado el acceso actual al remoto. La configuración principal externaliza DB_PASSWORD y permite DB_URL; no se cambió la lógica probada.

## Requisitos
Java 21, Maven 3.9 o wrapper, Python 3.11 o posterior compatible con requirements.txt, MySQL 8.4 y Power BI Desktop con soporte de proyectos PBIP/PBIR. Requiere acceso a Internet para resolver dependencias. CBC se obtiene con PuLP en plataformas compatibles; comprobar GET /health.

## Ejecutar una nueva demostración
Trabajar en la raíz de este código. Crear una base MySQL AISLADA y vacía llamada bovicontrol_taller, y un usuario propio con permisos sobre ella. El ejemplo usa puerto 3307; ajustar TALLER_DB_URL al puerto real.
Copiar .env.example a .env y completar TALLER_DB_USER, TALLER_DB_PASSWORD, APP_BOOTSTRAP_ADMIN_NAME, APP_BOOTSTRAP_ADMIN_EMAIL, APP_BOOTSTRAP_ADMIN_PASSWORD y app.taller.demo-password con valores propios. Activar APP_BOOTSTRAP_ADMIN_ENABLED=true para crear el administrador inicial. No publicar .env.

En una terminal dentro de optimizer-api:
```powershell
python -m venv .venv
.venv/Scripts/python -m pip install -r requirements.txt
.venv/Scripts/python -m uvicorn main:app --host 127.0.0.1 --port 8000
```
En otra terminal dentro de Codigo_Fuente:
```powershell
./mvnw.cmd spring-boot:run '-Dspring-boot.run.arguments=--spring.profiles.active=taller --app.taller.seed=true'
```
El perfil taller crea/actualiza las tablas en esa base de demostración. La semilla solo carga cuando no existen ganado, vacunas, atenciones ni turnos. La fecha del caso es 2026-11-04. Abrir http://127.0.0.1:8081, iniciar sesión con el administrador creado y consultar /optimizacion para esa fecha. OPTIMIZER_BASE_URL debe coincidir con el servicio Python. Desactivar la creación del administrador y la semilla después de inicializar.

## Restaurar la evidencia MySQL
El dump no crea bases ni usuarios. Importarlo en OTRA base vacía, por ejemplo bovicontrol_revision. Desde el cliente mysql autenticado ejecutar:
```sql
CREATE DATABASE bovicontrol_revision CHARACTER SET utf8mb4;
USE bovicontrol_revision;
SOURCE C:/ruta/a/MySQL/BoviControl.sql;
SELECT COUNT(*) FROM ganado;
SELECT COUNT(*) FROM io_run;
SELECT response_json FROM io_run;
```
Se esperan seis bovinos y una ejecución con objectiveValue 7. Las cuentas del dump son ficticias y contienen hashes; no se distribuyen contraseñas. Para navegar con credenciales propias usar la nueva demostración anterior. Restauracion_MySQL.json conserva la comparación realizada sobre el dump original.

## Pruebas
Desde Codigo_Fuente, con MySQL configurado, ejecutar ./mvnw.cmd test. Para Python instalar requirements-test.txt en el entorno del optimizador y ejecutar python -m pytest test_optimizer.py. Las evidencias Java/Python/HTTP incluidas corresponden a la ejecución histórica del 4 de noviembre, no a una repetición completa en esta consolidación.

## Power BI
Extraer todo el ZIP. Abrir PowerBI/PowerBI/BoviControl.pbip manteniendo juntas las carpetas Report y SemanticModel. Son datos ficticios incorporados con Power Query; no hay extracción automática de MySQL. El corte es 2026-10-07. El DW SQLite ha sido reconciliado; el script MySQL del DW no tiene ejecución acreditada. Apertura e interacciones de Desktop y acceso al enlace publicado están pendientes de validación.

## LLM y otros componentes
Groq es opcional: completar GROQ_API_KEY y GROQ_MODEL con una cuenta autorizada para validar una respuesta remota; no se incluyen claves ni se afirma una prueba remota. Sin clave existen respuestas limitadas por reglas. Weka realiza regresión lineal; CBC resuelve asignación binaria. No confundir estos tres mecanismos.

## Alcance de cierre
Los documentos explican la evidencia y sus límites. Falta acreditar la demostración de Power BI Desktop, una respuesta de Groq cuando se evalúe ese módulo, publicación/acceso del código final y revisión de observaciones docentes no recuperadas. No se afirma que la entrega esté completamente validada para Ferrum mientras falten esas comprobaciones.

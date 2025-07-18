# 🚀 Configuración CI/CD con GitHub Actions

## 📋 Secretos requeridos en GitHub

Ve a tu repositorio en GitHub → Settings → Secrets and variables → Actions

### Agrega estos secretos:

| Nombre | Valor | Descripción |
|--------|-------|-------------|
| `DBT_BIGQUERY_PROJECT_ID` | `bqni-466316` | ID del proyecto BigQuery |
| `DBT_BIGQUERY_LOCATION` | `europe-southwest1` | Región de BigQuery |
| `DBT_BIGQUERY_KEYFILE` | `{contenido del archivo JSON}` | Service account key completo |

### 📄 Para obtener DBT_BIGQUERY_KEYFILE:

```bash
# Copia todo el contenido del archivo JSON
cat credentials/bqni-466316-5723d789b549.json
```

Pega el contenido completo JSON en el secreto (incluye las llaves `{}`)

## 🔄 Flujo de trabajo

### 1. **Pull Request** → Branch cualquiera
- ✅ Ejecuta tests en datasets temporales (`dbt_ci_*`)
- ✅ Valida compilación 
- ✅ Ejecuta todos los tests
- ✅ Genera documentación

### 2. **Push to main** → Producción
- 🚀 Despliega a datasets de producción (`dbt_*`)
- 🚀 Ejecuta tests en producción
- 🚀 Actualiza documentación

## 📊 Estructura de datasets

### Desarrollo local:
```
bqni-466316.DEV_staging.*
bqni-466316.DEV_core.*
bqni-466316.DEV_marts.*
```

### CI (Pull Requests):
```
bqni-466316.dbt_ci_staging.*
bqni-466316.dbt_ci_core.*
bqni-466316.dbt_ci_marts.*
```

### Producción (main branch):
```
bqni-466316.dbt_staging.*
bqni-466316.dbt_core.*
bqni-466316.dbt_marts.*
```

## 🔧 Comandos útiles

```bash
# Test local antes de push
dbt compile
dbt run
dbt test

# Deploy manual a producción
dbt run --target prod
dbt test --target prod
```

## 🛡️ Permisos BigQuery requeridos

Tu service account necesita:
- **BigQuery Job User** - Para ejecutar queries
- **BigQuery Data Editor** - Para crear/modificar tablas
- **BigQuery User** - Acceso básico

## 🎯 Próximos pasos

1. **Configurar secretos** en GitHub
2. **Hacer primer commit** a una branch
3. **Crear Pull Request** para probar CI
4. **Merge a main** para deploy a producción 
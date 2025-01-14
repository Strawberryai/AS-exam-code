# Ejercicios del examen final de AS

## Ejercicio 1 - GitHub Actions

> NOTA: Se ha modificado el fichero `docker-compose.yml` para que construya la imagen desde el archivo _Ej1\_Dockerfile_

## Ejercicio 2 - Elasticsearch

Crear índice _servidores_ con un mapping específico:
```bash
curl -XPUT "34.140.13.252:9200/servidores" -H 'Content-Type: application/json' -d'
{
    "mappings" : {
        "properties" : {
            "fabricante" : {"type": "text" },
            "nombre" : {"type": "text" },
            "precio" : {"type": "float" }
        }
    }
}
'
```

Crear índice _logs_ con un mapping específico:
```bash
curl -XPUT "34.140.13.252:9200/logs" -H 'Content-Type: application/json' -d'
{
    "mappings" : {
        "properties" : {
            "emisor" : {"type": "text" },
            "fecha" : {"type": "date" },
            "mensaje" : {"type": "text" }
        }
    }
}
'
```

Añadir datos al índice _servidores_:
```bash
curl --location '34.140.13.252:9200/servidores/_bulk' \
--header 'Content-Type: application/json' \
--data '{"index": {"_id": 1}}
{"fabricante": "Dell", "nombre": "PowerEdge R6", "precio": 4200.4}
{"index": {"_id": 2}}
{"fabricante": "Dell", "nombre": "PowerEdge R7", "precio": 7200.7}
{"index": {"_id": 3}}
{"fabricante": "HP", "nombre": "ProLiant RL", "precio": 8110.2}
'
```

Cargar datos al índice _logs_ desde un archivo:
```bash
curl -H "Content-Type: application/json" -XPOST "34.140.13.252:9200/logs/_bulk?pretty&refresh" --data-binary "@ej2_logs.json"
```

Modificar el campo precio del servidor _Dell PowerEdge R7_ con el valor _9010.5_ (sabemos que tiene el id 2):
```bash
curl --location '34.140.13.252:9200/servidores/_update/2' \
--header 'Content-Type: application/json' \
--data '{
    "doc":{
        "precio": 9010.5
    }
}'
```

Búsqueda de los servidores con precio inferior a 8000:
```bash
curl --location --request GET '34.140.13.252:9200/servidores/_search' \
--header 'Content-Type: application/json' \
--data '{
    "query":{
        "range":{ 
            "precio": { "lt": 8000}
            }
    }
}'
```

Búsqueda de los servidores fabricados por _Dell_ usando "edll" como término de búsqueda (fuzzy finding):
```bash
curl --location --request GET '34.140.13.252:9200/servidores/_search' \
--header 'Content-Type: application/json' \
--data '{
  "query": { "fuzzy": { "fabricante": "edll" } }
}'
```

Búsqueda de los logs cuyo emisor termine por "d":
```bash
curl --location --request GET '34.140.13.252:9200/logs/_search' \
--header 'Content-Type: application/json' \
--data '{
  "query": { "wildcard": { "emisor": "*d" } }
}'
```

Búsqueda de los todos los log ordenados por fecha de forma ascendente:
```bash
curl --location --request GET '34.140.13.252:9200/logs/_search' \
--header 'Content-Type: application/json' \
--data '{
  "sort": { "fecha": { "order": "asc" } }
}'
```

Eliminar los documentos cuyo fabricante sea _HP_ del índice _servidores_:
```bash
curl --location '34.140.13.252:9200/servidores/_delete_by_query' \
--header 'Content-Type: application/json' \
--data '{
  "query": {
    "match": {
      "fabricante": "hp"
    }
  }
}'
```


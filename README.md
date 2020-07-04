# Ejemplo de biblioteca RESTful en Spring Boot

[![Build Status](https://travis-ci.com/andylarquy/biblioteca-springboot.svg?branch=master)](https://travis-ci.com/andylarquy/biblioteca-springboot)

Demostración de uso de [Spring Boot](https://spring.io/projects/spring-boot) sobre cómo declarar y probar una API REST con operaciones CRUD y búsqueda.


## Implementación 

| package | descripción |
| --- | --- |
| `org.uqbar.biblioteca.domian`      | Modelo de dominio (Biblioteca y Libro) |
| `org.uqbar.biblioteca.controller`       | Definición Spring Boot de la API REST (detalles [más abajo](#api-rest-en-ejemplos)) |
| `org.uqbar.biblioteca.BibliotecaApplication`        | El `main` que levanta un servidor HTTP y inicializa un modelo con libros de prueba |


## API REST en ejemplos

| operation                 | request                   | response status | response description | 
| --- | --- | --- | --- |
| Obtener todos los libros  | `GET /libros`             | 200 OK          | Lista de todos los libros |
| | | | |
| Obtener un libro por id   | `GET /libros/7`           | 200 OK          | Un libro con el id indicado (`7`) |
|                           | `GET /libros/88888`       | 404 Not Found   | No hay libro con el id indicado (`88888`) |
|                           | `GET /libros/Ficc`        | 400 Bad Request | Id mal formado (`Ficc` no es un entero) |
| | | | |
| Buscar libros por título  | `GET /libros?string=Ficc` | 200 OK          | Lista de libros que contengan `ficc` (ignorando mayúsculas/minúsculas) |
| | | | |
| Crear/modificar libro     | `POST /libros` (BODY bien)| 200 OK          | El libro recibido en el BODY (formato JSON) ahora pertenece a la biblioteca |
|                           | `POST /libros` (BODY mal) | 400 Bad Request | No pudo leerse al BODY como instancia de `org.uqbar.biblioteca.domain.Libro` |
| | | | |
| Borrar libro              | `DELETE /libros/7`        | 200 OK          | Borra el libro con id `7` |
|                           | `DELETE /libros/88888`    | 400 Bad Request | No hay libro con id `88888` |
|                           | `DELETE /libros/Ficc`     | 400 Bad Request | Id mal formado (`Ficc` no es un entero) |

**Atención**: La implementación usa formato JSON en el BODY, tanto en request como en response.


## Modo de uso

### Cómo levantar

#### Opción A: Desde Eclipse

1. Importar este proyecto en Eclipse como **Maven project**.
2. Ejecutar `org.uqbar.biblioteca.BibliotecaApp`, que levanta el servidor en el puerto 8080.

#### Opción B: Desde línea de comandos

1. Compilar y ejecutar el proyecto con el wrapper de maven: `./mvnw spring-boot:run`

Esta opción requiere menos recursos de sistema porque no es necesario ejecutar Eclipse.

### Cómo probar

Probar los [ejemplos de API REST](#api-rest-en-ejemplos)
   * en el navegador: <http://localhost:8080/libros>
   * en [Postman](https://www.getpostman.com/), importar [este archivo](Biblioteca.postman_collection.json) que provee varios ejemplos de request listos para usar.

Si querés ver una demo de cómo probarlo, podés chequear [este link](https://github.com/uqbar-project/eg-tareas-springboot).


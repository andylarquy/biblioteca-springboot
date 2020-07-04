package org.uqbar.biblioteca.controller

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.databind.exc.InvalidFormatException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException
import org.uqbar.biblioteca.domain.Biblioteca
import org.uqbar.biblioteca.domain.Libro

@RestController
class BibliotecaController {

	/* TODO: Tuve problemas para encontrar la manera de inyectar
	 * la biblioteca en el constructor, estaría bueno así podes
	 * arrancar con libros ya cargados
	 */
	Biblioteca biblioteca = new Biblioteca => [

		val libro1 = new Libro() => [
			id = 1
			titulo = "Juancito y los clonosaurios"
		]

		libros.add(libro1)
	]

	/**
	 * Permite buscar libros que contengan cierto string en su título, u obtener todos los libros.
	 *  
	 * Atiende requests de la forma GET /libros y GET /libros?titulo=xxx.
	 */
	@GetMapping(value="/libros")
	def getLibros(@RequestParam(value="titulo", required=false) String titulo) {
		this.biblioteca.searchLibros(titulo)
	}

	/**
	 * Permite obtener un libro por su id.
	 * 
	 * Atiende requests de la forma GET /libros/17.
	 */
	@GetMapping(value="/libros/{id}")
	def getLibroById(@PathVariable String id) {
		try {
			var libro = this.biblioteca.getLibro(Integer.valueOf(id))

			if (libro === null) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					getErrorJson("No existe libro con el identificador " + id))
			} else {
				return libro
			}
		} catch (NumberFormatException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson("El id debe ser un número entero"))
		}
	}

	/**
	 * Permite eliminar un libro por su id.
	 * 
	 * Atiende requests de la forma DELETE /libros/7.
	 */
	@DeleteMapping("/libros/{id}")
	def deleteLibroById(@PathVariable String id) {
		try {
			val eliminadoOk = this.biblioteca.eliminarLibro(Integer.valueOf(id))
			if (eliminadoOk) {
				new ResponseEntity('{"status":200, "message":"ok"}', HttpStatus.OK)
			} else {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					getErrorJson("No existe el libro con identificador " + id))
			}
		} catch (NumberFormatException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson("El id debe ser un número entero"))
		}
	}

	/**
	 * Permite crear o modificar un libro.
	 * 
	 * Atiende requests de la forma POST /libros con un libro en el body (en formato JSON).
	 */
	@PostMapping("/libros")
	def createLibro(@RequestBody String nuevoLibro) {
		try {
			val Libro libro = mapper.readValue(nuevoLibro, Libro)
			try {
				this.biblioteca.setLibro(libro)
				new ResponseEntity('{"status":200, "message":"ok"}', HttpStatus.OK)
			} catch (Exception exception) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson(exception.message))
			}
		} catch (InvalidFormatException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson("El body debe ser un Libro"))
		}
	}

	private def getErrorJson(String message) {
		'{ "error": "' + message + '" }'
	}

	static def mapper() {
		new ObjectMapper => [
			configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			configure(SerializationFeature.INDENT_OUTPUT, true)
		]
	}

}

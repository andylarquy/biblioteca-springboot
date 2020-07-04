package org.uqbar.biblioteca.controller

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
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

	@GetMapping(value="/libros")
	def getLibros(@RequestParam(value="contenido", required=false) String contenido) {
		this.biblioteca.searchLibros(contenido)
	}

	@GetMapping(value="/libros/{id}")
	def getLibroById(@PathVariable String id) {
		try {
			var libro = this.biblioteca.getLibro(Integer.valueOf(id))

			if (libro === null) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson("No existe libro con el identificador " + id))
			} else {
				return libro
			}
		} catch (NumberFormatException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson("El id debe ser un número entero"))
		}
	}

	@DeleteMapping("/libros/{id}")
	def deleteLibroById(@PathVariable String id) {
		try {
			val eliminadoOk = this.biblioteca.eliminarLibro(Integer.valueOf(id))
			if (eliminadoOk) {
				new ResponseEntity('{"status":200, "message":"ok"}', HttpStatus.OK)
			} else {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson("No existe el libro con identificador " + id))
			}
		} catch (NumberFormatException exception) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, getErrorJson("El id debe ser un número entero"))
		}
	}

	private def getErrorJson(String message) {
		'{ "error": "' + message + '" }'
	}
}

/*
 *  TODO: Traducir de XTrest
 *  
 * @Post("/libros")
 *    def createLibro(@Body String body) {
 *        try {
 *            val Libro libro = body.fromJson(Libro)
 *            try {
 *                this.biblioteca.setLibro(libro)
 *                return ok()
 *            } catch (UserException exception) {
 *                return badRequest(getErrorJson(exception.message))
 *            }
 *        } catch (UnrecognizedPropertyException exception) {
 *            return badRequest(getErrorJson("El body debe ser un Libro"))
 *        }
 *    }
 */

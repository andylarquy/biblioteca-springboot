package org.uqbar.biblioteca.controller

import java.time.LocalDateTime
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException

@RestController
class BibliotecaController {

	//Tenemos de referencia el controller de saludador
	Saludador saludador = new Saludador()

	@GetMapping(value="/saludoDefault")
	def darSaludo() {
		this.saludador.buildSaludo()
	}

	@GetMapping(value="/saludo/{persona}")
	def darSaludoCustom(@PathVariable String persona) {
		this.saludador.buildSaludoCustom("Hola " + persona + "!")
	}

	@PutMapping(value="/saludoDefault")
	def actualizarSaludo(@RequestBody String nuevoSaludo) {
		try {
			this.saludador.cambiarSaludoDefault(nuevoSaludo)
			new ResponseEntity("Se actualizó el saludo correctamente", HttpStatus.OK)
		} catch (BusinessException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, e.message)
		}
	}


/*
 *  TODO: Traducir de XTrest
 *  
 *  @Get("/libros")
 * 	def getLibros(String string) {
 *     return ok(this.biblioteca.searchLibros(string).toJson)
 * 	}
 */
 
 
/*
 *  TODO: Traducir de XTrest
 *  
 * @Get("/libros/:id")
 *    def getLibroById() {
 *        try {
 *            var libro = this.biblioteca.getLibro(Integer.valueOf(id))
 *            if (libro === null) {
 *                return notFound(getErrorJson("No existe libro con el identificador " + id))
 *            } else {
 *                return ok(libro.toJson)
 *            }
 *        } catch (NumberFormatException exception) {
 *            return badRequest(getErrorJson("El id debe ser un número entero"))
 *        }
 *    }
 */
 
 
/*
 *  TODO: Traducir de XTrest
 *  
 * @Delete('/libros/:id')
 *    def deleteLibroById() {
 *        try {
 *            val eliminadoOk = this.biblioteca.eliminarLibro(Integer.valueOf(id))
 *            return if (eliminadoOk) ok() else badRequest(getErrorJson("No existe el libro con identificador " + id))
 *        } catch (NumberFormatException exception) {
 *            return badRequest(getErrorJson("El id debe ser un número entero"))
 *        }
 *    }
 */


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

/*
 *    private def getErrorJson(String message) {
 *        '{ "error": "' + message + '" }'
 *    }
 */
 
 
}

class Saludador {
	static int ultimoId = 1
	public static String DODAIN = "dodain"

	@Accessors String saludoDefault = "Hola mundo!"

	def buildSaludo() {
		buildSaludoCustom(this.saludoDefault)
	}

	def buildSaludoCustom(String mensaje) {
		new Saludo(ultimoId++, mensaje)
	}

	def cambiarSaludoDefault(String nuevoSaludo) {
		if (nuevoSaludo.equalsIgnoreCase(DODAIN)) {
			throw new BusinessException("No se puede saludar a " + DODAIN)
		}
		this.saludoDefault = nuevoSaludo
	}
}

@Data
class Saludo {
	int id
	String saludo
	LocalDateTime fechaCreacion = LocalDateTime.now
}

class BusinessException extends RuntimeException {

	new(String msg) {
		super(msg)
	}

}

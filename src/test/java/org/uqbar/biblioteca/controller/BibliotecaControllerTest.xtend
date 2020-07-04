package org.uqbar.biblioteca.controller

import org.springframework.boot.test.autoconfigure.json.AutoConfigureJsonTesters
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.test.annotation.DirtiesContext
import org.springframework.test.annotation.DirtiesContext.ClassMode
import org.springframework.test.context.ContextConfiguration

@AutoConfigureJsonTesters
@ContextConfiguration(classes=BibliotecaController)
@WebMvcTest
@DirtiesContext(classMode = ClassMode.BEFORE_EACH_TEST_METHOD)
class BibliotecaControllerTest {

	
}

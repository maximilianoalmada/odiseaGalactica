import wollok.game.*
import juego.*
import nivel1.*
import nivel2.*
import nivel3.*
import logicaNiveles.*

object inicio{

	method config() {
	    
		//titulo y limites del juego
		game.title("Odisea Galáctica")
		game.height(15)
		game.width(25)
		game.clear()
		pantallaInicial.configurar()
	}
}

class Pantalla {
	var property position = game.at(0,0)
	const audioEnter = "controlesYnivel.mp3"
	method image() = null
}

class PantallaNivel inherits Pantalla {
	var nivelActual

	method configurar() {
			game.addVisual(self)
			game.sound(audioEnter).play()
			keyboard.enter().onPressDo{self.pasarAlNivel()}

	}
	method pasarAlNivel() {
		sonidoEnter.sonar()
		nivelActual.config()
	}
}

class PantallaNoNivel inherits Pantalla {
	var pantallaSiguiente
	
	method configurar() {
		if (pantallaSiguiente != null) {
			game.addVisual(self)
			sonidoPantallas.sonar()
			keyboard.enter().onPressDo{self.pasarASiguientePantalla()}	
		} else {
			game.addVisual(self)
			keyboard.q().onPressDo {game.stop()}
		}

	}
	method pasarASiguientePantalla() {
			game.clear()
			pantallaSiguiente.configurar()
	}
}

object pantallaInicial inherits PantallaNoNivel(audioEnter = "empezar.mp3", pantallaSiguiente = pantallaControles) {	
	var imagen = "inicio2.png"
	
	override method image()= imagen
	
	override method configurar() {
			game.addVisual(self)
			game.onTick(500, "cambiarImagen", {self.cambiarImagen()})
			game.schedule(1,{sonidoMenuPrincipal.sonar()})
			keyboard.enter().onPressDo{self.pasarSacandoAudio()}

	}
	
	method pasarSacandoAudio() {
		sonidoMenuPrincipal.pausa()
		self.pasarASiguientePantalla()
	}
	
	method cambiarImagen() {
		if (self.image() == "inicio1.png") {
			imagen = "inicio2.png"
		} else {
			imagen = "inicio1.png"
		}
	}
}

object pantallaControles inherits PantallaNoNivel(audioEnter = "empezar.mp3", pantallaSiguiente = pantallaControles2) {
	override method image()= "controles.png"
}

object pantallaControles2 inherits PantallaNoNivel(audioEnter = "empezar.mp3", pantallaSiguiente = pantallaNivel1) {
	override method image()= "controles2.png"
}

object pantallaNivel1 inherits PantallaNivel(nivelActual = nivel1) {
	override method image()= "instr1.png"
	
}

object pantallaNivel2 inherits PantallaNivel(nivelActual = nivel2) {
	override method image()= "instr2.png"
	
}

object pantallaNivel3 inherits PantallaNivel(nivelActual = nivel3) {
	override method image()= "instr3.png"
	
}

object pantallaPerdiste inherits PantallaNoNivel(pantallaSiguiente = null) {
	override method image()= "perdiste.png"
}

object pantallaGanaste  inherits PantallaNoNivel(pantallaSiguiente = null) {
	override method image()= "ganaste.png"	
}
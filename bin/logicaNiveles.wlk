import wollok.game.*
import juego.*
import consola.*
import nivel1.*
import nivel2.*
import nivel3.*

class LogicaNivel {
	const property audioNivel
	const property perdisteAudio = game.sound("perdiste.mp3")
	
	method config(){

		game.clear()
	    audioNivel.shouldLoop(true)
	    keyboard.w().onPressDo({audioNivel.volume(1)})
		keyboard.e().onPressDo({audioNivel.volume(0.5)})
		keyboard.r().onPressDo({audioNivel.volume(0)})
	    game.schedule(500, {audioNivel.play()})
			
		self.personajes()
		self.colisiones()
		self.onTick()
		
		keyboard.up().onPressDo { if (naveInicial.puedeMoverArriba()) naveInicial.subir()}
		keyboard.down().onPressDo { if (naveInicial.puedeMoverAbajo()) naveInicial.bajar()}
		keyboard.left().onPressDo { if (naveInicial.puedeMoverIzquierda()) naveInicial.izquierda()}
		keyboard.right().onPressDo { if(naveInicial.puedeMoverDerecha()) naveInicial.derecha()}		
		keyboard.space().onPressDo({naveInicial.disparar()})
		
	}
	
	method visuales()
	
	method personajes(){		
		self.visuales().forEach({x => game.addVisual(x)})
	}
	
	method colisiones(){
		game.onCollideDo(naveInicial,{algo=>algo.teChoco(naveInicial)})
	}
	
	method onTick() {}
	

	
}

object sonidoPantallas {
	method sonar() {
		const sonido = game.sound("empezar.mp3")
		sonido.play()
	}
}

object sonidoEnter {
		method sonar() {
		const sonido = game.sound("empezar.mp3")
		sonido.play()
	}
}

object disparoNave {
		method sonar() {
		const sonido = game.sound("disparoNave.mp3")
		sonido.play()
	}
}

object disparoNaveMejorada {
		method sonar() {
		const sonido = game.sound("disparoNaveMejorada.mp3")
		sonido.play()
	}
}

object disparoAcorazado {
		method sonar() {
		const sonido = game.sound("disparoAcorazado.mp3")
		sonido.play()
	}
}

object sonidoPerderVida {
		method sonar() {
		const sonido = game.sound("perderVida.mp3")
		sonido.play()
	}
}

object sonidoMorir {
		method sonar() {
		const sonido = game.sound("morirNave.wav")
		sonido.play()
	}
}

object sonidoMorirNivel3 {
		method sonar() {
		const sonido = game.sound("morirAcorazado.mp3")
		sonido.play()
	}
}

object sonidoMenuPrincipal {
	const sonido = game.sound("menuprincipal.wav")
		method sonar() {
		sonido.play()
	}
		method pausa() {
		sonido.pause()
		}
}

object sonidoAgarrarPieza {
		method sonar() {
		const sonido = game.sound("agarrarpieza.mp3")
		sonido.play()
	}
}
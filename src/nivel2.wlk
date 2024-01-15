import wollok.game.*
import juego.*
import consola.*
import nivel1.*
import nivel3.*
import logicaNiveles.*


object nivel2 inherits LogicaNivel (audioNivel = game.sound("nivel2.mp3")){
	const property fondoNivel2 = new Fondo (image= "fondo2.png")
	const pieza1 = new Piezas(numero = 1)
	const pieza2 = new Piezas(numero = 2)
	const pieza3 = new Piezas(numero = 3)
	const pieza4 = new Piezas(numero = 4)
	const pieza5 = new Piezas(numero = 5)
	const pieza6 = new Piezas(numero = 6)
	const pieza7 = new Piezas(numero = 7)
	const tanqueNafta1 = new TanqueDeNafta()
	const tanqueNafta2 = new TanqueDeNafta()
	
	override method visuales() = [fondoNivel2,naveInicial,vidas,contadorNafta,reloj, contrareloj,tanqueNafta1,tanqueNafta2,cantidadNafta,contadorPieza, cantidadPieza,pieza1,pieza2,pieza3,pieza4,pieza5,pieza6,pieza7]
	
	method pasarASiguientePantalla() {
		if (naveInicial.objetosRecogidos() == 7) {
			audioNivel.pause()
			game.clear()
			pantallaNivel3.configurar()
		}
	}
		
	method perder() {
		const perdiste2 = game.sound("perdiste2.mp3")
		if (contrareloj.reloj() == 0) {
				game.clear()
				audioNivel.pause()
				perdisteAudio.play()
				pantallaPerdiste.configurar()
				
		  	}
		}
	
	override method config(){
		super()
		naveInicial.nafta(400)
	}	

	override method colisiones(){
		game.onCollideDo(naveInicial,{algo=>algo.teChoco(naveInicial)})
	}
	
	override method onTick(){
		game.onTick(1,"actualizar contador nafta",{cantidadNafta.actualizar()})
		game.onTick(1, "actualizar contador piezas", {cantidadPieza.actualizar()})
		game.onTick(1000, "actualizar reloj", {contrareloj.actualizar()})
		game.onTick(1, "pasar de nivel", {self.pasarASiguientePantalla()})
		game.onTick(1, "perder por tiempo", {self.perder()})
	}
}

object reloj{	
	var property position = game.at(11,14)
	var property image = "tiempoContador.png" 
	method teChoco(algo) {}
	}

object contrareloj{
	var property position = game.at(13,14)
	var property reloj = 25	
	var text = self.reloj()
	var property textColor= "#FFFFFF"
	
	method actualizar(){
		self.restarSegundo()
		text = self.reloj()
	}
	
	method text() = text.toString()
	
	method restarSegundo(){
		reloj -= 1
	}
	method teChoco(algo) {}
}

object cantidadPieza{
	var property position = game.at(4,11)
	var text = naveInicial.objetosRecogidos()
	var property textColor= "#FFFFFF"
	
	method actualizar(){
		text = naveInicial.objetosRecogidos()
	}
	
	method text() = text.toString()
	method teChoco(algo) {}
}

object contadorPieza{	
	var property position = game.at(1,11)
	var property image = "contadorPiezas.png" 
	method teChoco(algo) {}
}
	
class Piezas{
	var property numero
	var property position = game.at(4.randomUpTo(game.width()-1).truncate(0),1.randomUpTo(game.height()-1).truncate(0))
	
	method image() = "pieza" + numero.toString() + ".png"
	
	method teChoco(unaNave) {
		sonidoAgarrarPieza.sonar()
	 	unaNave.recogerPieza(self)
	 }
	
}